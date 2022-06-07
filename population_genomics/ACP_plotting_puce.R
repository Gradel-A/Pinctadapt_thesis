library(adegenet)
library(dartR)

#take the file and the good format
setwd("~/Downloads/test_run/")
load("run_test_genligth_object.Rdata")
run_test_gi <- gl2gi(run_test_genligth_object)

#prepare for the pca and to it
X <- scaleGen(run_test_gi, NA.method ="mean")
#pca1 <- dudi.pca(X)
pca1 <- dudi.pca(X, scannf = FALSE, nf = 3)

#plot the acp and the variables
#eigencalues
barplot(pca1$eig[1:50],main="PCA eigenvalues", col=heat.colors(50))

#axe 1-2
col <- funky(length(levels(pop(run_test_gi))))
s.class(pca1$li, pop(run_test_gi),xax=1,yax=2, col=transp(col,.6), axesell=FALSE,
        cstar=0, cpoint=3, grid=FALSE)
add.scatter.eig(pca1$eig[1:20],nf=3,xax=1,yax=2, "topmiddle")

#axe 1-3
s.class(pca1$li, pop(run_test_gi), xax=1,yax=3)
add.scatter.eig(pca1$eig[1:20],nf=3,xax=1,yax=3)

### now I want to zoom to polynesia
polynesia <- run_test_genligth_object[ run_test_genligth_object$pop != "WildJuvIndo"& run_test_genligth_object$pop != "JAPJuv"]

polynesia_gi <- gl2gi(polynesia)

#prepare for the pca and to it
Y <- scaleGen(polynesia_gi, NA.method ="mean")
coly <- funky(length(levels(pop(polynesia))))
#pca2 <- dudi.pca(Y)
pca2 <- dudi.pca(Y, scannf = FALSE, nf = 2)

#plot the acp and the variables
#eigencalues
barplot(pca2$eig[1:50],main="PCA eigenvalues", col=heat.colors(50))

#axe 1-2
s.class(pca2$li, pop(polynesia_gi),xax=1,yax=2, col=transp(coly,.6), axesell=FALSE,
        cstar=0, cpoint=3, grid=FALSE)
add.scatter.eig(pca1$eig[1:20],nf=2,xax=1,yax=2, "bottomright")

#Avec ggplot
population <- as.character(pop(polynesia))
tuams <- c("AHE", "ANA", "ARA", "FAA", "KAT", "KAU", "MAN", "MOT", "RAR", "TAH", "TAK", "TEA", "TKP")
marquises <- c("MG", "MP", "UAH", "UAP", "AUQ")
gambier <- c("GMBW", "MOR", "MarSud", "WC1", "WC2", "WC3")
societe <- c("SCI", "Vivish", "MOP")
australe <- c("R")

for (i in tuams) {
  population[population == i] <- "Tuamotus"
}
for (i in marquises) {
  population[population == i] <- "Marquesas"
}

for (i in gambier) {
  population[population == i] <- "Gambier"
}

for (i in scociete) {
  population[population == i] <- "Society"
}

for (i in australe) {
  population[population == i] <- "Australe"
}

new<-cbind(pca2$li,population)
str(new)
names(new)<-c("PC1","PC2","pop")

centroids <- aggregate(cbind(PC1, PC2)~pop,new,mean)
test <- merge(new, centroids, by = "pop")
colnames(test) <- c("pop", "PC1", "PC2", "PC1_ctr", "PC2_ctr")

ggplot(data=test,aes(x=PC1,y=PC2,col=pop)) + 
  geom_point(alpha=0.3,size=2) + 
  scale_color_manual(values=coly) + 
  theme_minimal() +
  theme(text = element_text(size = 16)) +
  stat_ellipse() +
  geom_point(data=centroids,size=3, alpha = 1) +
  geom_segment(data = test, aes(x = PC1, y = PC2, xend = PC1_ctr, yend = PC2_ctr))


