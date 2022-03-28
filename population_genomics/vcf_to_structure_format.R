library(vcfR)
library(pcadapt)
library(adegenet)
library(hierfstat)
library(dplyr)

setwd("~/Desktop/pinctadapt/")

#load the data

obj.vcfR <- read.vcfR("Puce_ADN_289inds_10kSNPs_max10missing.vcf.recode.vcf")

ID <- ((dimnames(obj.vcfR@gt))[[2]])[-1]

geno <- extract.gt(obj.vcfR) # Character matrix containing the genotypes


tmp1 <- matrix(NA, nrow = nrow(geno), ncol = ncol(geno)) ### creating a matrix containing the ref of all1

tmp1[geno %in% c("0/0", "0|0")] <- 0
tmp1[geno %in% c("1/0", "1|0")] <- 1
tmp1[geno %in% c("0/1", "0|1")] <- 0
tmp1[geno %in% c("1/1", "1|1")] <- 1
tmp1[geno %in% c(NA)] <- -9 #implemente the NA with the correct value

tmp2 <- matrix(NA, nrow = nrow(geno), ncol = ncol(geno)) ### creating a matrix containing the ref of all2
tmp2[geno %in% c("0/0", "0|0")] <- 0
tmp2[geno %in% c("1/0", "1|0")] <- 0
tmp2[geno %in% c("0/1", "0|1")] <- 1
tmp2[geno %in% c("1/1", "1|1")] <- 1
tmp2[geno %in% c(NA)] <- -9

length(ID)
dim(tmp1)
dim(tmp2)

pop_df <- as.data.frame(ID)
pop <- strsplit(as.character(pop_df$ID), split = "_")
POP <- as.data.frame(t(as.data.frame(pop)))

tmp1f <- as.data.frame(cbind(ID, POP$V3, t(tmp1))) ###adding the ID of the different individus and the population
tmp2f <- as.data.frame(cbind(ID, POP$V3, t(tmp2)))

tmp1f$flag <- paste(tmp1f$ID,1,sep=".")
tmp2f$flag <- paste(tmp2f$ID,2,sep=".")

frame1 <- as.data.frame(tmp1f)
frame2 <- as.data.frame(tmp2f)

structure_set <- bind_rows(frame1, frame2)
structure_set_sorted <- arrange(structure_set, flag)
structure_set_sorted$flag <- NULL
structure_set_sorted$V2 <- as.factor(structure_set_sorted$V2)
summary(structure_set_sorted$V2)
#delete the factors induce by miss saving
structure_set_sorted$V2[structure_set_sorted$V2 == "R-AHE"] <- as.factor("A-AHE")
structure_set_sorted$V2[structure_set_sorted$V2 == "MG-IFRW"] <- as.factor("MG")
structure_set_sorted$V2[structure_set_sorted$V2 == "MP-IFRW"] <- as.factor("MP")
structure_set_sorted$V2 <- as.factor(as.character(structure_set_sorted$V2)) #initialise the factors
structure_set_sorted$V2 <- as.numeric(structure_set_sorted$V2)
write.table(structure_set_sorted,"Puce_ADN_structure_format.txt",quote=F,sep="\t",row.names=F,col.names=F)

