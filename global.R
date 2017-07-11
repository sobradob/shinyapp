# global.R

library(shiny)
library(readr)
library(ggplot2)
library(dplyr)
#library(ggthemes)
library(leaflet)
library(htmltools)

data<-read_csv("test.csv")
t<-read_csv("tActivites.csv")

#icons for the map
gpsIcons <- iconList(
  onBicycle = makeIcon("bicycle.png","bicycle.png", 18,18),
  inVehicle = makeIcon("car.png","car.png", 18,18),
  still = makeIcon("still.png","still.png",  18,18),
  unknown = makeIcon("unknown.png","unknown.png",  18,18),
  onFoot = makeIcon("walk.png","walk.png",  18,18),
  tilting = makeIcon("still.png","still.png",  18,18),
  exitingVehicle = makeIcon("unknown.png","unknown.png",  18,18)
)
