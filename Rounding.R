# Second rounding scritp
base<-60
# rounding function
mround <- function(x,base){ 
  base*round(x/base) 
} 

#round by seconds
act.df$roundTs<-mround(as.numeric(act.df$timeStamp),base)
act.df$roundTs<-as.POSIXct(as.numeric(as.character(act.df$roundTs)), origin = "1970-01-01")

#skip this below?
act.df<-act.df %>% mutate(day = strftime(roundTs,"%F"),
                          hour = strftime(roundTs,"%H"),
                          minute = strftime(roundTs,"%M"),
                          second = strftime(roundTs,"%S"))


# count duplicates
paste0(act.df$day,act.df$hour,act.df$minute,act.df$second) %>% duplicated()%>% sum()

write_csv(x = act.df[sort(c(which(act.df$dup == T)-1,which(act.df$dup == T))),],
          path = "duplicateAnalysis.csv")

#aggregate for duplicates
by_sec<-act.df %>% group_by(day,hour,minute,second)

act.df_summary<-summarise(by_sec,main_activity =names(which.max(table(activity))),
                                confidence = names(which.max(table(confidence))))# warning this isn't optimal

# same w data

data$roundTs<-mround(as.numeric(data$time),base)
data$roundTs<-as.POSIXct(as.numeric(as.character(data$roundTs)), origin = "1970-01-01")

data<-data %>% mutate(day = strftime(roundTs,"%F"),
                          hour = strftime(roundTs,"%H"),
                          minute = strftime(roundTs,"%M"),
                          second = strftime(roundTs,"%S"))

databy_sec<-data %>% group_by(day,hour,minute,second)

data_summary<-summarise(databy_sec,distance = sum(dist.to.prev),
                        lon = mean(lon),
                        lat = mean(lat),
                        accuracy = mean(accuracy),
                        velocity = mean(velocity))

#prepare merge
data_summary$tdate<-paste(data_summary$day,data_summary$hour,data_summary$minute,data_summary$second,sep="-")
act.df_summary$tdate<-paste(act.df_summary$day,act.df_summary$hour,act.df_summary$minute,act.df_summary$second,sep="-")

df<-merge(x=data_summary,y=act.df_summary,by="tdate",all =T)
# convert distance to km
df$distance<-df$distance/1000

write_csv(x = df,path="test.csv")


# another approach
t<-data.frame(time = c(data$time,act.df$timeStamp),
              act = c(rep(NA,nrow(data)), as.character(act.df$activity)),
              confidence = c(rep(NA,nrow(data)),act.df$confidence),
              lat = c(data$lat,rep(NA,nrow(act.df))),
              lon = c(data$lon,rep(NA,nrow(act.df))))

t<-t %>% arrange(time)

t$tb<-t$time-as.POSIXct(shift.vec(t$time,1), origin = "1970-01-01")
t$ta<-as.POSIXct(shift.vec(t$time,-1), origin = "1970-01-01")-t$time
timediff<-vector()
a<-1
for( i in 2:nrow(t)-1){
  if(is.na(t$lat[i])){
    if(t$tb[i]> t$ta[i]){
      t$lat[i]<-t$lat[i+1]
      t$lon[i]<-t$lon[i+1]
      timediff[a]<-t$ta[i]
      a<-a+1
    }else{
      t$lat[i]<-t$lat[i-1]
      t$lon[i]<-t$lon[i-1]
      timediff[a]<-t$tb[i]
      a<-a+1
    }
  }
}

summary(timediff)
#first and last row are missing
t<-na.omit(t) # calculate distance?

t$lat.p1 <- shift.vec(t$lat, -1)
t$lon.p1 <- shift.vec(t$lon, -1)

library(raster)

t$dist.to.prev <- apply(t, 1, FUN = function(row) {
  pointDistance(c(as.numeric(as.character(row["lat.p1"])),
                  as.numeric(as.character(row["lon.p1"]))),
                c(as.numeric(as.character(row["lat"])), as.numeric(as.character(row["lon"]))),
                lonlat = T) # Parameter 'lonlat' has to be TRUE!
})
t$dist.to.prev<-t$dist.to.prev/1000

write_csv(t,path = "tActivites.csv")

