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
    number_sections: no
    code_folding: hide
params:
  title: 
    label: "Title"
    value: "DataAnalysis - Postprocessing Results MaxQuant QC samples"
  author:
    label: "Author"
    value: ""
  path:
    label: "File path"
    value: "N:/1_A_Bachelor_Master_Intern/00_M_2022/David/Data/11_20220713_TR/mqpar_20220713_QC/proteinGroups.txt"
title: "DataAnalysis - Postprocessing Results MaxQuant QC samples"
author: ""
date: "26 July 2022, 05:34:59 PM"
---





```r
#load libraries
library(tidyverse)
library(dplyr)
library(gplots)
```


```r
##################
#
#Experiment 001
#
##################
path = params$path
data_raw <- read.csv(path, dec=".", sep="\t")
filtering <- function(data_raw){
  data_raw %>% filter( 
    Potential.contaminant == "",
    Reverse == "",
    Only.identified.by.site == "")
}
data <- filtering(data_raw) 

filteredout <- nrow(data_raw)-nrow(data)
#print("Filtered out")
#filteredout
```

# More than 1 peptide


```r
#select only unique peptides
uniq.razor <- data %>% select(starts_with("Razor...unique.peptides"))
#replace -Inf values by NA
uniq.razor[uniq.razor < 1] <- NA
#get sums of identified proteins
boxplot(colSums(!is.na(uniq.razor[-1])))
```

<img src="/proj/proteomics/11_20220713_FH/results/results_run1_mqpar_20220713_QC_delete/post-processing-QC_files/figure-html/unnamed-chunk-3-1.png" width="672" />

```r
m <- mean(colSums(!is.na(uniq.razor[-1])))
print("Mean no protein identifications ID more than 1 peptide")
```

```
## [1] "Mean no protein identifications ID more than 1 peptide"
```

```r
print(m)
```

```
## [1] 1303.333
```

## More than 2 peptides 


```r
#select only unique peptides
uniq.razor <- data %>% select(starts_with("Razor...unique.peptides"))
#replace -Inf values by NA
uniq.razor[uniq.razor < 2] <- NA
#get sums of identified proteins
boxplot(colSums(!is.na(uniq.razor[-1])))
```

<img src="/proj/proteomics/11_20220713_FH/results/results_run1_mqpar_20220713_QC_delete/post-processing-QC_files/figure-html/unnamed-chunk-4-1.png" width="672" />

```r
m <- mean(colSums(!is.na(uniq.razor[-1])))
print("Mean no protein identifications ID more than 2 peptides")
```

```
## [1] "Mean no protein identifications ID more than 2 peptides"
```

```r
print(m)
```

```
## [1] 863
```

