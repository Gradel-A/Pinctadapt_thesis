library(vcfR)
library(dartR)
library(hierfstat)
library(factoextra)


setwd("~/Desktop/pinctadapt/données_puce/")
read.vcfR("chip_pinctadapt_data_cleaned.vcf") -> obj.vcf
obj.gl <- vcfR2genlight(obj.vcf)
obj.gi <- vcfR2genind(obj.vcf)

#take the pop information
ID <- ((dimnames(obj.vcf@gt))[[2]])[-1]
ID_df <- as.data.frame(ID)
pop <- strsplit(as.character(ID_df$ID), split = "_")
POP <- as.data.frame(t(as.data.frame(pop)))
pop_list <- as.factor(POP$V1)

#implement the population slot of genind obj
pop(obj.gi) <- pop_list
pop(obj.gl)<- pop_list
table(pop(obj.gi))

#practice the different statistique required for the dataset
obj.hier <- genind2hierfstat(obj.gi)
mat_dch <- genet.dist(obj.hier)
distance_matrice <- as.matrix(mat_dch, digits =9)

mat_fst <- pairwise.fst.dosage(as.data.frame(obj.gi), obj.hier$pop)
df_mat <- as.data.frame(mat_fst)

tuams <- c("AHE", "ANA", "ARA", "KAT", "KAU", "MAN", "MOT", "RAR", "TAH", "TAK", "TEA", "TKP")
gambier <- c("GMBW", "MOR", "MarSud", "WC1", "WC2", "WC3")
liste <- c(tuams, gambier)
tmp_df <- NA
for (i in c(tuams, gambier)) {
  tmp_col <- df_mat[[i]]
  tmp_df <- cbind(tmp_df, tmp = tmp_col)
}

colnames(tmp_df) <- c(NA, tuams, gambier)
rownames(tmp_df) <- rownames(df_mat)

tmp_df2 <- NA
for (i in c(tuams, gambier)) {
  tmp_row <- tmp_df[rownames(tmp_df) == i,]
  tmp_df2 <- cbind(tmp_df2, tmp_row)
}
colnames(tmp_df2) <- c(NA, tuams, gambier)

fst_mat_tg <- tmp_df2[-1,-1]

linearised_mat <- as.data.frame(unmatrix(fst_mat_tg, byrow = TRUE))

write.csv(fst_mat_tg, "everyup.csv", sep = "\t")
#do the processing in excel to concatenate by origine
read.csv("everyup_B.csv", sep = ";") -> data_fst
data_fst <- data_fst[,1:6]
boxplot(data_fst)

### now we will do an acp
values <- as.numeric(c(data_fst$T_T, data_fst$TW_TW, data_fst$G_G, data_fst$T_TW, data_fst$TW_G, data_fst$T_G))
group <- (c(rep("T_T", 66), rep("TW_TW", 66), rep("G_G", 66), rep("T_TW", 66), rep("TW_G", 66), rep("T_G",66)))
as.data.frame(cbind(values, group)) -> df_stats
as.numeric(df_stats$values) -> df_stats$values
as.factor(df_stats$group) -> df_stats$group
df_stats_bis <- df_stats[! is.na(df_stats$values),]

my_comparisons <- list( c(1,2), c(1,3), c(1,4), c(1,5), c(1,6))


ggplot(data = df_stats_bis, aes(x = group, y = values)) +
  geom_boxplot() + 
  stat_compare_means()+
  stat_compare_means(comparisons = my_comparisons)

#plotting an acp without marquises

polynesie <- obj.gl[ obj.gl$pop != "MP" & obj.gl$pop != "MG" & obj.gl$pop != "UAH" ]
polynesie.gi <- gl2gi(polynesie)
Y <- scaleGen(polynesie.gi, NA.method ="mean")
coly <- funky(length(levels(pop(polynesie.gi))))
#pca2 <- dudi.pca(Y)
pca2 <- dudi.pca(Y, scannf = FALSE, nf = 2)

#plot the acp and the variables
#eigencalues
barplot(pca2$eig[1:50],main="PCA eigenvalues", col=heat.colors(50))

#axe 1-2
s.class(pca2$li, pop(polynesie.gi),xax=1,yax=2, col=transp(coly,.6), axesell=FALSE,
        cstar=0, cpoint=3, grid=FALSE)
add.scatter.eig(pca2$eig[1:20],nf=2,xax=1,yax=2, "bottomright")

get_eig(pca2)

## and now with just tuamotus and gambier
restreint <- polynesie[ polynesie$pop != "SCI" & polynesie$pop != "RVV"& polynesie$pop != "MOP"  & polynesie$ind.names != "TAK_19-17" & polynesie$ind.names != "TAK_19-10"]
restreint.gi <- gl2gi(restreint)

Y <- scaleGen(restreint.gi, NA.method ="mean")
coly <- funky(length(levels(pop(restreint.gi))))
#pca2 <- dudi.pca(Y)
pca2 <- dudi.pca(Y, scannf = FALSE, nf = 2)

#plot the acp and the variables
#eigencalues
barplot(pca2$eig[1:50],main="PCA eigenvalues", col=heat.colors(50))

#axe 1-2
s.class(pca2$li, pop(restreint.gi),xax=1,yax=2, col=transp(coly,.6), axesell=FALSE,
        cstar=0, cpoint=3, grid=FALSE)
add.scatter.eig(pca2$eig[1:20],nf=2,xax=1,yax=, "bottomright")

head(get_eig(pca2))

tuams <- (c("AHE", "ANA", "ARA", "KAT", "KAU", "MAN", "MOT", "RAR", "TAH", "TAK", "TEA", "TKP"))
gambier <- c("GMBW", "MOR", "MarSud", "WC1", "WC2", "WC3")

as.character(pop(restreint.gi)) -> tmp_pop

for (i in tuams) {
  tmp_pop[tmp_pop == i] <- "Tuamotus"
}

for (i in gambier) {
  tmp_pop[tmp_pop == i] <- "Gambier"
}

new<-cbind(pca2$li,tmp_pop)
names(new)<-c("PC1","PC2","pop")

centroids <- aggregate(cbind(PC1, PC2)~pop,new,mean)
test <- merge(new, centroids, by = "pop")
colnames(test) <- c("pop", "PC1", "PC2", "PC1_ctr", "PC2_ctr")
col_pca <- c("#399151","#4099FF")

test$pop <- as.factor(test$pop)
ggplot(data=test,aes(x=PC1,y=PC2,col=pop)) + 
  geom_point(alpha=0.3,size=2) + 
  scale_color_manual(values=col_pca) + 
  theme_minimal() +
  theme(text = element_text(size = 16)) +
  labs(color = "Archipelago") +
  xlab("PC1 (0.36 %)")+
  ylab("PC2 (0.32 %)")+
  stat_ellipse() +
  geom_point(data=centroids,size=3, alpha = 1) +
  geom_segment(data = test, aes(x = PC1, y = PC2, xend = PC1_ctr, yend = PC2_ctr, col=pop))

?find.clusters()

find.clusters(restreint.gi)
as.data.frame(non_sup$grp) -> conclu

cbind(conclu, tmp_pop) -> test_clust

table(test_clust[test_clust$`non_sup$grp` == 3,])
table(test_clust)
