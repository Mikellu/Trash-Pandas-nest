library(shiny)
library(R.utils)
library(data.table)
library(ggplot2)
library(maps)
library(mapproj)
library(lubridate)
library(dplyr)
library(gtrendsR)

bitcoin_state <- data.table::fread("googlestate/state-pop-bitcoin.csv")
bitcoin_state <- bitcoin_state[-c(which(grepl("Hawaii", bitcoin_state$Region)), which(grepl("Alaska", bitcoin_state$Region))), ]
bitcoin_state$Region <- tolower(bitcoin_state$Region)
bitcoin_state <- rename(bitcoin_state, region = Region)
bitcoin_state_copy <- bitcoin_state

bitcoin_trend <- data.table::fread("googlesearch/BTC_trend.csv") 
bitcoin_trend <- bitcoin_trend[-c(261), ]

state_abb <- data.table::fread("state-abbreviations.csv") 
state_abb <- state_abb[-c(2, 12), ]
state_abb$State <- tolower(state_abb$State)
state_abb <- rename(state_abb, region = State)
bitcoin_state <- merge(state_abb,bitcoin_state, by="region", all.x=T) #%>% 
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
states_final[98, 18] <- 0
states_final[107, 18] <- 0
states_final[[18]] <- as.numeric(states_final[[18]])
states_final[[45]][95] <- 0
states_final[[45]] <- as.numeric(states_final[[45]])
for (i in 3:51) {
  states_final[[i]] <- states_final[[i]] * bitcoin_trend$`Bitcoin: (United States)`
  print(i)
}

states_final <- as.data.frame(t(states_final))
states_final <- states_final[-c(1, 2), ]
for (i in 1:260) {
  colnames(states_final)[i] <- as.character(bitcoin_trend[, "Week"][i])
  print(i)
}
setDT(states_final, keep.rownames = TRUE)[]
states_final <- rename(states_final, region = rn)
states <- map_data("state")
map.df <- merge(states,states_final, by="region", all.x=T)
map.df <- map.df[order(map.df$order),]
for (i in 7:266) {
  map.df[, i]=as.numeric(levels(map.df[, i]))[map.df[, i]]
}
write.csv(map.df, file = paste("processed data/bitcoin.csv"), row.names = FALSE)

a <- ggplot(map.df, aes(x=long,y=lat,group= map.df$group))+
  geom_polygon(aes(fill=`2017-12-10`))+
  geom_path()+ 
  scale_fill_gradientn(colours=rev(heat.colors(10)),na.value="grey90", limits=c(0,10000))+
  coord_map()
print(a)
