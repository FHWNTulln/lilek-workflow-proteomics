---
output:
  html_document:
    df_print: paged
    fig.align: center
    self_contained: yes
    fig.height: 4
    fig.width: 8
    theme: united
    toc: yes
    toc_depth: 4
    toc_float: yes
    number_sections: yes
    code_folding: hide
params:
  title: 
    label: "Title"
    value: "DataAnalysis - Postprocessing Results MaxQuant"
  author:
    label: "Author"
    value: ""
  path:
    label: "File path"
    value: "N:/1_A_Bachelor_Master_Intern/00_M_2022/David/Data/11_20220713_TR/mqpar_20220713_QC/proteinGroups.txt"
  unique: 
    label: "Number of unique peptides for identification"
    value: 2
  protein_types:
    label: "Protein types"
    input: select 
    value: ["RAZOR","UNIQUE","LFQ"]
    multiple: TRUE
    choices: ["RAZOR","UNIQUE","LFQ"]  
  SAVE: 
    label: "Save summarized results"
    value: "FALSE"
    input: select
    choices: ["FALSE","CSV","RDS"]
title: "DataAnalysis - Postprocessing Results MaxQuant"
author: ""
date: "26 July 2022, 12:23:10 PM"
---

# Global Parameters 


```r
###############################
#
#define settings
#
###############################

GET_SAMPLE_NAMES <- TRUE # if set to FALSE define it in the next line
#sample_names_user <- c()

unique <- params$unique  # how many peptides should be at least necessary to identify a protein


# which types should be evaluated TRUE or FALSE could be used
RAZOR <- FALSE
UNIQUE <- FALSE
LFQ <- FALSE
if (any(grepl("RAZOR",params$protein_types))){
  RAZOR <- TRUE
}
if (any(grepl("UNIQUE",params$protein_types))){
  UNIQUE <- TRUE
}
if (any(grepl("LFQ",params$protein_types))){
  LFQ <- TRUE
}
LFQ <- FALSE

# define path of the proteinGroups.txt file(s)
path = params$path

# save files | options
# FALSE - results are not saved
# "RDS" - save results into R data file format
# "CSV" - save results into a csv file
SAVE <- "FALSE"
if (any(grepl("RDS",params$SAVE))){
  SAVE <- "RDS"
}
if (any(grepl("CSV",params$SAVE))){
  SAVE <- "CSV"
}
```

# Introduction

## Unique | Razor&Unique procedure

Filtering:

-   `Potential.contaminant != "+"` -> remove where contaminants
-   `Reverse != "+"`-> remove where reverse = +
-   `Only.identified.by.site != "+"` -> remove where only identified by site = +

-   `data[name] >= unique` -> keep only identifications which have greater or equal number (defined via variable `unique`) of `razor/unique peptides ` | typically this is set to 1 or 2

`Data analysis` show the number of identified proteins and the heatmap. In `Summary` the final results are visualized as boxplot and a table with the summarized values is shown.

## LFQ-Procedure

Filtering:

-   `Potential.contaminant != "+"` -> remove where contaminants = +
-   `Reverse != "+"`-> remove where reverse = +
-   `Only.identified.by.site != "+"` -> remove where only identified by site = +

Then the `log2`of the LFQ intensities is calculated and all `-Inf` values were substituted by NA using the following command: `lfq[lfq == -Inf] <- NA`

`Data analysis` show the number of identified proteins and the heatmap. In `Summary` the final results are visualized as boxplot and a table with the summarized values is shown.

# Load required packages and functions




```r
# load libraries
library(tidyverse)
library(dplyr)
library(pheatmap)
library(ggplot2)
#library(reshape)
library(knitr)
# load functions
filtering <- function(d){
  data_raw %>% filter( 
    Potential.contaminant != "+",
    Reverse != "+",
    Only.identified.by.site != "+")
}
print("loading sucessful")
```

```
## [1] "loading sucessful"
```

# Data Analysis

The txt-files of the defined folder are read in, processed and filtered automatically. This section shows the code, heatmaps for LFQ values and also some summary statistics.


