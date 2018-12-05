library(shinydashboard)
library(shiny)
library(ggplot2)
library(dplyr)
library(mapproj)
library(maps)
library(R.utils)
library(lubridate)
library(scales)
library(plotly)
library(rsconnect)

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
        p("The project provides an overview of popular companies in stock market, the exposure of them in news and their searching popularity on the Internet.
          We hope this project could lower the learning barrier of stocks, provide people with helpful financial insights, and encourage people to learn more about how to invest in stocks in a scientific way."),
        h3("OUR AUDIENCE"),
        p("While the project should be helpful to anyone, we have a specific target audiences of people who are interested in financial investment and stock, especially the ones who want to know more about the theories related to medias behind it."),
        h3("QUESTIONS"),
        h3("FURTHER ANALYSIS"),
        h3("DATA SOURCE"),
        p("The dataset of stock price, news mention and search hit ranges from Nov 2013 to Nov 2018.
          It covers the popular companies including Amazon, Facebook, Twitter, Tesla and Bitcoin in the form of stocks.
          While we obtaining our stock data from Yahoo Finance, our news mention data is coming from the APIs provided by two of the largest presses in the world - The Guardian from the UK and The NY Times from the US.
          We also have our search hits data from Google Trends provided by Google."),
        p("Please click on the card to navigate to the website if you are interested."),
        fluidRow(
          valueBox("Google Trends", "Search Hit API", icon = icon("google"), color = "aqua", href = "https://trends.google.com/trends/\" target=\"_blank"),
          valueBox("The Guardian", "News API", icon = icon("newspaper"), color = "light-blue", href = "https://open-platform.theguardian.com/\" target=\"_blank"),
          valueBox("The NY Times", "News API", icon = icon("newspaper"), color = "blue", href = "https://developer.nytimes.com/\" target=\"_blank")
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
        h2("Trend of News Mention with Stock Price and Search Hit"),
        fluidRow(box(status = "warning", plotlyOutput("plot2")), box(status = "warning", plotlyOutput("plot3"))),
        fluidRow(p("We pull out Facebook and Twitter to create a 3D plot with stock price, news mention and search hit as the three axes.
          We choose these two companies as they are commonly-mentioned Internet companies in the news.
          From the plots we can see the dots usually go in clusters for each companies in recent dates, which means their popularity as well as financial performance are usually stable throughout the time.
          At the same time, we can observe the trend which when there are more mentions in the news, the lower the stock prices are for the companies."))
      )
    )
  )
))
