# Preparatory script
library(dplyr)
library(readr)

d<-readRDS("C:\\Users\\user1\\Desktop\\Life\\Professional\\Statistics Nederland\\gps\\peterLoc.rds")

data<-d %>% top_n(10000,time) %>% dplyr::select(lat,lon, velocity, accuracy,time)
#issue if raster is loaded 

  # calculate distance to previous

# Shifting vectors for latitude and longitude to include end position
shift.vec <- function(vec, shift){
  if (length(vec) <= abs(shift)){
    rep(NA ,length(vec))
  } else {
    if (shift >= 0) {
      c(rep(NA, shift), vec[1:(length(vec) - shift)]) }
    else {
      c(vec[(abs(shift) + 1):length(vec)], rep(NA, abs(shift)))
    }
  }
}

# shifting vectors to calculate distances
data$lat.p1 <- shift.vec(data$lat, -1)
data$lon.p1 <- shift.vec(data$lon, -1)

library(raster)

data$dist.to.prev <- apply(data, 1, FUN = function(row) {
  pointDistance(c(as.numeric(as.character(row["lat.p1"])),
                  as.numeric(as.character(row["lon.p1"]))),
                c(as.numeric(as.character(row["lat"])), as.numeric(as.character(row["lon"]))),
                lonlat = T) # Parameter 'lonlat' has to be TRUE!
})

source("Rounding.R")

