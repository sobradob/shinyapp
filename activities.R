#activities

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
act.df<-filter(act.df,timeStamp>= min(data$time))# remove unneeded values

write_csv(act.df,path = "activities.csv")

#followed by rounding

