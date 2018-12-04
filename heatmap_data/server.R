library(shiny)
library(ggplot2)
library(dplyr)
library(mapproj)
library(maps)
library(R.utils)
library(lubridate)
library(scales)
library(plotly)

week_data <- data.table::fread("processed data/trend_week.csv", stringsAsFactors = FALSE)
amazon_data <- data.table::fread("processed data/amazon.csv", stringsAsFactors = FALSE)
bitcoin_data <- data.table::fread("processed data/bitcoin.csv", stringsAsFactors = FALSE)
facebook_data <- data.table::fread("processed data/facebook.csv", stringsAsFactors = FALSE)
twitter_data <- data.table::fread("processed data/twitter.csv", stringsAsFactors = FALSE)
tesla_data <- data.table::fread("processed data/tesla.csv", stringsAsFactors = FALSE)
map.df <- amazon_data

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  selectedData <- reactive({
    if(input$Subject == "Amazon"){
      map.df <- amazon_data
    } else if(input$Subject == "Bitcoin") {
      map.df <- bitcoin_data
    } else if(input$Subject == "Facebook") {
      map.df <- facebook_data
    } else if(input$Subject == "Twitter") {
      map.df <- twitter_data
    } else {
      map.df <- tesla_data
    }
    return(selected_data)
  })
   
  output$plot1 <- renderPlot({
    a <- ggplot(map.df, aes(x=long,y=lat,group= map.df$group))+
      geom_polygon(aes(fill = as.character(input$date)))+
      geom_path()+ 
      scale_fill_gradientn(colours=rev(heat.colors(10)),na.value="grey90", limits=c(0,10000))+
      coord_map()
    return(a)
  })
  
})
