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
library(gapminder)

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
      base + geom_line(aes(y = Hit * 4, color = "Hit"))  + ggtitle("Stock Price VS. Search of Hit") + 
        scale_y_continuous(sec.axis = sec_axis(~. * 0.25, name = "number of hit [%]")) -> base
      base <- base + scale_color_manual(values = c("blue", "red"))
      base <- base + labs(y = "Close price [$ dollar]", x = "Date", color = "Parameter")
      base <- base + theme(legend.position = c(0.75, 1.03)) + geom_hline(yintercept = mean(base_data$Hit) / 100 * max(base_data$Close), 
                                                                      linetype="dashed", color = "orange")
    } else if(input$Subject == "Amazon"){
      base <- ggplot(base_data, aes(Date, Close, color = "Close price")) + geom_line()
      base + geom_line(aes(y = Hit * 10, color = "Hit")) + ggtitle("Stock Price VS. Search of Hit") +
        scale_y_continuous(sec.axis = sec_axis(~. / 10, name = "number of hit [%]")) -> base
      base <- base + scale_color_manual(values = c("blue", "red"))
      base <- base + labs(y = "Close price [$ dollar]", x = "Date", color = "Parameter")
      base <- base + theme(legend.position = c(0.75, 1.03)) + geom_hline(yintercept = mean(base_data$Hit) / 200 * max(base_data$Close), 
                                                                        linetype="dashed", color = "orange")
    } else if(input$Subject == "Bitcoin"){
      base <- ggplot(base_data, aes(Date, Close, color = "Close price")) + geom_line()
      base + geom_line(aes(y = Hit * 100, color = "Hit")) + ggtitle("Stock Price VS. Search of Hit") +
        scale_y_continuous(sec.axis = sec_axis(~. / 100, name = "number of hit [%]")) -> base
      base <- base + scale_color_manual(values = c("blue", "red"))
      base <- base + labs(y = "Close price [$ dollar]", x = "Date", color = "Parameter")
      base <- base + theme(legend.position = c(0.75, 1.03)) + geom_hline(yintercept = mean(base_data$Hit) / 200 * max(base_data$Close), 
                                                                      linetype="dashed", color = "orange")
    } else {
      base <- ggplot(base_data, aes(Date, Close, color = "Close price")) + geom_line()
      base + geom_line(aes(y = Hit, color = "Hit")) + ggtitle("Stock Price VS. Search of Hit") +
        scale_y_continuous(sec.axis = sec_axis(~., name = "number of hit [%]")) -> base
      base <- base + scale_color_manual(values = c("blue", "red"))
      base <- base + labs(y = "Close price [$ dollar]", x = "Date", color = "Parameter")
      base <- base + theme(legend.position = c(0.75, 1.03)) + geom_hline(yintercept = mean(base_data$Hit) / 200 * max(base_data$Close), 
                                                                      linetype="dashed", color = "orange")
    }
    return(base)
  })
  
  facebook_3d <- read.csv("3dplot-data/facebook-final.csv")
  twitter_3d <- read.csv("3dplot-data/twitter-final.csv")
  
  render_3d_standard <- function(data, p_title, color) {
    p <- plot_ly(data, x = ~Hit, y = ~News, z = ~Close,
                 marker = list(size = 5, color = ~X, colorscale = color, showscale = TRUE, colorbar = list(len = 0.5, title = "Date<br>(from<br>recent<br>to old)"))) %>%
      add_markers() %>%
      layout(title = p_title, margin = list(pad = 0, l = 20, r = 0, b = 10, t = 30), 
        scene = list(xaxis = list(title = 'Search Hit (%)', titlefont = list(size = 13), tickfont = list(size = 10)),
                          yaxis = list(title = 'News Mention', titlefont = list(size = 13), tickfont = list(size = 10)),
                          zaxis = list(title = 'Stock Price', titlefont = list(size = 13), tickfont = list(size = 10))))
    return(p)
  }
  
  
  fb_3d_subplot <- plot_ly(facebook_3d, x = ~Hit, y = ~News, z = ~Close, scene='scene',
                                   marker = list(size = 4, color = ~X, colorscale = "Portland", showscale = TRUE, colorbar = list(len = 0.8, title = "Date<br>(from<br>recent<br>to old)"))) %>%
                   add_markers()
  twitter_3d_subplot <- plot_ly(twitter_3d, x = ~Hit, y = ~News, z = ~Close, scene='scene2',
                                marker = list(size = 4, color = ~X, colorscale = "Portland", showscale = TRUE, colorbar = list(len = 0.8, title = "Date<br>(from<br>recent<br>to old)"))) %>%
                        add_markers()
  
  selection_3d <- reactive({input$radio3d})
  output$plot2 <- renderPlotly({
    if (selection_3d() == 1) {
      render_3d_standard(facebook_3d, "Stock Price vs News Mention vs Search Hit for <b>Facebook</b> from 2013 to 2018", 'Portland')
    } else if (selection_3d() == 2) {
      render_3d_standard(twitter_3d, "Stock Price vs News Mention vs Search Hit for <b>Twitter</b> from 2013 to 2018", 'Portland')
    } else {
      subplot_final <- subplot(fb_3d_subplot, twitter_3d_subplot) %>%
        layout(
          title = "Stock Price vs News Mention vs Search Hit from 2013 to 2018",
          showlegend=F,
          scene = list(xaxis = list(title = 'Search Hit (%)', titlefont = list(size = 13), tickfont = list(size = 10)),
                       yaxis = list(title = 'News Mention', titlefont = list(size = 13), tickfont = list(size = 10)),
                       zaxis = list(title = 'Stock Price', titlefont = list(size = 13), tickfont = list(size = 10)),
                       aspectmode='auto',
                       domain=list(x=c(0,1),y=c(0.5,1))),
          scene2 = list(xaxis = list(title = 'Search Hit (%)', titlefont = list(size = 13), tickfont = list(size = 10)),
                        yaxis = list(title = 'News Mention', titlefont = list(size = 13), tickfont = list(size = 10)),
                        zaxis = list(title = 'Stock Price', titlefont = list(size = 13), tickfont = list(size = 10)),
                        aspectmode='auto',
                        domain=list(x=c(0,1),y=c(0,0.5))),
          annotations = list(
            list(x = 0.5 , y = 1, text = "Facebook", showarrow = F, xref='paper', yref='paper'),
            list(x = 0.5 , y = 0.48, text = "Twitter", showarrow = F, xref='paper', yref='paper'))
        )
      return(subplot_final)
    }
  })
    
  # heatmap plotting
  week_data_map <- data.table::fread("heatmap_data/processed_data/trend_week.csv", stringsAsFactors = FALSE)
  amazon_data_map <- data.table::fread("heatmap_data/processed_data/amazon.csv", stringsAsFactors = FALSE)
  bitcoin_data_map <- data.table::fread("heatmap_data/processed_data/bitcoin.csv", stringsAsFactors = FALSE)
  facebook_data_map <- data.table::fread("heatmap_data/processed_data/facebook.csv", stringsAsFactors = FALSE)
  twitter_data_map <- data.table::fread("heatmap_data/processed_data/twitter.csv", stringsAsFactors = FALSE)
  tesla_data_map <- data.table::fread("heatmap_data/processed_data/tesla.csv", stringsAsFactors = FALSE)
  
  chosenData <- reactive({
    if(input$company == "Amazon"){
      map.df <- amazon_data_map %>% select(-c(region, subregion))
    } else if(input$company == "Bitcoin") {
      map.df <- bitcoin_data_map %>% select(-c(region, subregion))
    } else if(input$company == "Facebook") {
      map.df <- facebook_data_map %>% select(-c(region, subregion))
    } else if(input$company == "Twitter") {
      map.df <- twitter_data_map %>% select(-c(region, subregion))
    } else {
      map.df <- tesla_data_map %>% select(-c(region, subregion))
    }
    return(map.df)
  })
  
  output$plot4 <- renderPlot({
    map.df <- chosenData() 
    map.matrix <- data.matrix(map.df)
    a <- ggplot(map.df, aes(x=long,y=lat,group = group)) +
      geom_polygon(aes(fill = map.matrix[, which(as.character(input$date) == colnames(map.df))])) + 
      geom_path() + 
      scale_fill_gradientn(colours=rev(heat.colors(10)),na.value="grey90", limits=c(0,100))+
      coord_map() +
      guides(fill = guide_legend((title = paste("Search popularity on", input$Subject))))+
      ggtitle(paste("US Heatmap of Search Popularity for", input$company)) + 
      theme(plot.title = element_text(size = 17))
    return(a)
  })
  
  output$meme <- renderImage({
    return(list(
      src = "meme.jpg",
      filetype = "image/jpeg",
      alt = "Welcome to Trash Panda's Nest!"
    ))
  }, deleteFile = FALSE)
  
})
