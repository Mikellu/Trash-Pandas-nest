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


shinyUI(fluidPage(
  titlePanel("Popularity Exposure VS Stock market"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      dateRangeInput("dates", 
                     label = h3("Date range"),
                     start = as.Date(0, origin = "2013-12-02"),
                     end = as.Date(0, origin = "2018-11-26"),
                     min = as.Date(0, origin = "2013-12-02"),
                     max = as.Date(0, origin = "2018-11-26")),
      selectInput("Subject", "Subject Name", choices=list("Amazon", "Bitcoin", "Facebook", "Twitter", "Tesla"))
    ),
    
    mainPanel(
      h2("Stock of companies and Popularity hit on Google"),
      plotOutput("plot1")
    )
  )
))
