library(tidyverse)

setwd("/home1/datawork/agradel/pinctadapt/results")

fst <- read.delim("/home1/scratch/agradel/06_freebayes/marq_noNA_verif.weir.fst")
parameters <- read.delim("/home1/datawork/agradel/pinctadapt/00_scripts/scaffold_data.csv")

fstdata<- merge(fst, parameters, by = "CHROM")
fstdata_sorted<- (fstdata[order(fstdata$chr_Nb),])
plottingdata <- cbind(fstdata_sorted, genome_position =((fstdata_sorted$POS)+(fstdata$Cum_pos)))
write.table(plottingdata, file="complete_parameters_fst_table.txt" , sep="\t", dec=".")

plottingdata <- plottingdata[plottingdata$WEIR_AND_COCKERHAM_FST >=0.01,]
outliers <- plottingdata$WEIR_AND_COCKERHAM_FST >=0.459559


pdf(file= "manhattan_plot_pb_distancing.pdf",width=11.7,heigh=8.3)
plot(x=plottingdata$genome_position, y=plottingdata$WEIR_AND_COCKERHAM_FST, xlab = "genome position (pb)", ylab = "FST")
points(plottingdata$genome_position[outliers], plottingdata$WEIR_AND_COCKERHAM_FST[outliers], col="red")
abline(0.459559,0, col="red")
dev.off()
