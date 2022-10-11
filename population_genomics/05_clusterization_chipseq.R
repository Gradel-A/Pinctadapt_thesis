library(vcfR)
library(pcadapt)
library(qvalue)
library(adegenet)
library(stringr)


setwd("/home1/scratch/agradel")

#load the data

#obj.vcfR <- read.vcfR("run_test.vcf")
#ID <- ((dimnames(obj.vcfR@gt))[[2]])[-1]

##there is some problem because of date introduction so we have to resolve this
#monthtoreseolve <- c("janv","f\x8evr","mars", "avr", "mai", "juin", "juil", "ao\x9et", 
#                     "sept", "oct", "nov", "d\x8ec")
#cpt=1
#for (i in monthtoreseolve) {
#  str_replace(ID, i,as.character(cpt))-> ID
#  cpt <- cpt +1 
#}

#pop_df <- as.data.frame(ID)
#pop <- strsplit(as.character(pop_df$ID), split = "_")
#POP <- as.data.frame(t(as.data.frame(pop)))
#population <- as.factor(POP$V1)
#population <- read.csv("list_pop_test_run.txt", sep = "\t", header=FALSE) 
#as.data.frame(t(population)) -> lap2
#replacement for test_run.vcf solution trying

#create the genlight data format
#DATA <- vcfR2genlight(obj.vcfR)
#DATA@ind.names <- ID
#pop(DATA) <- as.factor(lap2$V1)
load("run_test_polynesia.Rdata")
DATA <- polynesia
DATA
DATA@pop

#doing a clusterisation
pdf(file= "chipseq_clusterisation_BIC_information_rt.pdf",width=11.7,heigh=8.3)
foo.BIC <- find.clusters(DATA, n.pca=100, choose=FALSE)
plot(foo.BIC$Kstat, type="o", xlab="number of clusters (K)", ylab="BIC",
col="blue", main="Detection based on BIC")
points(2, foo.BIC$Kstat[4], pch="x", cex=3)
mtext(3, tex="'X' indicates the actual number of clusters")
dev.off()
save(foo.BIC, file = "find_cluster_without_choice_rt.R")

pdf(file= "chipseq_clusterisation_automatic_cluster_rt.pdf",width=11.7,heigh=8.3)
grp <- find.clusters(DATA, max.n.clust=30, n.pca=100, choose.n.clust = FALSE ,criterion = "diffNgroup" )
save(grp, file= "polynesia_nsclustering.Rdata")
table(pop(DATA), grp$grp)
table.value(table(pop(DATA), grp$grp), col.lab=paste("inf", 1:4),
            row.lab=levels(as.factor(lap2$V1)))
dev.off()
save(grp, file = "find_cluster_with_automatic_choice_rt.R")