```r
infile <- read.csv(path, dec=".", sep="\t")
res_raw <- list(infile)
file.list <- c("test")
########## get sample names
if (GET_SAMPLE_NAMES == TRUE){
  #get sample names
  tmp <- colnames(res_raw[[1]])
  tmp <- tmp[grep("Razor...unique.peptides.",tmp)]
  tmp <- sub(".*Razor...unique.peptides.", "",tmp)
  sample_names_raw <- tmp
  rm(tmp)
  #create sample names
  sample_names_razor <- paste("Razor...unique.peptides.",sample_names_raw, sep="")
  sample_names_unique <- paste("Unique.peptides.",sample_names_raw, sep="")
  sample_names_lfq <- paste("LFQ.intensity.",sample_names_raw, sep="")
} else {
    res_raw[[1]] <- res_raw[[1]] %>%
       rename_with(~ paste("Razor_", sample_names_user, sep = ""),
                   starts_with("Razor...unique.peptides.")) %>%
       rename_with(~ paste("Unique_", sample_names_user, sep = ""),
                   starts_with("Unique.peptides.")) %>%
       rename_with(~ paste("LFQ_", sample_names_user, sep = ""),
                   starts_with("LFQ.intensity."))
    # get column names
    sample_names_razor <- colnames(res_raw[[i]][grep("Razor_",
                                                colnames(res_raw[[i]]))])
    sample_names_unique <- colnames(res_raw[[i]][grep("Unique_",
                                                colnames(res_raw[[i]]))])
    sample_names_lfq <- colnames(res_raw[[i]][grep("LFQ_",
                                                 colnames(res_raw[[i]]))])
}

########## create result data frame & result lists
# create data frame for razor
results_2gether_razor <- data.frame(matrix(ncol = length(sample_names_razor), nrow = 1))
colnames(results_2gether_razor) <- sample_names_razor
#create data frame for unique
results_2gether_unique <- data.frame(matrix(ncol = length(sample_names_unique), nrow = 1))
colnames(results_2gether_unique) <- sample_names_unique
#create data frame for lfq
results_2gether_lfq <- data.frame(matrix(ncol = length(sample_names_lfq), nrow = 1))
colnames(results_2gether_lfq) <- sample_names_lfq

#results lists
results_razor <- list()
results_unique <- list()
results_lfq <- list()

########## perform evaluation
if (RAZOR == TRUE) {
  cat("\n")
  cat("##","Razor","\n")
  cat("\n")
    data_raw <- as.data.frame(res_raw[[1]])
    data <- filtering(data_raw)
    results <- data.frame(matrix(ncol = length(sample_names_razor), nrow = nrow(data)))
    colnames(results) <- sample_names_razor
    i <- 0
    for (i in 1:length(sample_names_razor)){
      name <- sample_names_razor[i]
      tmp <- (data[name] >= unique)
      results[i] <- tmp
      cat(name,"<br/>",sum(tmp, na.rm = TRUE),"<br/>")
    }
    results_razor[[1]] <- results
    results_2gether_razor[1,] <- sapply(results,function(x)sum(x, na.rm = TRUE))
    cat("\n")
    
        #create heatmaps
    paletteLength <- 2
    myColor <- colorRampPalette(c("navy", "white",
                                  "firebrick3"))(paletteLength)
      data4pheatmap <- results
      data4pheatmap <- data4pheatmap*1
      data4pheatmap[data4pheatmap == 0] <- NA
      # remove NA rows
      ind <- apply(data4pheatmap, 1, function(x) all(is.na(x)))
      data4pheatmap_clear <- data4pheatmap[!ind,]
      data4pheatmap_clear[is.na(data4pheatmap_clear)] <- 0
      if (ncol(data4pheatmap_clear) < 2){
        cat("\n")
        cat("##"," No heatmap possible. Too less columns in the result
            table.","\n")
      } else {
        pheatmap(data4pheatmap_clear,
                 legend_breaks = c(0,1),
                 color = myColor,
                 treeheight_row = 10,
                 angle_col ="45",
                 treeheight_col = 10,
                 legend = TRUE,
                 labels_row = rep("",nrow(data4pheatmap)),
                 labels_col = sample_names_raw)
        cat("\n")
      }
  
}
```


## Razor 

Razor...unique.peptides.D2_pool20_B1 <br/> 131 <br/>Razor...unique.peptides.D2_pool20_B10 <br/> 285 <br/>Razor...unique.peptides.D2_pool20_B2 <br/> 173 <br/>Razor...unique.peptides.D2_pool20_B3 <br/> 175 <br/>Razor...unique.peptides.D2_pool20_B4 <br/> 215 <br/>Razor...unique.peptides.D2_pool20_B5 <br/> 427 <br/>Razor...unique.peptides.D2_pool20_B6 <br/> 282 <br/>Razor...unique.peptides.D2_pool20_B7 <br/> 523 <br/>Razor...unique.peptides.D2_pool20_B8 <br/> 464 <br/>Razor...unique.peptides.D2_pool20_B9 <br/> 390 <br/>
<img src="post-processing-4-automated-dataanalysis_files/figure-html/unnamed-chunk-3-1.png" width="672" />

