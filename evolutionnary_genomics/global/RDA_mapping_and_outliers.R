#load the different packages

library(adegenet)
library(vcfR)
library(ggplot2)
library(plyr)
library(dplyr)
library(tidyr)
library(hierfstat)
library(dartR)
library(vegan)
library(psych)

#### create a function ####

outliers <- function(x,z){
  lims <- mean(x) + c(-1, 1) * z * sd(x)     # find loadings +/-z sd from mean loading     
  x[x < lims[1] | x > lims[2]]               # locus names in these tails
}

#### load the data ####
# the genome
vcf <- read.vcfR("Puce_ADN_289inds_10kSNPs_max10missing.vcf.recode.vcf")
data <- vcfR2genlight(vcf) 

#the metada (pop, environnemental conditions,...)
metadata <- read.table("metadata.txt",header=T) # replace the file with the good one with all the conditions
data$pop <- as.factor(metadata$STRATA)
data$ind.names <- as.character(metadata$INDIVIDUALS)
#data$other$long <- metadata$long
#...

#preparing the data and imput the mssing data
geno<-gl2gi(data)
geno.imput <- apply(geno@tab, 2, function(x) replace(x, is.na(x), as.numeric(names(which.max(table(x))))))
sum(is.na(geno.imput))

#preparing the env file
environment_conditions <- data.frame( 'ID' = metadata$INDIVIDUALS,
  'population' = geno$pop)
identical(rownames(geno.imput), environment_conditions[,1])
pairs.panels(environment_conditions, scale=T)

#### running the RDA ####
#first choose your environnemental conditions to keep
#Env_test <- select(environment_ind, variance, min)
Env_test <- select(environment_conditions, population)
temp.rda.mod0 <- rda(geno.imput~1, Env_test)
temp.rda.mod1 <- rda(geno.imput~., Env_test)

rda.ord <- ordiR2step(temp.rda.mod0, temp.rda.mod1, direction = "forward")
vif.cca(rda.ord)
RsquareAdj(rda.ord)
rda.ord
screeplot(rda.ord)

#### plot the RDA ####
bg <- c("orange","purple","grey","#a6cee3","blue","red","light green","green")
plot(rda.ord, scaling =3, choices = c(1,2))
points(rda.ord, display="sites", pch=21, cex=1.3, col="gray32", scaling=3,choices = c(1,2), bg=bg[geno@pop])
legend("bottomright", legend=levels(geno@pop), bty="n", col="gray32", pch=21, cex=1, pt.bg=bg)

plot(rda.ord, scaling =3, choices = c(1,3))
points(rda.ord, display="sites", pch=21, cex=1.3, col="gray32", scaling=3,choices = c(1,3), bg=bg[geno@pop])
legend("bottomright", legend=levels(geno@pop), bty="n", col="gray32", pch=21, cex=1, pt.bg=bg)

####ectract the outliers ####
load.rda <- scores(rda.ord, choices=c(1:3), display="species")

hist(load.rda[,1], main="Loadings on RDA1") #plotting the histogramme of the outliers values
hist(load.rda[,2], main="Loadings on RDA2")
hist(load.rda[,3], main="Loadings on RDA3") 

cand1 <- outliers(load.rda[,1],3) # 196 #extract the snp consider as outliers
cand2 <- outliers(load.rda[,2],3) # 222
cand3 <- outliers(load.rda[,3],3) # 124

#when we use a DNA puce we have to remove duplicate snp
cand1.tab.dup <- cbind.data.frame(rep(1,times=length(cand1)), names(cand1), unname(cand1))
cand2.tab.dup <- cbind.data.frame(rep(2,times=length(cand2)), names(cand2), unname(cand2))
cand3.tab.dup <- cbind.data.frame(rep(3,times=length(cand3)), names(cand3), unname(cand3))

colnames(cand1.tab.dup) <- colnames(cand2.tab.dup) <- colnames(cand3.tab.dup) <- c("axis","snp","loading")

cand1.tab.sep <- separate(cand1.tab.dup ,col =  snp,  into = c("index", "snp", "base"))
cand1.tab.sep.uni <- unite(cand1.tab.sep , index:snp, col = "snp", sep = "-")
cand1.tab.sep.uni$base <- NULL
cand1.tab <-cand1.tab.sep.uni[!duplicated(cand1.tab.sep.uni$snp),]
length(cand1.tab$snp)

cand2.tab.sep <- separate(cand2.tab.dup ,col =  snp,  into = c("index", "snp", "base"))
cand2.tab.sep.uni <- unite(cand2.tab.sep , index:snp, col = "snp", sep = "-")
cand2.tab.sep.uni$base <- NULL
cand2.tab <-cand2.tab.sep.uni[!duplicated(cand2.tab.sep.uni$snp),]
length(cand2.tab$snp)

cand3.tab.sep <- separate(cand3.tab.dup ,col =  snp,  into = c("index", "snp", "base"))
cand3.tab.sep.uni <- unite(cand3.tab.sep , index:snp, col = "snp", sep = "-")
cand3.tab.sep.uni$base <- NULL
cand3.tab <-cand3.tab.sep.uni[!duplicated(cand3.tab.sep.uni$snp),]
length(cand3.tab$snp)

cand <- rbind(cand1.tab.dup, cand2.tab.dup, cand3.tab.dup)
cand$snp <- as.character(cand$snp)

ncand <- length(cand1) + length(cand2) + length(cand3)
foo <- matrix(nrow=(ncand), ncol=1)  # n columns for n predictors
colnames(foo) <- c("population") #name them

for (i in 1:length(cand$snp)) {
  nam <- cand[i,2]
  snp.gen <- geno.imput[,nam]
  foo[i,] <- apply(as.data.frame(as.numeric(Env_test$population)),2,function(x) cor(x,snp.gen))
}

cand.predic.dup <- cbind.data.frame(cand,foo)  
cand.predic.sep <- separate(cand.predic.dup ,col =  snp,  into = c("index", "snp", "base"))
cand.predic.uni <- unite(cand.predic.sep , index:snp, col = "snp", sep = "-")
cand.predic.uni$base <- NULL
cand.predic.uni1  <- unite(cand.predic.uni, axis:snp, col = "axis_snp", sep = "_")
cand.predic_prev <- cand.predic.uni1[!duplicated(cand.predic.uni1$axis_snp),]
cand.predic <- separate(cand.predic_prev ,col =  axis_snp,  into = c("axis", "snp"), sep = "_")
cand.predic_multi <- cand.predic[duplicated(cand.predic$snp),]
head(cand.predic)




