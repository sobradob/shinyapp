
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(

  # Application title
  titlePanel("Location"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      # Specification of range within an interval
      dateRangeInput("daterange", "Date range:",
                     start  = min(data$day.x),# change to day.x
                     end    = max(data$day.x),
                     min    = min(data$day.x),
                     max    = max(data$day.x),
                     format = "mm-dd-yy",
                     separator = " - "),
      checkboxGroupInput("activities", "Activities to show:",
                         c("Still" = "still",
                           "On Foot" = "onFoot",
                           "Tilting" = "tilting",
                           "On Bicycle" = "onBicycle",
                           "In Vehicle" = "inVehicle",
                           "Unknown" = "unknown",
                           "Exiting Vehicle" = "exitingVehicle"),
                         selected = c("still"))
    ),

    # Pick example data
    # upload data
    # select activity
    # Scatterplot TOD vs KM travelled and mode
    # Barchart w total km travelled
    
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("actPlot1"),
      plotOutput("actPlot2"),
      plotOutput("locPlot2"),
      plotOutput("locPlot"),
      textOutput("text1")
    )
  )
))
