library(shiny)
library(dplyr, warn.conflicts = FALSE)
library(ggplot2)
library(readr)
library(plotly)
library(bslib)

library(leaflet)
library(leaflet.extras)

setwd("/Users/alexandrefacon-bocquet/Documents/olympics-dashboard")
olympic_data = read_csv("olympic_medals_tab.csv")


############ MAP DATA ################
localisation <- olympic_data
localisation$season = paste(localisation$year, localisation$edition, sep = " ")
localisation <- localisation %>%
  select(city_host, season, lat, long) %>%
  filter(!duplicated(season))


ui <- fluidPage(
  #numericInput("min", "Minimum", 0),
  #numericInput("max", "Maximum", 3),
  #sliderInput("n", "n", min = 0, max = 3, value = 1),
  selectInput("season", "Season", choices = unique(localisation$season)),
  leafletOutput("map")
)


server <- function(input, output, session) {
  
  
  filteredData <- reactive({
    localisation[localisation$season == input$season,]
    #quakes[quakes$mag >= input$range[1] & quakes$mag <= input$range[2],]
  })

  
  output$map <- renderLeaflet({
    
    myIcon <- makeIcon(
      iconUrl = "Olympics-Logo.png",
      iconWidth = 50, #iconHeight = 95,
      iconAnchorX = 15, iconAnchorY = 24,
    )
    
    
    leaflet() %>%
      addProviderTiles(providers$CartoDB.Positron) %>%  
      #addTiles() %>%
      addMarkers(lng = localisation$long, 
                 lat = localisation$lat, 
                 popup = paste0("<strong>", localisation$city_host, "</strong><br>","Edition: ", localisation$season),
                 clusterOptions = markerClusterOptions(),
                 icon = myIcon)
  })
  
  
}





shinyApp(ui = ui, server = server)
