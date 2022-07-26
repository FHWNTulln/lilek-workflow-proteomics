#!/usr/bin/Rscript

library(rmarkdown)

# https://www.r-bloggers.com/2015/02/bashr-howto-pass-parameters-from-bash-script-to-r/
args <- commandArgs()

# render post-processing script
# args[6] is the path defined in the bash script
# e.g. /proj/proteomics/11_20220713_FH/results/results_run1_mqpar_20220713_QC_delete

pth <- args[6]

if (grepl("QC", pth, ignore.case = TRUE)){
  rmarkdown::render("/proj/proteomics/bin/post-processing-QC.Rmd", run_pandoc = FALSE,
                    params = list(
                      path = paste(pth,"/combined/txt/proteinGroups.txt",sep="")),
                    output_dir = pth)
} else {
  rmarkdown::render("/proj/proteomics/bin/post-processing-4-automated-dataanalysis.Rmd", run_pandoc = FALSE,
                    params = list(
                      path = paste(pth,"/combined/txt/proteinGroups.txt",sep="")),
                    output_dir = pth)
}