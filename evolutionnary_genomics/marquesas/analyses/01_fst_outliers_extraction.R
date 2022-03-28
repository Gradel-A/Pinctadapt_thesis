setwd("/home1/datawork/agradel/pinctadapt/results")

fst <- read.delim("/home1/scratch/agradel/06_freebayes/marq_noNA_verif.weir.fst")
fst$WEIR_AND_COCKERHAM_FST[fst$WEIR_AND_COCKERHAM_FST <= 0] <- 0

outliers <- fst[fst$WEIR_AND_COCKERHAM_FST >= 0.5,]

write.table(outliers, file ="id_fst_sup05.txt", dec=".", sep="\t", row.names = FALSE, col.names = FALSE)
