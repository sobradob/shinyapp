
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(readr)
library(ggplot2)
library(ggmap)
library(dplyr)


data<-read_csv("test.csv")

shinyServer(function(input, output) {

  output$locPlot<-renderPlot({
    data2<-data %>% filter(day.x > input$daterange[1] & day.x <  input$daterange[2] & main_activity %in% input$activities)
    map_blank <- get_map(location = c(median(data2$lon),median(data2$lat)), zoom = 5, color = "bw")
    
    # size should change dynamically later
    ggmap(map_blank) +geom_point(data = data2, aes(x = lon, y = lat, color = main_activity)) + 
        theme(legend.position = "right") + 
      labs(
        x = "Longitude", 
        y = "Latitude", 
        title = "Country")
  })
  
  output$locPlot2<-renderPlot({
    
    data2<-data %>% filter(day.x > input$daterange[1] & day.x <  input$daterange[2] & main_activity %in% input$activities)
    
    # size should change dynamically later
    map_blank <- get_map(location = c(median(data$lon),median(data$lat)), zoom = 10, color = "bw")
    
    ggmap(map_blank) +geom_point(data = data2, aes(x = lon, y = lat, color = main_activity)) + 
      theme(legend.position = "right") + 
      labs(
        x = "Longitude", 
        y = "Latitude", 
        title = "Country")
  })

  output$actPlot1<-renderPlot({
    
    data2<-data %>% filter(day.x >= input$daterange[1] & day.x <=  input$daterange[2] & main_activity %in% input$activities)
    ggplot(data2, aes(x = main_activity, y = distance, fill = main_activity)) + 
      geom_bar(stat="identity")  + 
      guides(fill = FALSE)+xlab("")+ylab("Distance")+theme_tufte()
    
      })
  output$actPlot2<-renderPlot({
    
    data2<-data %>% filter(day.x >= input$daterange[1] & day.x <=  input$daterange[2] & main_activity %in% input$activities)
    ggplot(data2, aes(x=hour.x, y=distance, color=main_activity)) + geom_point(position=position_jitter(width=1,height=.01))+theme_tufte()+
      ylab("Distance in KM")+xlab("Hour")
    
    
  })
    
  output$text1 <- renderText({
    data2<-data %>% filter(day.x >= input$daterange[1] & day.x <=  input$daterange[2] & main_activity %in% input$activities)
    paste0("Your range contains ",nrow(data2), " observations.")
  })
  output$value <- renderText({ input$somevalue })
  
})
