library(lostruct)
library(ggplot2)
library(dartR)

outliers <- function(x,z){
  lims <- mean(x) + c(-1, 1) * z * sd(x)     # find loadings +/-z sd from mean loading     
  x[x < lims[1] | x > lims[2]]               # locus names in these tails
}

outliers.lim <- function(x,z){
  lims <- mean(x) + c(-1, 1) * z * sd(x)     # find loadings +/-z sd from mean loading
}

load("/home1/scratch/agradel/wall_genome_vcf/matrice_marq_gamb.RData") #attention il faut les transposer pour les rentrer dans lostruct

pcs <- eigen_windows(t(matrice.marq_gamb),k=2, win=10000)
pcdist <- pc_dist(pcs,npc=2)
fit1d.marq_gamb <-cmdscale(pcdist,eig=TRUE, k=1)

save(fit1d.marq_gamb, file= "wall_genome_vcf/fit1d_marq_gamb.RData")

position <- colnames(matrice.marq_gamb)[seq(1,nrow(t(matrice.marq_gamb)),5000)]
index <- seq(1, length(fit1d$points[,1]), 1)

datatoprocess.marq_gamb <- as.data.frame(cbind(index=index, pos = fit1d$points[,1],chr_pos = position))

lims <- outliers.lim(as.numeric(datatoprocess.marq_gamb$pos), 1.96)
datatoprocess.marq_gamb$outliers <- rep(FALSE, nrow(datatoprocess.marq_gamb))
datatoprocess.marq_gamb$outliers[datatoprocess.marq_gamb$pos < lims[1] | datatoprocess.marq_gamb$pos > lims[2]] <- TRUE
save(datatoprocess.marq_gamb, file= "wall_genome_vcf/datatoprocess.marq_gamb.RData")

