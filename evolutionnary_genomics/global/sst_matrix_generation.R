#### introduce the packages and set the working directory

library(tidyverse)
library(ggplot2)
library(lubridate)
setwd("~/Desktop/pinctadapt/CSV_files")

#### load the data in the environment
#list the data files
my_files <- list.files(path = "~/Desktop/pinctadapt/CSV_files", pattern = "\\.csv$")

#extract the data and set to good shape
my_data <- lapply(my_files, read.csv)
names(my_data) <- gsub("\\_SST.csv$","",my_files)
site_id <- names(my_data)
site_nb <- length(site_id)

#create the raw data frame with all sites and all temperatures
tab <- my_data[[1]]

tmp <- my_data[[1]]
tmp$date <- as.Date(tmp$date, format = "%d/%m/%Y")

tmp2 <- tmp[tmp$sst >= 28.7,]
tmp2$consecutive <- c(FALSE,diff(tmp2$date)==1)
tmp22 <- tmp2[tmp2$consecutive ==FALSE,]
tmp22 <- rbind(NA, tmp22)
tmp3 <- tmp[tmp$sst <= 28.7,]
tmp3$consecutive <- c(FALSE,diff(tmp3$date)==1)
tmp33 <- tmp3[tmp3$consecutive ==FALSE,]

tmp_int <- interval(tmp22$date, tmp33$date)
tmp_int <- as.period(tmp_int, unit = "day")
tmp_days <- tmp_int@day

max_days <- max(tmp_days, na.rm =TRUE)
mean_duration <- mean(tmp_days, na.rm = TRUE)


sup_op <- length(tab$sst[tab$sst >= 28.7])
for (i in 2:site_nb) {
  tmp <- my_data[[i]]
  sup_op <- c( sup_op, length(tmp$sst[tmp$sst >= 28.7]))
  tab <- cbind(tab, tmp$sst)
  # we want to take the different period of warm temperature
  tmp$date <- as.Date(tmp$date, format = "%d/%m/%Y")
  
  tmp2 <- tmp[tmp$sst >= 28.7,]
  tmp2$consecutive <- c(FALSE,diff(tmp2$date)==1)
  tmp22 <- tmp2[tmp2$consecutive ==FALSE,]
  tmp22 <- rbind(NA, tmp22)
  tmp3 <- tmp[tmp$sst <= 28.7,]
  tmp3$consecutive <- c(FALSE,diff(tmp3$date)==1)
  tmp33 <- tmp3[tmp3$consecutive ==FALSE,]
  
  tmp_int <- interval(tmp22$date, tmp33$date)
  tmp_int<- as.period(tmp_int, unit = "day")
  tmp_days <- tmp_int@day
  
  tmp_max_days <- max(tmp_days, na.rm =TRUE)
  tmp_mean_duration <- mean(tmp_days, na.rm = TRUE)
  
  max_days <- c(max_days, tmp_max_days)
  mean_duration <- c(mean_duration, tmp_mean_duration)
  #just to find the iteration which can produce warnings
  if (length(tmp22$date) != length(tmp33$date)) {print(i)} 
}

colnames(tab) <- c("date", site_id)
tab$date <- as.Date(tab$date, format = "%d/%m/%Y")

#### create the matrix to use in the analyses
site_max <- apply(X= tab, MARGIN = 2, FUN= max) # extract the maximum value of each site
site_min <- apply(X= tab, MARGIN = 2, FUN= min) # extract the minimum value
site_mean <- as.data.frame(lapply(X= tab, MARGIN = 2, FUN= mean)) #extract the mean

tab_summer <- tab[month(tab$date) <= 3,] #create a dataframe for austral summer
tab_winter <- tab[month(tab$date) <= 9 & month(tab$date) >= 7,] # create a dataframe for austral winter

site_mean_sum <- lapply(X= tab_summer, MARGIN = 2, FUN= mean) # calculate the mean temperature
site_mean_wint <- lapply(X= tab_winter, MARGIN = 2, FUN= mean) #calculate the mean temperature

matrix_env <- rbind(site_mean, site_max, site_min, site_mean_sum, site_mean_wint, c(00/00/0000,(sup_op*12)/(18*12+7)), c(00/00/0000,mean_duration), c(00/00/0000,max_days))
matrix_env <- as.data.frame(apply(X= matrix_env, MARGIN = 2, FUN = as.numeric))
row.names(matrix_env) <- c("mean", "max", "min", "mean_sum", "mean_wint", "mean_day_up_per_y", "mean_sup_op_duration", "max_sup_op_duration")
matrix_env <- matrix_env[,-1]

#now we have to take care that there is population in a different hemispher so change
#summer and winter month
for(i in 1:site_nb) {
  if(matrix_env[4,i] <= matrix_env[5,i]) {
    tmp <- matrix_env[4,i]
    matrix_env[4,i] <- matrix_env[5,i]
    matrix_env[5,i] <- tmp
  }
}

### now save the result 
sst_data <- as.data.frame(t(matrix_env))
sst_data <- tibble:: rownames_to_column(sst_data, "site")
write.table(sst_data, file= "environment_matrix.csv", sep = "\t", dec = ".", col.names = TRUE, row.names = FALSE)

### how to solve when the for loop say that there a length warnings: ####
#tmp <- my_data[[i]]
#tmp$date <- as.Date(tmp$date, format = "%d/%m/%Y")

#tmp2 <- tmp[tmp$sst >= 28.7,]
#tmp2$consecutive <- c(FALSE,diff(tmp2$date)==1)
#tmp22 <- tmp2[tmp2$consecutive ==FALSE,]
#tmp22 <- rbind(NA, tmp22)
#tmp3 <- tmp[tmp$sst <= 28.7,]
#tmp3$consecutive <- c(FALSE,diff(tmp3$date)==1)
#tmp33 <- tmp3[tmp3$consecutive ==FALSE,]
#tmp33 <- rbind(tmp33,NA)

#tmp_int <- interval(tmp22$date, tmp33$date)
#tmp_int<- as.period(tmp_int, unit = "day")
#tmp_days <- tmp_int@day

#tmp_max_days <- max(tmp_days, na.rm =TRUE)
#tmp_mean_duration <- mean(tmp_days, na.rm = TRUE)

#max_days[i] <-  tmp_max_days
#mean_duration[i] <- tmp_mean_duration




