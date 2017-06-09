# Preparatory script
library(dplyr)
library(readr)

d<-readRDS("C:\\Users\\user1\\Desktop\\Life\\Professional\\Statistics Nederland\\gps\\peterLoc.rds")

data<-d %>% top_n(10000,time) %>% select(lat,lon, velocity, accuracy,time)

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



#extract activities
activities <- d$activitys

list.condition <- sapply(activities, function(x) !is.null(x[[1]]))
activities  <- activities[list.condition]

extractActivity<-function(top){
  list.condition <- sapply(top, function(x) !is.null(x[[1]]))
  top  <- top[list.condition]
  time_stamp<-sapply(top, function(x) x[[1]][[1]][[1]][1])
  main_activity<-sapply(top, function(x) x[[2]][[1]][[1]][1])
  main_confidence<-sapply(top, function(x) x[[2]][[1]][[2]][1])
  df<-data.frame(timeStamp=as.numeric(unlist(time_stamp)),activity=unlist(main_activity),confidence = as.numeric(unlist(main_confidence)))
  return(df)
}


act.df<-extractActivity(activities)
# merge activities with locations

## aggregating for every minute 
act.df$timeStamp<-as.POSIXct(as.numeric(as.character(act.df$timeStamp))/1000, origin = "1970-01-01")

mround <- function(x,base){ 
  base*round(x/base) 
} 

act.df<-act.df %>% mutate(day = strftime(timeStamp,"%F"),
                    hour = strftime(timeStamp,"%H"),
                    minute = strftime(timeStamp,"%M"))


by_min<-act.df %>% group_by(day,hour,minute)

act.df_summary<-summarise(by_min,main_activity =names(which.max(table(activity))))

# same w data

data<-data %>% mutate(day = strftime(time,"%F"),
                    hour = strftime(time,"%H"),
                    minute = strftime(time,"%M"))

databy_min<-data %>% group_by(day,hour,minute)



data_summary<-summarise(databy_min,distance = sum(dist.to.prev),
                       lon = mean(lon),
                       lat = mean(lat))

data_summary$tdate<-paste(data_summary$day,data_summary$hour,data_summary$minute,sep="-")
act.df_summary$tdate<-paste(act.df_summary$day,act.df_summary$hour,act.df_summary$minute,sep="-")

df<-merge(x=data_summary,y=act.df_summary,by="tdate",all =T)
# convert distance to km
df$distance<-df$distance/1000

write_csv(x = df,path="test.csv")


# create plot
library(ggplot2)
library(ggmap)

map_blank <- get_map(location = c(median(df$lon),median(df$lat)), zoom = 8, color = "bw")# size should change dynamically

ggmap(map_blank) + geom_point(data = data, aes(x = lon, y = lat), alpha = 0.5, color = "red") + 
  theme(legend.position = "right") + 
  labs(
    x = "Longitude", 
    y = "Latitude", 
    title = "Location history data points")


ggplot(df, aes(x = main_activity, group = main_activity, fill = main_activity)) + 
  geom_bar()  + 
  guides(fill = FALSE) +
  labs(
    x = "",
    y = "Count",
    title = "Main activities in 2017")+theme_tufte()



ggplot(df, aes(x = main_activity, y = distance, fill = main_activity)) + 
  geom_bar(stat="identity")  + 
  guides(fill = FALSE)+xlab("")+ylab("Distance")+theme_tufte()

ggmap(map_blank) + geom_point(data = df, aes(x = lon, y = lat, color = main_activity)) + 
  theme(legend.position = "right")

ggplot(df, aes(x=hour.x, y=distance, color=main_activity)) + geom_point(position=position_jitter(width=1,height=.1))+theme_tufte()+
  ylab("Distance in KM")+xlab("Hour")


# stopped to due shitty train internet for ggmaps
# integrate the plots 

# create plots for Time of Day

# activities include 2014, remove for example data set