setwd("/home1/datawork/agradel/pinctadapt/results")

fstdata_err <- read.delim("complete_parameters_fst_table.txt")
outdapc <- read.table("dapc_outliers.txt", header = T)

fstdata <- cbind(fstdata_err[1:6], genome_position = (fstdata_err$POS+fstdata_err$Cum_pos))
outdapc2 <- cbind(outdapc, out = 1)

fstdata$coordinate <- paste(fstdata$CHROM, fstdata$POS, sep = "_")
outdapc2$coordinate <- paste(outdapc2$scaffold, outdapc2$position, sep = "_")
rawdata <- merge(fstdata, outdapc2, by = "coordinate", all.x = TRUE)

plottingdata <- rawdata[rawdata$WEIR_AND_COCKERHAM_FST >=0.01,]
datax <- plottingdata$genome_position
datay <- plottingdata$WEIR_AND_COCKERHAM_FST
outliers <- datay >= 0.5
dapc <- plottingdata$out == 1

pdf(file= "manhattan_plot_pcadapt_fst.pdf",width=9,heigh=5.53)
plot(x= datax, y= datay, xlab = "SNP position(pb)", ylab = "FST", pch = 20, cex=0.75)
points(datax[outliers], datay[outliers], col="red", pch = 20, cex=0.75)
points(datax[dapc], datay[dapc], col="blue", pch = 20, cex= 0.75)
abline(0.5,0, col="red", lty=2)
dev.off()
