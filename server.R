

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
  twitter_3d <- read.csv("3dplot-data/twitter-final.csv")
  
  render_3d_standard <- function(data, p_title) {
    p <- plot_ly(data, x = ~Hit, y = ~News, z = ~Close,
                 marker = list(size = 7, color = ~News, colorscale = c('#FFE1A1', '#683531'), showscale = TRUE)) %>%
      add_markers() %>%
      layout(title = p_title,
             height = 500,
        scene = list(xaxis = list(title = 'Search Hit (%)'),
                          yaxis = list(title = 'News Mention'),
                          zaxis = list(title = 'Stock Price')),
             annotations = list(
               x = 1.13,
               y = 1.05,
               text = 'Weekly News Mention',
               xref = 'paper',
               yref = 'paper',
               showarrow = TRUE
             ))
    return(p)
  }
  
  output$plot2 <- renderPlotly({
    render_3d_standard(facebook_3d, "Stock Price vs News Mention<br>vs Search Hit for Facebook<br> from 2013 to 2018")
  })
  
  output$plot3 <- renderPlotly({
    render_3d_standard(twitter_3d, "Stock Price vs News Mention<br>vs Search Hit for Twitter<br> from 2013 to 2018")
  })
  
  # heatmap plotting
  #week_data <- data.table::fread("heatmap_data/processed_data/trend_week.csv", stringsAsFactors = FALSE)
  amazon_data <- data.table::fread("heatmap_data/processed_data/amazon.csv", stringsAsFactors = FALSE)
  bitcoin_data <- data.table::fread("heatmap_data/processed_data/bitcoin.csv", stringsAsFactors = FALSE)
  facebook_data <- data.table::fread("heatmap_data/processed_data/facebook.csv", stringsAsFactors = FALSE)
  twitter_data <- data.table::fread("heatmap_data/processed_data/twitter.csv", stringsAsFactors = FALSE)
  tesla_data <- data.table::fread("heatmap_data/processed_data/tesla.csv", stringsAsFactors = FALSE)
  
  selectedData2 <- reactive({
    if(input$company == "Amazon"){
      map.df <- amazon_data
    } else if(input$company == "Bitcoin") {
      map.df <- bitcoin_data
    } else if(input$company == "Facebook") {
      map.df <- facebook_data
    } else if(input$company == "Twitter") {
      map.df <- twitter_data
    } else {
      map.df <- tesla_data
    }
    return(map.df)
  })
  
  output$plot4 <- renderPlot({
    map.df <- selectedData2() %>% select(-c(region, subregion))
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
