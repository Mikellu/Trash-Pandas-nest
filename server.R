library(shiny)
library(ggplot2)
library(dplyr)
library(mapproj)
library(maps)
library(R.utils)
library(lubridate)
library(scales)
library(plotly)

amazon_data <- read.csv("stock/AMZN.csv", stringsAsFactors = FALSE)
amazon_data$Date <- as.Date(amazon_data$Date, "%m/%d/%Y")
bitcoin_data <- read.csv("stock/BTC-USD.csv", stringsAsFactors = FALSE)
bitcoin_data$Date <- as.Date(bitcoin_data$Date, "%m/%d/%Y")
facebook_data <- read.csv("stock/FB.csv", stringsAsFactors = FALSE)
facebook_data$Date <- as.Date(facebook_data$Date, "%m/%d/%Y")
twitter_data <- read.csv("stock/TWTR.csv", stringsAsFactors = FALSE)
twitter_data$Date <- as.Date(twitter_data$Date, "%m/%d/%Y")
tesla_data <- read.csv("stock/TSLA.csv", stringsAsFactors = FALSE)
tesla_data$Date <- as.Date(tesla_data$Date, "%m/%d/%Y")


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
    base_data <- selectedData() %>%
                  filter(Date > input$dates[1] & Date < input$dates[2])
    if(input$Subject == "Tesla") {
      base <- ggplot(base_data, aes(Date, Close, color = "Close price")) + geom_line()
      base + geom_line(aes(y = Hit * 4, color = "Hit"))  +
        scale_y_continuous(sec.axis = sec_axis(~. * 0.25, name = "number of hit [%]")) -> base
      base <- base + scale_color_manual(values = c("blue", "red"))
      base <- base + labs(y = "Close price [$ dollar]", x = "Date", color = "Parameter")
      base <- base + theme(legend.position = c(0.75, 1)) + geom_hline(yintercept = mean(base_data$Hit) / 100 * max(base_data$Close), 
                                                                      linetype="dashed", color = "orange")
    } else if(input$Subject == "Amazon"){
      base <- ggplot(base_data, aes(Date, Close, color = "Close price")) + geom_line()
      base + geom_line(aes(y = Hit * 10, color = "Hit"))  +
        scale_y_continuous(sec.axis = sec_axis(~. / 10, name = "number of hit [%]")) -> base
      base <- base + scale_color_manual(values = c("blue", "red"))
      base <- base + labs(y = "Close price [$ dollar]", x = "Date", color = "Parameter")
      base <- base + theme(legend.position = c(0.75, 1)) + geom_hline(yintercept = mean(base_data$Hit) / 200 * max(base_data$Close), 
                                                                        linetype="dashed", color = "orange")
    } else if(input$Subject == "Bitcoin"){
      base <- ggplot(base_data, aes(Date, Close, color = "Close price")) + geom_line()
      base + geom_line(aes(y = Hit * 100, color = "Hit"))  +
        scale_y_continuous(sec.axis = sec_axis(~. / 100, name = "number of hit [%]")) -> base
      base <- base + scale_color_manual(values = c("blue", "red"))
      base <- base + labs(y = "Close price [$ dollar]", x = "Date", color = "Parameter")
      base <- base + theme(legend.position = c(0.75, 1)) + geom_hline(yintercept = mean(base_data$Hit) / 200 * max(base_data$Close), 
                                                                      linetype="dashed", color = "orange")
    } else {
      base <- ggplot(base_data, aes(Date, Close, color = "Close price")) + geom_line()
      base + geom_line(aes(y = Hit, color = "Hit"))+
        scale_y_continuous(sec.axis = sec_axis(~., name = "number of hit [%]")) -> base
      base <- base + scale_color_manual(values = c("blue", "red"))
      base <- base + labs(y = "Close price [$ dollar]", x = "Date", color = "Parameter")
      base <- base + theme(legend.position = c(0.75, 1)) + geom_hline(yintercept = mean(base_data$Hit) / 200 * max(base_data$Close), 
                                                                      linetype="dashed", color = "orange")
    }
    return(base)
  })
  
  facebook_3d <- read.csv("3dplot-data/facebook-final.csv")
  
  output$plot2 <- renderPlotly({
    p <- plot_ly(facebook_3d, x = ~Hit, y = ~News, z = ~Close,
                 marker = list(color = ~Hit, colorscale = c('#FFE1A1', '#683531'), showscale = TRUE)) %>%
      add_markers() %>%
      layout(scene = list(xaxis = list(title = 'Search Hit'),
                          yaxis = list(title = 'News Mention'),
                          zaxis = list(title = 'Stock Price')),
             annotations = list(
               x = 2,
               y = 1.05,
               text = 'Miles/(US) gallon',
               xref = 'paper',
               yref = 'paper',
               showarrow = FALSE
             ))
  })
  
  twitter_3d <- read.csv("3dplot-data/twitter-final.csv")
  
  output$plot3 <- renderPlotly({
    p <- plot_ly(twitter_3d, x = ~Hit, y = ~News, z = ~Close, 
                 marker = list(color = ~News, colorscale = c('#FFE1A1', '#683531'), showscale = TRUE)) %>%
      add_markers() %>%
      layout(scene = list(xaxis = list(title = 'Search Hit'),
                          yaxis = list(title = 'News Mention'),
                          zaxis = list(title = 'Stock Price')),
             annotations = list(
               x = 1.13,
               y = 1.05,
               text = 'Miles/(US) gallon',
               xref = 'paper',
               yref = 'paper',
               showarrow = FALSE
             ))
  })
  
})
