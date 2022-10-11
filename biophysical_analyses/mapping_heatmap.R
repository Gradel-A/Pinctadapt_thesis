df_heat <- read.csv("step_matrix_ordered.csv", sep = ";", dec = ".", header = FALSE)
df_heat_reduce <- as.matrix(df_heat[-1,-1])
rownames(df_heat_reduce) <- colnames(df_heat_reduce)<- df_heat$V2[-1]
df_heat_values <- as.numeric(df_heat_reduce[-1,-1])

## add the australe population
#df_heat_all <- read.csv("step_matrix_all.txt", sep = "", dec = ".", header = FALSE)
#df_heat_australe <- as.data.frame(df_heat_all[is.na(df_heat_all$V12),is.na(df_heat_all$V12)])
#rownames(df_heat_australe) <- colnames(df_heat_australe) <- df_heat_all$V1[is.na(df_heat_all$V12)]
#df_heat_values_aus <- as.numeric(as.matrix(df_heat_australe))


tmp_abs <- NA
for (i in 1:97) {
  tmp_abs <- c(tmp_abs, rep(i, 97))
}
abs <- tmp_abs[-1]
#abs <- c(abs, rep(98,5) , rep(99,5) , rep(100,5) , rep(101,5) , rep(102,5))
#ord <- c(rep(1:97, 97), rep(98:102, 5))

#df_heat_values <- c(df_heat_values, df_heat_values_aus)
data_proc <- as.data.frame(cbind(df_heat_values, abs, ord))
tmp <- rownames(df_heat_reduce)[-1]

#tmp <- c(tmp, rownames(df_heat_australe))
ggplot(data=data_proc,aes(x=abs,y=-(ord),col=df_heat_values))+
  geom_point(shape = 15, size = 3.5) +
  scale_color_gradient2(midpoint = 4.5, low="red", mid = "yellow", high="light blue",
                        space = "Lab", na.value = "white") +
  labs(color= "n stepping stones") +
  theme(axis.text.x = element_text(angle = 45, hjust=0.95), line = element_blank(), 
        rect = element_blank()) +
  xlab("destination") +
  ylab("source") +
  scale_x_continuous(breaks = c(1:102), labels = tmp) + #change 97 by 102 in australe representation
  scale_y_continuous(breaks = c(-1:-102), labels = tmp)
