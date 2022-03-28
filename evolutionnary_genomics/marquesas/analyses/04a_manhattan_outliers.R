setwd("/home1/datawork/agradel/pinctadapt/results")

fstdata_err <- read.delim("complete_parameters_fst_table.txt")
fstdata <- cbind(fstdata_err[1:6], genome_position = (fstdata_err$POS+fstdata_err$Cum_pos))

plottingdata <- fstdata[fstdata$WEIR_AND_COCKERHAM_FST >=0.01,]
datax <- plottingdata$genome_position
datay <- plottingdata$WEIR_AND_COCKERHAM_FST
outliers <-datay >=0.5

pdf(file= "manhattan_plot_pb_distancing_cutoff_rapport.pdf",width=9,heigh=5.53)
plot(x= datax, y= datay, xlab = "position du SNP (pb)", ylab = "FST", pch = 20, cex=0.75)
points(datax[outliers], datay[outliers], col="red", pch = 20, cex=0.75)
abline(0.5,0, col="red", lty=2)
dev.off()
