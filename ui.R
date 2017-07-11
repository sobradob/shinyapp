
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(shinydashboard)

header <- dashboardHeader(title = "Android GPS Location")

sidebar <- dashboardSidebar(
  sidebarMenu(id = "sidebar",
    menuItem("Map", tabName = "map", icon = icon("map")),
    menuItem("Descriptive Statistics", tabName = "descriptives", icon = icon("bar-chart")),
    menuItem("Data Sets", tabName = "dataset", icon = icon("database")),
    dateRangeInput("daterange", "Date range:",
                            start  = min(as.Date(t$time)),
                            end    = max(as.Date(t$time)),
                            min    = min(as.Date(t$time)),
                            max    = max(as.Date(t$time)),
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
                                selected = c("still")))
  )


body <- dashboardBody(
  
  tabItems(
    tabItem(tabName = "map",
            tags$style(type = "text/css", "#mapAct {height: calc(100vh - 80px) !important;}"),
            leafletOutput("mapAct")
            ),
    tabItem(tabName = "descriptives",
            h2("Descriptives")
    ),
    tabItem(tabName = "dataset",
            h2("Data Set")
    )
    ))
    

dashboardPage(header, sidebar, body)


