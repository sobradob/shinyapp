# Preparatory script
library(dplyr)
library(readr)

data<-readRDS("C:\\Users\\user1\\Desktop\\Life\\Professional\\Statistics Nederland\\gps\\peterLoc.rds")

data10k<-data %>% top_n(10000,time) %>% select(lat,lon, velocity, accuracy)

write_csv(x = data10k,path="test.csv")
