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

shinyUI(dashboardPage(
  skin = "black",
  dashboardHeader(title = "Popularity Exposure VS Stock market", titleWidth = 350),
  dashboardSidebar(
    width = 350,
    sidebarMenu(
      id = "sidebar",
      menuItem("HOME", tabName = "home", icon = icon("columns")),
      menuItem("STOCK VS SEARCH TREND", tabName = "one", icon = icon("chart-line")),
      menuItem("HEATMAP", tabName = "two", icon = icon("map")),
      menuItem("3D STOCK GRAPH", tabName = "three", icon = icon("chart-area"))
    ),
    uiOutput("style_tag")
  ),
  dashboardBody(
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")
    ),
    tabItems(
      # First tab content
      tabItem(
        tabName = "home",
        h2("PROJECT OVERVIEW"),
        p("purpose & general description of data & and structure of the app"),
        h3("OUR AUDIENCE"),
        h3("QUESTIONS"),
        h3("FURTHER ANALYSIS"),
        h3("DATA SOURCE"),
        fluidRow(
          valueBox("Google Trends", "Search Hit API", icon = icon("google"), color = "aqua"),
          valueBox("The Guardian", "News API", icon = icon("newspaper"), color = "light-blue"),
          valueBox("The NY Times", "News API", icon = icon("newspaper"), color = "blue")
        )
      ),
      # Second tab content
      tabItem(
        tabName = "one",
        fluidRow(
          box(
            status = "info",
            dateRangeInput("dates",
              label = h3("Date range"),
              start = as.Date(0, origin = "2013-12-02"),
              end = as.Date(0, origin = "2018-11-26"),
              min = as.Date(0, origin = "2013-12-02"),
              max = as.Date(0, origin = "2018-11-26")
            ),
            selectInput("Subject", h3("Company Name"), choices = list("Amazon", "Bitcoin", "Facebook", "Twitter", "Tesla"))
          ),
          box(
            status = "warning",
            h3("Stock of Companies and Popularity Hit on Google"),
            plotOutput("plot1")
          )
        )
      ),
      # Third tab content
      tabItem(
        tabName = "two",
        fluidPage(
          titlePanel("Heatmap of search popularity"),
          
          # Sidebar with a slider input for number of bins 
          sidebarLayout(
            sidebarPanel(
              sliderInput("date",
                          "Dates:",
                          min = as.Date("2013-12-01","%Y-%m-%d"),
                          max = as.Date("2018-11-18","%Y-%m-%d"),
                          value = as.Date("2013-12-01"),
                          step = 7,
                          animate = TRUE,
                          timeFormat = "%Y-%m-%d"),
              selectInput("company", 
                          "Subject Name", 
                          choices = list("Amazon", "Bitcoin", "Facebook", "Twitter", "Tesla"))
            ),
            mainPanel(
              h3(paste("Heatmap of search popularity of selected company")),
              plotOutput("plot4")
            )
          )
        )
      ),
      # Fourth tab content
      tabItem(
        tabName = "three",
        h2("3D Plot - need to finish"),
        fluidRow(box(status = "warning", plotlyOutput("plot2")), box(status = "warning", plotlyOutput("plot3")))
      )
    )
  )
))
