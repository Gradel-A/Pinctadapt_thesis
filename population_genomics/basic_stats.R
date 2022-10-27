library(vcfR)
library(dartR)

######

obj.vcf <- read.vcfR("chip_pinctadapt_data_cleaned.vcf")
obj.gl <- vcfR2genlight(obj.vcf)

ID <- ((dimnames(obj.vcf@gt))[[2]])[-1]
ID_df <- as.data.frame(ID)
pop <- strsplit(as.character(ID_df$ID), split = "_")
POP <- as.data.frame(t(as.data.frame(pop)))
pop_list <- as.factor(POP$V1)
pop(obj.gl) <- pop_list

table(pop_list)

######
obj.glx <- gl.compliance.check(obj.gl)
data_heteroZ <- gl.report.heterozygosity(obj.glx)
data_hetero_test <- gl.test.heterozygosity(obj.glx)
data_fst_test <- gl.fst.pop(obj.glx)
