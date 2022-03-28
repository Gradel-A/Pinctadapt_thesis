library(evobiR)

setwd("/home1/datawork/agradel/pinctadapt/results")

fstdata_err <- read.delim("complete_parameters_fst_table.txt")
fstdata <- cbind(fstdata_err[1:6], genome_position = (fstdata_err$POS+fstdata_err$Cum_pos))

plottingdata <- fstdata[fstdata$WEIR_AND_COCKERHAM_FST >=0.01,]
datax <- SlidingWindow(FUN = mean, plottingdata$genome_position, 10,10)
datay <- SlidingWindow(FUN = mean, plottingdata$WEIR_AND_COCKERHAM_FST,10,10)
outliers <-datay >=0.5

#pdf(file= "manhattan_plot_pb_distancing_lissé.pdf",width=11.7,heigh=8.3)
#plot(x= datax, y= datay, xlab = "genome position (pb)", ylab = "FST", pch = 20)
#dev.off()


#pdf(file= "manhattan_plot_pb_distancing_lissé_with_outliers.pdf",width=11.7,heigh=8.3)
#plot(x= datax, y= datay, xlab = "genome position (pb)", ylab = "FST", pch = 20, ylim = c(0,0.75))
#points(datax[outliers], datay[outliers], col="red", pch = 20)
#abline(0.5,0, col="red", lty=2)
#dev.off()

minfst <-head(tail(sort(datay),45),1)
outliers2 <- datay >= minfst

pdf(file= "manhattan_plot_pb_distancing_lissé_cutoff_rapport.pdf",width=9,heigh=5.53)
plot(x= datax, y= datay, xlab = "position (pb) (moyenne sur 10 loci)", ylab = "FST (moyenne sur 10 loci)", pch = 20, cex=0.75)
points(datax[outliers2], datay[outliers2], col="red", pch = 20, cex=0.75)
#abline(0.3,0, col="red", lty=2)
dev.off()
