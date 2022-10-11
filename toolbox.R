#### test comparaison snp et otu candidats ####

gff3 <- read.csv("PL_annotation_PasaEx_54408.gff3", sep = "\t", header = F)
summary(gff3)
head(gff3)
gff3_name <- gff3$V9
gff3_name <- as.data.frame(gff3_name)
write_csv("data_to_clarify.csv", x=gff3_name)
gff3_name_c <- read.csv("data_to_clarify.csv", sep=";")
head(gff3_name_c)
as.data.frame(cbind(gff3$V1,gff3_name_c$X,gff3$V4,gff3$V5))-> raw_data
outliers_gene <- read.csv("emv.TU_identifier.csv", sep = ";", header =F)
as.data.frame(merge(outliers_gene, raw_data, by = "V2")) -> comparison_file
write.csv(comparison_file, "position_gene_outliers.csv")

### récupérer les outliers d'une rda####
evo_outliers_z <- 0
evo_outliers_out <- 0
for (i in seq(1.96,4,0.02)) {
  cand1 <- outliers(load.rda[,1],i)
  evo_outliers_z <- c(evo_outliers_z, i)
  evo_outliers_out <- c(evo_outliers_out, cand1)
}
evolution_nb_outliers <- as.data.frame(cbind(z_score = evo_outliers_z, nb_out = evo_outliers_z))

### RÉCUPÉRER LES POPS D'UN VCF ####
pop_df <- as.data.frame(name)
pop <- strsplit(as.character(pop_df$individu), split ="_")
POP <- as.data.frame(t(as.data.frame(pop)))
population <- as.character(POP$V1)

populasse <- strsplit(population, ".", fixed = TRUE)
popu <- as.data.frame(t(as.data.frame(populasse)))
population2 <- as.factor(popu$V1)

##### reprsentation d'une carte ####

ggplot(data = world) +
  geom_sf(aes(fill = region_wb)) +
  annotate(geom = "text", x = -90, y = 26, label = "Polynesia", 
           fontface = "italic", color = "grey22", size = 6) +
  coord_sf(xlim = c(-153, -135), ylim = c(-25, -8), expand = FALSE)

#### model bio^physque ####
dispersal100 <- read.table("Square_Matrix_count.txt") # -> the C100 matrix
colnames(dispersal100) <- rownames(dispersal100)
diag(dispersal100) <- 0.0
distance100 <- log(1/dispersal100)
diag(distance100) <- 0
sp.fw.100 <- floyd(distance100)
rownames(sp.fw.100) <- rownames(distance100)
colnames(sp.fw.100) <- colnames(distance100)
gps$X <- c("Ahe", "Anaa", "Aratika", "Mangareva",
           "Katiu","Kauehi", "Manihi", "MaruteaSud",
           "NukuHiva", "Maupihaa", "Morane", "Motutunga",
           "Raraka", "Raivavae", "Maupihaa", "Scilly",
           "Tahanea", "Takume", "Taenga", "Takapoto",
           "UaHuka", "Mangareva", "Mangareva", "Mangareva")
sp.fw.genet <- sp.fw.100[match(gps$X, rownames(sp.fw.100)),match(gps$X, colnames(sp.fw.100))]
gspgenet <-graph.adjacency(sp.fw.genet, mode="directed", weighted=TRUE)

V(gspgenet)$Latitude  <- gps[,"Latitude"] ## V(g): nodes (=sampling sites) of the graph
V(gspgenet)$Longitude <- gps[, "Longitude"]
E(gspgenet)$width <- (E(gspgenet)$weight)/100
map("worldHires",xlim = c(-154, -135), ylim = c(-25, -8), col="gray90", fill=TRUE)
plot(gspgenet, add=T, rescale=FALSE, layout =gps,
     vertex.size=30,        
     vertex.color="black",  
     edge.color="dark green",      
     vertex.label=NA)
##### how to do an acp on genind ####
s.class(pca$li, as.factor(population2),xax=1,yax=2, col=c("#399151","#4099FF", "#C691FF", "#FF9536"), axesell=FALSE,
        cstar=0, cpoint=3, grid=FALSE, clabel = NULL)
add.scatter.eig(pca1$eig[1:20],nf=5,xax=1,yax=2, "bottomright")
