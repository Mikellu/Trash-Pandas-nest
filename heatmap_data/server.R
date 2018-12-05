library(shiny)
library(ggplot2)
library(dplyr)
library(mapproj)
library(maps)
library(R.utils)
library(lubridate)
library(scales)
library(plotly)
library(shinydashboard)

week_data <- data.table::fread("processed data/trend_week.csv", stringsAsFactors = FALSE)
amazon_data <- data.table::fread("processed data/amazon.csv", stringsAsFactors = FALSE)
bitcoin_data <- data.table::fread("processed data/bitcoin.csv", stringsAsFactors = FALSE)
facebook_data <- data.table::fread("processed data/facebook.csv", stringsAsFactors = FALSE)
twitter_data <- data.table::fread("processed data/twitter.csv", stringsAsFactors = FALSE)
tesla_data <- data.table::fread("processed data/tesla.csv", stringsAsFactors = FALSE)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  selectedData <- reactive({
    if(input$Subject == "Amazon"){
      selected_data <- amazon_data
    } else if(input$Subject == "Bitcoin") {
      selected_data <- bitcoin_data
    } else if(input$Subject == "Facebook") {
      selected_data <- facebook_data
    } else if(input$Subject == "Twitter") {
      selected_data <- twitter_data
    } else {
      selected_data <- tesla_data
    }
    return(selected_data)
  })
  
  output$plot1 <- renderPlot({
    map.df <- selectedData() %>% select(-c(region, subregion))
    map.matrix <- data.matrix(map.df)
    a <- ggplot(map.df, aes(x=long,y=lat,group = group)) +
      geom_polygon(aes(fill = map.matrix[, which(as.character(input$date) == colnames(map.df))])) + 
      geom_path() + 
      scale_fill_gradientn(colours=rev(heat.colors(10)),na.value="grey90", limits=c(0,10000))+
      coord_map() +
      guides(fill = guide_legend((title = paste("Search popularity on", input$Subject))))
    return(a)
  })
})
