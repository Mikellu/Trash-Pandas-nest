week_data <- data.table::fread("processed data/trend_week.csv", stringsAsFactors = FALSE)
amazon_data <- data.table::fread("processed data/amazon.csv", stringsAsFactors = FALSE)
bitcoin_data <- data.table::fread("processed data/bitcoin.csv", stringsAsFactors = FALSE)
facebook_data <- data.table::fread("processed data/facebook.csv", stringsAsFactors = FALSE)
twitter_data <- data.table::fread("processed data/twitter.csv", stringsAsFactors = FALSE)
tesla_data <- data.table::fread("processed data/tesla.csv", stringsAsFactors = FALSE)

shinyUI(fluidPage(
  titlePanel("Heatmap of search popularity"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      sliderInput("date",
                  "Dates:",
                  min = as.Date("2013-12-01","%Y-%m-%d"),
                  max = as.Date("2018-11-18","%Y-%m-%d"),
                  value = as.Date("2013-12-01"),
                  timeFormat = "%Y-%m-%d"),
      selectInput("Subject", 
                  "Subject Name", 
                  choices = list("Amazon", "Bitcoin", "Facebook", "Twitter", "Tesla"))
    ),
    mainPanel(
      h3("Heatmap of search popularity of selected company"),
      plotOutput("plot1")
    )
  )
))
