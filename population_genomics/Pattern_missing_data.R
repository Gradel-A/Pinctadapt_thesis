#####################################
## PATTERN OF MISSING DATA
# C. Reisser

options(timeout=10000000)
# install Cmake for mac at https://cmake.org/download/


# Install grur
install.packages("remotes")
remotes::install_github("thierrygosselin/grur")
install.packages("BiocManager")
BiocManager::install("SeqVarTools")
library(grur)
library(S4Vectors)
library(SeqVarTools)
library(dartR)
library(radiator)

# Look at the function
?missing_visualization


# Using the function on VCF file
metadata<-read.table("metadata.txt",header=T)
missing_visualization(data="Puce_ADN_289inds_10kSNPs.vcf",distance.method = "euclidean",strata="metadata.txt",write.plot = TRUE)




















