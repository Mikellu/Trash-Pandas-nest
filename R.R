library(dplyr)
library(ggplot2)
library(lubridate)
library(scales)
library(plotly)

amazon_data <- read.csv("AMZN.csv", stringsAsFactors = FALSE)
bitcoin_data <- read.csv("BTC-USD.csv", stringsAsFactors = FALSE)
facebook_data <- read.csv("FB.csv", stringsAsFactors = FALSE)
twitter_data <- read.csv("TWTR.csv", stringsAsFactors = FALSE)
tesla_data <- read.csv("TSLA.csv", stringsAsFactors = FALSE)

amazon_data$Date <- as.Date(amazon_data$Date, "%m/%d/%Y")

base <- ggplot(amazon_data, aes(Date, Close, color = "Close price")) + geom_line()
base + geom_line(aes(y = Hit * 10, color = "Hit"))  + scale_x_date(date_breaks = "10 month") +
  scale_y_continuous(sec.axis = sec_axis(~./10, name = "number of hit [%]")) -> base
base <- base + scale_color_manual(values = c("blue", "red"))
base <- base + labs(y = "Close price [$ dollar]", x = "Date", color = "Parameter")
base <- base + theme(legend.position = c(0.5, 1))

#mean(amazon_data$Hit) -> mean_num
#amazon_data %>%
  #filter(amazon_data$Hit > mean_num) -> new_amazon
#base <- ggplot(new_amazon, aes(Date, Close, color = "Close price")) + geom_line()
#base + geom_line(aes(y = Hit * 20, color = "Hit"))  + scale_x_date(date_breaks = "12 month") +
  #scale_y_continuous(sec.axis = sec_axis(~./20, name = "number of hit [%]")) -> base
#base <- base + scale_color_manual(values = c("blue", "red"))
#base <- base + labs(y = "Close price [$ dollar]", x = "Date", color = "Parameter")
#base <- base + theme(legend.position = c(0.5, 1))

bitcoin_data$Date <- as.Date(bitcoin_data$Date, "%m/%d/%Y")

base <- ggplot(bitcoin_data, aes(Date, Close, color = "Close price")) + geom_line()
base + geom_line(aes(y = Hit * 100, color = "Hit"))  + scale_x_date(date_breaks = "10 month") +
  scale_y_continuous(sec.axis = sec_axis(~./100, name = "number of hit [%]")) -> base
base <- base + scale_color_manual(values = c("blue", "red"))
base <- base + labs(y = "Close price [$ dollar]", x = "Date", color = "Parameter")
base <- base + theme(legend.position = c(0.5, 1))



facebook_data$Date <- as.Date(facebook_data$Date, "%m/%d/%Y")

base <- ggplot(facebook_data, aes(Date, Close, color = "Close price")) + geom_line()
base + geom_line(aes(y = Hit , color = "Hit"))  + scale_x_date(date_breaks = "10 month") +
  scale_y_continuous(sec.axis = sec_axis(~.* 1, name = "number of hit [%]")) -> base
base <- base + scale_color_manual(values = c("blue", "red"))
base <- base + labs(y = "Close price [$ dollar]", x = "Date", color = "Parameter")
base <- base + theme(legend.position = c(0.5, 1))



twitter_data$Date <- as.Date(twitter_data$Date, "%m/%d/%Y")

base <- ggplot(twitter_data, aes(Date, Close, color = "Close price")) + geom_line()
base + geom_line(aes(y = Hit, color = "Hit"))  + scale_x_date(date_breaks = "10 month") +
  scale_y_continuous(sec.axis = sec_axis(~., name = "number of hit [%]")) -> base
base <- base + scale_color_manual(values = c("blue", "red"))
base <- base + labs(y = "Close price [$ dollar]", x = "Date", color = "Parameter")
base <- base + theme(legend.position = c(0.5, 1))




tesla_data$Date <- as.Date(tesla_data$Date, "%m/%d/%Y")

base <- ggplot(tesla_data, aes(Date, Close, color = "Close price")) + geom_line()
base + geom_line(aes(y = Hit * 4, color = "Hit"))  + scale_x_date(date_breaks = "10 month") +
  scale_y_continuous(sec.axis = sec_axis(~. * 0.25, name = "number of hit [%]")) -> base
base <- base + scale_color_manual(values = c("blue", "red"))
base <- base + labs(y = "Close price [$ dollar]", x = "Date", color = "Parameter")
base <- base + theme(legend.position = c(0.75, 1)) + geom_hline(yintercept = mean(tesla_data$Hit) / 100 * max(tesla_data$Close), 
                                                               linetype="dashed", color = "orange") 