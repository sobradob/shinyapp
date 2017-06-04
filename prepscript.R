# Preparatory script
library(dplyr)
library(readr)

d<-readRDS("C:\\Users\\user1\\Desktop\\Life\\Professional\\Statistics Nederland\\gps\\peterLoc.rds")

data10k<-data %>% top_n(10000,time) %>% select(lat,lon, velocity, accuracy)
data<-data10k
write_csv(x = data10k,path="test.csv")

# create plot
library(ggplot2)
library(ggmap)

map_blank <- get_map(location = c(median(data$lon),median(data$lat)), zoom = 8, color = "bw")# size should change dynamically

ggmap(map_blank) + geom_point(data = data, aes(x = lon, y = lat), alpha = 0.5, color = "red") + 
  theme(legend.position = "right") + 
  labs(
    x = "Longitude", 
    y = "Latitude", 
    title = "Location history data points")
