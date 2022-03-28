library(vcfR)
library(pcadapt)
library(qvalue)
library(adegenet)
library(hierfstat)

setwd("/home1/datawork/agradel/pinctadapt/results")

#load the data

obj.vcfR <- read.vcfR("/home1/datawork/agradel/pinctadapt/marquises_withoutNA_verif.recode.vcf")

geno <- extract.gt(obj.vcfR) # Character matrix containing the genotypes
position <- getPOS(obj.vcfR) # Positions in bp
chromosome <- getCHROM(obj.vcfR) # Chromosome information
population <- c(rep("surface", 5),"deep","surface","deep","deep","surface","surface", rep("deep",6),"deep")

marquises <- matrix(NA, nrow = nrow(geno), ncol = ncol(geno))

marquises[geno %in% c("0/0", "0|0")] <- 0
marquises[geno %in% c("0/1", "1/0", "1|0", "0|1")] <- 1
marquises[geno %in% c("1/1", "1|1")] <- 2

#load the data
#load("marquises_matrice.RData")
antoine <- read.pcadapt(marquises, type = "pcadapt")

save(marquises, file = "marquises_matrice.RData")

#doing the statistics
x <- pcadapt(input = antoine, K = 15)

pdf(file= "pcadapt_screeplot.pdf",width=11.7,heigh=8.3)
plot(x, option = "screeplot")
dev.off()

#doing the analyses in reference of the sreenplot
DATA <- pcadapt(antoine, K = 2)

#represent and save the manhatttan plot
pdf(file= "pcadapt_manhattan.pdf",width=11.7,heigh=8.3)
plot(DATA , option = "manhattan")
dev.off()


#using q-value to detect the outliers
qval <- qvalue(DATA$pvalues)$qvalues
alpha <- 0.01
outliers <- which(qval < alpha)
length(outliers)


#taking back the outliers table

data2<-vcfR2genind(obj.vcfR)
pop(data2) <- population

data2@pop

mat<-as.data.frame(t(tab(data2)))
mat2<-mat[outliers,]
pval<-DATA$pvalues[outliers]
tab<-cbind(pval,mat2)
sum(is.na(tab$pval))

write.table(tab,"pcadapt_outliers_001.txt",quote=F,sep="\t",row.names=T,col.names=T)

#doing an acp on the outliers data
data3 <- as.genlight(t(mat2))
pca1 <- glPca(data3, nf = 2)

pdf(file= "pca_on_outliers_OO1.pdf",width=11.7,heigh=8.3)
barplot(pca1$eig[1:10])
s.class(pca1$scores, pop(data3))
dev.off()