```r
if (UNIQUE == TRUE) {
  cat("\n")
  cat("##","Unique","\n")
  cat("\n")
    data_raw <- as.data.frame(res_raw[[1]])
    data <- filtering(data_raw)
    results <- data.frame(matrix(ncol = length(sample_names_unique), nrow = nrow(data)))
    colnames(results) <- sample_names_unique
    i <- 0
    for (i in 1:length(sample_names_unique)){
      name <- sample_names_unique[i]
      tmp <- (data[name] >= unique)
      results[i] <- tmp
      cat(name,"<br/>",sum(tmp, na.rm = TRUE),"<br/>")
    }
    results_unique[[1]] <- results
    results_2gether_unique[1,] <- sapply(results,function(x)sum(x, na.rm = TRUE))
    cat("\n")
    #create heatmaps
    paletteLength <- 2
    myColor <- colorRampPalette(c("navy", "white",
                                  "firebrick3"))(paletteLength)
      data4pheatmap <- results
      data4pheatmap <- data4pheatmap*1
      data4pheatmap[data4pheatmap == 0] <- NA
      # remove NA rows
      ind <- apply(data4pheatmap, 1, function(x) all(is.na(x)))
      data4pheatmap_clear <- data4pheatmap[!ind,]
      data4pheatmap_clear[is.na(data4pheatmap_clear)] <- 0
      if (ncol(data4pheatmap) < 2){
        cat("\n")
        cat("##"," No heatmap possible. Too less columns in the result
            table.","\n")
      } else {
        pheatmap(data4pheatmap_clear,
                 legend_breaks = c(0,1),
                 color = myColor,
                 treeheight_row = 10,
                 angle_col ="45",
                 treeheight_col = 10,
                 legend = TRUE,
                 labels_row = rep("",nrow(data4pheatmap)),
                 labels_col = sample_names_raw)
        cat("\n")
      }
}
```


## Unique 

Unique.peptides.D2_pool20_B1 <br/> 129 <br/>Unique.peptides.D2_pool20_B10 <br/> 279 <br/>Unique.peptides.D2_pool20_B2 <br/> 170 <br/>Unique.peptides.D2_pool20_B3 <br/> 173 <br/>Unique.peptides.D2_pool20_B4 <br/> 209 <br/>Unique.peptides.D2_pool20_B5 <br/> 419 <br/>Unique.peptides.D2_pool20_B6 <br/> 277 <br/>Unique.peptides.D2_pool20_B7 <br/> 519 <br/>Unique.peptides.D2_pool20_B8 <br/> 457 <br/>Unique.peptides.D2_pool20_B9 <br/> 383 <br/>
<img src="post-processing-4-automated-dataanalysis_files/figure-html/unnamed-chunk-3-2.png" width="672" />

```r
if (LFQ == TRUE) {
  cat("\n")
  cat("##","LFQ","\n")
  cat("\n")
    data_raw <- as.data.frame(res_raw[[1]])
    data <- filtering(data_raw)
    
    results <- data.frame(matrix(ncol = length(sample_names_lfq), nrow = nrow(data)))
    colnames(results) <- sample_names_lfq
    i <- 0
    for (i in 1:length(sample_names_lfq)){
      name <- sample_names_lfq[i]
      tmp <- log2(data[name])
      tmp[tmp == -Inf] <- NA
      results[i] <- tmp
      cat(name,"<br/>",sum(!is.na(tmp)),"<br/>")
      
    }
    
    results_lfq[[1]] <- results
    results_2gether_lfq[1,] <- sapply(results,function(x)sum(!is.na(x)))
    cat("\n")
    
    #create heatmaps
    paletteLength <- 50
    myColor <- colorRampPalette(c("navy", "white",
                                  "firebrick3"))(paletteLength)
      data4pheatmap <- results
      data4pheatmap <- results
      data4pheatmap <- data4pheatmap*1
      data4pheatmap[data4pheatmap == 0] <- NA
      # remove NA rows
      ind <- apply(data4pheatmap, 1, function(x) all(is.na(x)))
      data4pheatmap_clear <- data4pheatmap[!ind,]
      data4pheatmap_clear[is.na(data4pheatmap_clear)] <- 0
      if (ncol(data4pheatmap) < 2){
        cat("\n")
        cat("##"," No heatmap possible. Too less columns in the result
            table.","\n")
      } else {
        pheatmap(data4pheatmap_clear,
                 color = myColor,
                 treeheight_row = 10,
                 angle_col ="45",
                 treeheight_col = 10,
                 legend = TRUE,
                 labels_row = rep("",nrow(data4pheatmap)),
                 labels_col = sample_names_raw)
        cat("\n")
      }
}
```

# Summary



# Used time


```
## [1] "Time used for analysis: 0.05 minutes"
```
