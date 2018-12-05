library(shiny)
library(R.utils)
library(data.table)
library(ggplot2)
library(maps)
library(mapproj)
library(lubridate)
library(dplyr)
library(gtrendsR)

amazon_state <- data.table::fread("googlestate/state-pop-amazon.csv")
amazon_state <- amazon_state[-c(which(grepl("Hawaii", amazon_state$Region)), which(grepl("Alaska", amazon_state$Region))), ]
amazon_state$Region <- tolower(amazon_state$Region)
amazon_state <- rename(amazon_state, region = Region)
amazon_state_copy <- amazon_state

amazon_trend <- data.table::fread("googlesearch/AMAZ_trend.csv") 
amazon_trend <- amazon_trend[-c(261), ]

state_abb <- data.table::fread("state-abbreviations.csv") 
state_abb <- state_abb[-c(2, 12), ]
state_abb$State <- tolower(state_abb$State)
state_abb <- rename(state_abb, region = State)
amazon_state <- merge(state_abb,amazon_state, by="region", all.x=T) #%>% 
amazon_state_name <- amazon_state

for (i in 1:49) {
  data <- gtrends("amazon", geo = paste("US", amazon_state_name[i, "Abbreviation"], sep = "-"), 
                  gprop = "web", time = "2013-12-01 2018-11-18")$interest_over_time
  data <- mutate(data, date = paste(as.Date(date, format = "%m-%d-%Y"))) %>% 
    select("date", "hits") 
  names(data)[2] <- paste(amazon_state_name[i, "region"])
  write.csv(data, file = paste("amazon_state_trends/", amazon_state_name[i, "region"], ".csv", sep = ""), row.names = FALSE)
  print(i)
}

states_final <- amazon_trend %>% rename(date = Week)
for (i in 1:49) {
  states_final <- merge(states_final, 
                        data.table::fread(paste("amazon_state_trends/", amazon_state_name[i, "region"], ".csv", sep = "")), 
                        by="date", all.x=T)
  print(i)
}
states_final <- states_final[, -c(1, 2)]
states_final <- as.data.frame(t(states_final))
for (i in 1:260) {
  states_final[[i]] <- data.matrix(states_final[[i]]) * amazon_state$`Amazon: (12/1/13 - 12/1/18)`
  print(i)
}
for (i in 1:49) {
  states_final[i, ] <- data.matrix(states_final[i, ]) * amazon_trend$`Amazon.com: (United States)` / 10000
  print(i)
}
for (i in 1:260) {
  colnames(states_final)[i] <- as.character(amazon_trend[, "Week"][i])
  print(i)
}
setDT(states_final, keep.rownames = TRUE)[]
states_final <- rename(states_final, region = rn)
states <- map_data("state")
map.df <- merge(states,states_final, by="region", all.x=T)
map.df <- map.df[order(map.df$order),]
write.csv(map.df, file = paste("processed data/amazon.csv"), row.names = FALSE)
a <- ggplot(map.df, aes(x=long,y=lat,group= map.df$group))+
  geom_polygon(aes(fill=`2017-12-10`))+
  geom_path()+ 
  scale_fill_gradientn(colours=rev(heat.colors(10)),na.value="grey90", limits=c(0,100))+
  coord_map()
print(a)


