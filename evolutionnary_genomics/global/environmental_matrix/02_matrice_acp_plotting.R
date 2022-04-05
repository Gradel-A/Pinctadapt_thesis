library(FactoMineR)
library(psych)
library(factoextra)

matrice <- read.table("environment_geomorpho_matrix.csv", sep = ";", dec = ".", header = TRUE)
rownames(matrice) <- matrice$site
matrice_temp <- matrice[,-(11:14)]

#pdf(file= "environnemental_matrice_acp.pdf",width=11.7,heigh=8.3)
#starting with the all matrice####
#looking for some co-variables
pairs.panels(matrice[,-(1:2)], scale = FALSE, method = "pearson")
#plotting the acp with individuals and also variables

res.pca <- PCA(matrice[,-(1:2)], graph =FALSE) #by default this function scale the variables to variance unit to change: scale.unit=FALSE

#first look to number of dimension to keep
fviz_eig(res.pca, addlabels = TRUE, ylim = c(0, 50))
#we choose 3 here
res.pca <- PCA(matrice[,-(1:2)], ncp = 3, graph = TRUE)

#extract the variables and analysed them
var <- get_pca_var(res.pca)
library("corrplot")
corrplot(var$cos2, is.corr=FALSE)
fviz_pca_var(res.pca, col.var = "contrib",
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07")
)

#now study the sites
fviz_pca_ind(res.pca,
             col.ind = matrice$archipelago,
             palette = c("#00AFBB", "brown", "#FC4E07", "#28D782", "#9642C4", "#7BFFFF", "#DDAFEC", "#DDAF2A", "black"),
             pointshape = 20,
             mean.point = FALSE
             )
fviz_pca_biplot (res.pca,
                 col.ind = matrice$archipelago,
                 palette = c("#00AFBB", "brown", "#FC4E07", "#28D782", "#9642C4", "#7BFFFF", "#DDAFEC", "#DDAF2A", "black"),
                 pointshape = 20,
                 mean.point = FALSE
                 
)

fviz_pca_biplot (res.pca,
                 col.ind = matrice$archipelago,
                 palette = c("#00AFBB", "brown", "#FC4E07", "#28D782", "#9642C4", "#7BFFFF", "#DDAFEC", "#DDAF2A", "black"),
                 pointshape = 20,
                 mean.point = FALSE,
                 axes = c(1,3)
                 
)

fviz_pca_biplot (res.pca,
                 col.ind = matrice$archipelago,
                 palette = c("#00AFBB", "brown", "#FC4E07", "#28D782", "#9642C4", "#7BFFFF", "#DDAFEC", "#DDAF2A", "black"),
                 pointshape = 20,
                 mean.point = FALSE,
                 axes = c(2,3)
                 
)

#then just the temperature####
pairs.panels(matrice_temp[,-(1:2)], scale = FALSE, method = "pearson")

#plotting the acp with individuals and also variables

res.pca <- PCA(matrice_temp[,-(1:2)], graph =FALSE])

#first look to number of dimension to keep
fviz_eig(res.pca, addlabels = TRUE, ylim = c(0, 50))
#we choose 3 here
res.pca <- PCA(matrice_temp[,-(1:2)], ncp = 3,, graph = TRUE)

#extract the variables and analysed them
var <- get_pca_var(res.pca)
library("corrplot")
corrplot(var$cos2, is.corr=FALSE)
fviz_pca_var(res.pca, col.var = "contrib",
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07")
)

#now study the sites
fviz_pca_ind(res.pca,
             col.ind = matrice$archipelago,
             palette = c("#00AFBB", "brown", "#FC4E07", "#28D782", "#9642C4", "#7BFFFF", "#DDAFEC", "#DDAF2A", "black"),
             pointshape = 20,
             mean.point = FALSE
)
fviz_pca_biplot (res.pca,
                 col.ind = matrice$archipelago,
                 palette = c("#00AFBB", "brown", "#FC4E07", "#28D782", "#9642C4", "#7BFFFF", "#DDAFEC", "#DDAF2A", "black"),
                 pointshape = 20,
                 mean.point = FALSE
                 
)

fviz_pca_biplot (res.pca,
                 col.ind = matrice$archipelago,
                 palette = c("#00AFBB", "brown", "#FC4E07", "#28D782", "#9642C4", "#7BFFFF", "#DDAFEC", "#DDAF2A", "black"),
                 pointshape = 20,
                 mean.point = FALSE,
                 axes = c(1,3)
                 
)

fviz_pca_biplot (res.pca,
                 col.ind = matrice$archipelago,
                 palette = c("#00AFBB", "brown", "#FC4E07", "#28D782", "#9642C4", "#7BFFFF", "#DDAFEC", "#DDAF2A", "black"),
                 pointshape = 20,
                 mean.point = FALSE,
                 axes = c(2,3)
                 
)

#finally the acp without any co-variables####
tmp <- matrice[,c(1:4,9,12:13)]
#plotting the acp with individuals and also variables

res.pca <- PCA(tmp[,-(1:2)], graph = FALSE)

#first look to number of dimension to keep
fviz_eig(res.pca, addlabels = TRUE, ylim = c(0, 50))
#we choose 3 here
res.pca <- PCA(tmp[,-(1:2)], ncp = 3,, graph = TRUE)

#extract the variables and analysed them
var <- get_pca_var(res.pca)
library("corrplot")
corrplot(var$cos2, is.corr=FALSE)
fviz_pca_var(res.pca, col.var = "contrib",
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07")
)

#now study the sites
fviz_pca_ind(res.pca,
             col.ind = matrice$archipelago,
             palette = c("#00AFBB", "brown", "#FC4E07", "#28D782", "#9642C4", "#7BFFFF", "#DDAFEC", "#DDAF2A", "black"),
             pointshape = 20,
             mean.point = FALSE
)
fviz_pca_biplot (res.pca,
                 col.ind = matrice$archipelago,
                 palette = c("#00AFBB", "brown", "#FC4E07", "#28D782", "#9642C4", "#7BFFFF", "#DDAFEC", "#DDAF2A", "black"),
                 pointshape = 20,
                 mean.point = FALSE
                 
)

fviz_pca_biplot (res.pca,
                 col.ind = matrice$archipelago,
                 palette = c("#00AFBB", "brown", "#FC4E07", "#28D782", "#9642C4", "#7BFFFF", "#DDAFEC", "#DDAF2A", "black"),
                 pointshape = 20,
                 mean.point = FALSE,
                 axes = c(1,3)
                 
)

fviz_pca_biplot (res.pca,
                 col.ind = matrice$archipelago,
                 palette = c("#00AFBB", "brown", "#FC4E07", "#28D782", "#9642C4", "#7BFFFF", "#DDAFEC", "#DDAF2A", "black"),
                 pointshape = 20,
                 mean.point = FALSE,
                 axes = c(2,3)
                 
)

#dev.off()
