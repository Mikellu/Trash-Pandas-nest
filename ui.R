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
library(gapminder)

shinyUI(dashboardPage(
  skin = "black",
  dashboardHeader(title = "Popularity Exposure VS Stock market", titleWidth = 350),
  dashboardSidebar(
    width = 350,
    sidebarMenu(
      id = "sidebar",
      menuItem("HOME", tabName = "home", icon = icon("columns")),
      menuItem("STOCK AND SEARCH TREND", tabName = "one", icon = icon("chart-line")),
      menuItem("SEARCH HEATMAP", tabName = "two", icon = icon("map")),
      menuItem("3D STOCK GRAPH", tabName = "three", icon = icon("chart-area")),
      menuItem("POPULARITY TREND", tabName = "four", icon = icon("chart-bar")),
      menuItem("TEAM", tabName = "team", icon = icon("home"))
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
        h2(strong("PROJECT OVERVIEW")),
        p("The project provides an overview of popular companies in stock market, the exposure of them in news and their searching popularity on the Internet.
          We hope this project could lower the learning barrier of stocks, provide people with helpful financial insights, and encourage people to learn more about how to invest in stocks in a scientific way."),
        h3("OUR AUDIENCE"),
        p(HTML("While the project should be helpful to anyone, we have a specific target audiences of people who are interested in financial investment and <b>stock</b>, especially the ones who want to know more about the theories related to <mark>Media Exposure</mark> behind it.
          Moreover, we want to educate everyone about the danger of investing base on popular topic(because it is hard to avoid bubble).")),
        h3(em("QUESTIONS")),
        tags$ul(
          tags$li(HTML("Is <mark>Media Exposure</mark> connected to <b>stock</b> price?")),
          tags$li("What is the connection between them? Should you invest in hot-topic?"),
          tags$li("What are some specific examples to illustrate this concept (irrational market)?"),
          tags$li("What is a good strategy of avoiding financial crisis in investment?")),
        h3("FURTHER ANALYSIS"),
        tags$ul(
          tags$li("What if we use the daily data to illustrate predictions of trading day by day?"),
          tags$li(HTML("Can we predict the peak of bubble base on <mark>Media Exposure</mark>?"))
        ),
        h3(em("DATA SOURCE")),
        p("The dataset of stock price, news mention and search hit ranges from Nov 2013 to Nov 2018.
          It covers the popular companies including Amazon, Facebook, Twitter, Tesla and Bitcoin in the form of stocks.
          While we obtaining our stock data from Yahoo Finance, our news mention data is coming from the APIs provided by two of the largest presses in the world - The Guardian from the UK and The NY Times from the US.
          We also have our search hits data from Google Trends provided by Google."),
        p(HTML("<em>Please click on the card to navigate to the website if you are interested.</em>")),
        fluidRow(
          valueBox("Yahoo Finance", "Stock Dataset", icon = icon("yahoo"), color = "teal", href = "https://trends.google.com/trends/\" target=\"_blank", width = 3),
          valueBox("Google Trends", "Search Hit API", icon = icon("google"), color = "aqua", href = "https://trends.google.com/trends/\" target=\"_blank", width = 3),
          valueBox("The Guardian", "News API", icon = icon("newspaper"), color = "light-blue", href = "https://open-platform.theguardian.com/\" target=\"_blank", width = 3),
          valueBox("The NY Times", "News API", icon = icon("newspaper"), color = "blue", href = "https://developer.nytimes.com/\" target=\"_blank", width = 3)
        )
      ),
      # Second tab content
      tabItem(
        tabName = "one",
        h2("Trend of Stock Price and Search Hit"),
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
          p(HTML(" We pull out stock data from Yahoo Finance to create a weekly stock chart. In this stock chart, the left
                     axis is about Closed price on weekly base. The right axis is about percentile base on google trend(100% is the
                     maximum of hits). We purposely make the scale two times than it is because this way creates a better visual
                     appearance for the users to compare the graph. Changing the time input can really help audience to see the
                     connection between <mark>Media Exposure</mark> and stock price in short time period. "))
        ),
        fluidRow(
          box(
            status = "warning",
            width = 12,
            plotOutput("plot1", height = 500, width = 1000)

          )
        )
      ),
      # Third tab content
      tabItem(
        tabName = "two",
        h2("Heatmap of Search Popularity"),
        # Sidebar with a slider input for number of bins
        fluidRow(box(status = "info",
                     width = 8,
                     sliderInput("date",
                                 "Dates:",
                                 min = as.Date("2013-12-01","%Y-%m-%d"),
                                 max = as.Date("2018-11-18","%Y-%m-%d"),
                                 value = as.Date("2013-12-01"),
                                 step = 21,
                                 animate = TRUE,
                                 timeFormat = "%Y-%m-%d"),
                     selectInput("company",
                                 "Subject Name",
                                 choices = list("Amazon", "Bitcoin", "Facebook", "Twitter", "Tesla"))
                     ),
                 p("text explaining the graphhhhhhhh text explaining the graphhhhhhhh text explaining the graphhhhhhhh text explaining the graphhhhhhhh text explaining the graphhhhhhhh text explaining the graphhhhhhhh text explaining the graphhhhhhhh")
        ),
        fluidRow(box(status = "warning", width = 12, plotOutput("plot4")))
      ),
      # Fourth tab content
      tabItem(
        tabName = "three",
        h2("Trend of News Mention with Stock Price and Search Hit"),
        fluidRow(
          column(width = 3,
                 box(status = "info", width = NULL, 
                     radioButtons("radio3d", label = h3("Choice of Company"),
                                  choices = list("Facebook" = 1, "Twitter" = 2, "Both" = 3), 
                                  selected = 1)),
                 p(HTML("We pull out Facebook and Twitter to create a 3D plot with stock price, news mention and search hit as the three axes.
          We choose these two companies as they are commonly-mentioned Internet companies in the news.
                        From the plots we can see the dots usually go in clusters for each companies in recent dates, which means their popularity as well as financial performance are usually stable throughout the time.
                        At the same time, we can observe the trend which when there are more mentions in the news, the lower the stock prices are for the companies."))
                 ),
          column(width = 9,
                 align="center",
            box(status = "warning", width = NULL,
                plotlyOutput("plot2", height = 700, width = 800))
          )
        )
      ),
      tabItem(
        tabName = "four",
        align = "center",
        h2("Trend of News Mention with Stock Price and Search Hit"),
        fluidRow(
          box(status = "warning")
        ),
        fluidRow(
          p(HTML("Put something here..."))
        )
      ),
      tabItem(
        tabName = "team",
        align = "center",
        h2("TEAM TRASH PANDA"),
        h2("Jojo & Mico & Oliver & Ziva"),
        imageOutput("meme")
      )
    )
  )
))
