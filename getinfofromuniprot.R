# https://cran.r-project.org/web/packages/UniprotR/UniprotR.pdf

library(UniprotR)

#use column fasta headers in proteingroups.txt file
fasta <- as.data.frame(stringr::str_split(significant$d.Fasta.headers, '\\|', simplify = T))

res <- GetProteinGOInfo(fasta_final$id)

PlotProteinGO_bio(res)
PlotProteinGO_cel(res)
PlotProteinGO_molc(res)
