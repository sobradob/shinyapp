
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(readr)
library(ggplot2)
library(ggmap)


data<-read_csv("test.csv")

shinyServer(function(input, output) {

  output$distPlot <- renderPlot({

    # generate bins based on input$bins from ui.R
    x    <- data[[4]]
    bins <- seq(min(x), max(x), length.out = input$bins + 1)

    # draw the histogram with the specified number of bins
    hist(x, breaks = bins, col = 'darkgray', border = 'white')

  })

  output$locPlot<-renderPlot({
    
    # size should change dynamically later
    map_blank <- get_map(location = c(median(data$lon),median(data$lat)), zoom = 8, color = "bw")
    
    ggmap(map_blank) + geom_point(data = data, aes(x = lon, y = lat), alpha = 0.5, color = "red") + 
      theme(legend.position = "right") + 
      labs(
        x = "Longitude", 
        y = "Latitude", 
        title = "Location history data points")
  })
})
