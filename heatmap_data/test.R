library(shiny)
library(R.utils)
library(data.table)
library(ggplot2)
library(maps)
library(mapproj)
library(lubridate)
library(dplyr)
library(gtrendsR)

<<<<<<< HEAD

amazon_state <- data.table::fread("googlestate/state-pop-amazon.csv")
amazon_state <- amazon_state[-c(4, 26), ]
amazon_state$Region <- tolower(amazon_state$Region)
amazon_state <- rename(amazon_state, region = Region)
amazon_state_copy <- amazon_state

amazon_trend <- data.table::fread("googlesearch/AMAZ_trend.csv") 
amazon_trend <- amazon_trend[-c(261), ]
=======
bitcoin_state <- data.table::fread("googlestate/state-pop-bitcoin.csv")
bitcoin_state <- bitcoin_state[-c(which(grepl("Hawaii", bitcoin_state$Region)), which(grepl("Alaska", bitcoin_state$Region))), ]
bitcoin_state$Region <- tolower(bitcoin_state$Region)
bitcoin_state <- rename(bitcoin_state, region = Region)
bitcoin_state_copy <- bitcoin_state

bitcoin_trend <- data.table::fread("googlesearch/BTC_trend.csv") 
bitcoin_trend <- bitcoin_trend[-c(261), ]
>>>>>>> michael

state_abb <- data.table::fread("state-abbreviations.csv") 
state_abb <- state_abb[-c(2, 12), ]
state_abb$State <- tolower(state_abb$State)
state_abb <- rename(state_abb, region = State)
bitcoin_state <- merge(state_abb, bitcoin_state, by="region", all.x=T) #%>% 
bitcoin_state_name <- bitcoin_state

for (i in 1:49) {
  data <- gtrends("bitcoin", geo = paste("US", bitcoin_state_name[i, "Abbreviation"], sep = "-"), 
                  gprop = "web", time = "2013-12-01 2018-11-18")$interest_over_time
  data <- mutate(data, date = paste(as.Date(date, format = "%m-%d-%Y"))) %>% 
    select("date", "hits") 
  names(data)[2] <- paste(bitcoin_state_name[i, "region"])
  write.csv(data, file = paste("bitcoin_state_trends/", bitcoin_state_name[i, "region"], ".csv", sep = ""), row.names = FALSE)
  print(i)
}

states_final <- bitcoin_trend %>% rename(date = Week)
for (i in 1:49) {
  states_final <- merge(states_final, 
                        data.table::fread(paste("bitcoin_state_trends/", bitcoin_state_name[i, "region"], ".csv", sep = "")), 
                        by="date", all.x=T)
  print(i)
}

states_final <- states_final[, -c("date", "Bitcoin: (United States)")] * bitcoin_trend$`Bitcoin: (United States)`

states_final$date <- bitcoin_trend$Week
states_final <- as.data.frame(t(states_final))
colnames(states_final) <- as.character(states_final["date", ])

for (i in 1:260) {
  colnames(states_final)[i] <- as.character(bitcoin_trend[, "Week"][i])
  print(i)
}
setDT(states_final, keep.rownames = TRUE)[]
states_final <- rename(states_final, region = rn)
states_final <- states_final[-c(50), ]

states <- map_data("state")
map.df <- merge(states,states_final, by="region", all.x=T)
map.df <- map.df[order(map.df$order),]
for (i in 7:266) {
  map.df[, i]=as.numeric(levels(map.df[, i]))[map.df[, i]]
}
a <- ggplot(map.df, aes(x=long,y=lat,group= map.df$group))+
  geom_polygon(aes(fill=`2014-04-06`))+
  geom_path()+ 
  scale_fill_gradientn(colours=rev(heat.colors(10)), na.value="grey90", name = "Nhu title")+
  coord_map()
print(a)

states <- map_data("state")
dim(states)
a <- ggplot(data = states) + 
  geom_polygon(aes(x = long, y = lat, fill = map.df$`2013-12-15`, group = group), color = "white") + 
  coord_fixed(1.3) +
  scale_fill_gradient(trans = "log10", na.value="grey90")
  scale_fill_gradientn(colours=rev(heat.colors(10)),na.value="grey90", limits=c(0,10000))+
  coord_map()
print(a)


