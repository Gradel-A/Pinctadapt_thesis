library(vcfR)
library(pcadapt)
library(qvalue)
library(adegenet)


setwd("/home1/datawork/agradel/pinctadapt/results")

#load the data

obj.vcfR <- read.vcfR("/home1/datawork/agradel/pinctadapt/marquises_withoutNA_verif.recode.vcf")
population <- c(rep("surface", 5),"deep","surface","deep","deep","surface","surface", rep("deep",6),"surface")
pop <- c(rep(1, 5),2,1,2,2,1,1, rep(2,6),1)

#dcreate the genlight data format
DATA <- vcfR2genlight(obj.vcfR)
pop(DATA) <- population

DATA
DATA@pop

#doing a DAPC

dapc1 <- dapc(DATA, n.pca = 18, n.da = 1)

loadingplot(dapc1$var.contr, thres=1e-3) -> dapc2

pdf(file= "dapc_SNP_out.pdf",width=11.7,heigh=8.3)
loadingplot(dapc1$var.contr, thres=1e-3)
dev.off()

outliers <- as.integer(dapc2$var.names)
length(outliers)

#taking back the scaffold and the position of the SNP
chromosome <- getCHROM(obj.vcfR)
position <- getPOS(obj.vcfR)
SNPs<-cbind("scaffold"=chromosome, "position" = position)
SNPs <- as.data.frame(SNPs)
SNP_outliers <- SNPs[outliers,]

write.table(SNP_outliers,"dapc_outliers.txt",quote=F,sep="\t",row.names=F,col.names=T)
