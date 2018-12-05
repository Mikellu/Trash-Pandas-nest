library(shiny)
library(R.utils)
library(data.table)
library(ggplot2)
library(maps)
library(mapproj)
library(lubridate)
library(dplyr)
library(gtrendsR)

tesla_state <- data.table::fread("googlestate/state-pop-tesla.csv")
tesla_state <- tesla_state[-c(which(grepl("Hawaii", tesla_state$Region)), which(grepl("Alaska", tesla_state$Region))), ]
tesla_state$Region <- tolower(tesla_state$Region)
tesla_state <- rename(tesla_state, region = Region)
tesla_state_copy <- tesla_state

tesla_trend <- data.table::fread("googlesearch/TSLA_trend.csv") 
tesla_trend <- tesla_trend[-c(261), ]

state_abb <- data.table::fread("state-abbreviations.csv") 
state_abb <- state_abb[-c(2, 12), ]
state_abb$State <- tolower(state_abb$State)
state_abb <- rename(state_abb, region = State)
tesla_state <- merge(state_abb,tesla_state, by="region", all.x=T) #%>% 
tesla_state_name <- tesla_state

for (i in 1:49) {
  data <- gtrends("tesla", geo = paste("US", tesla_state_name[i, "Abbreviation"], sep = "-"), 
                  gprop = "web", time = "2013-12-01 2018-11-18")$interest_over_time
  data <- mutate(data, date = paste(as.Date(date, format = "%m-%d-%Y"))) %>% 
    select("date", "hits") 
  names(data)[2] <- paste(tesla_state_name[i, "region"])
  write.csv(data, file = paste("tesla_state_trends/", tesla_state_name[i, "region"], ".csv", sep = ""), row.names = FALSE)
  print(i)
}

states_final <- tesla_trend %>% rename(date = Week)
for (i in 1:49) {
  states_final <- merge(states_final, 
                        data.table::fread(paste("tesla_state_trends/", tesla_state_name[i, "region"], ".csv", sep = "")), 
                        by="date", all.x=T)
  print(i)
}
states_final <- states_final[, -c(1, 2)]
states_final <- as.data.frame(t(states_final))
for (i in 1:260) {
  states_final[[i]] <- data.matrix(states_final[[i]]) * tesla_state$`Tesla: (12/1/13 - 12/1/18)`
  print(i)
}
for (i in 1:49) {
  states_final[i, ] <- data.matrix(states_final[i, ]) * tesla_trend$`Tesla, Inc.: (United States)` / 10000
  print(i)
}
for (i in 1:260) {
  colnames(states_final)[i] <- as.character(tesla_trend[, "Week"][i])
  print(i)
}
setDT(states_final, keep.rownames = TRUE)[]
states_final <- rename(states_final, region = rn)
states <- map_data("state")
map.df <- merge(states,states_final, by="region", all.x=T)
map.df <- map.df[order(map.df$order),]
write.csv(map.df, file = paste("processed data/tesla.csv"), row.names = FALSE)
a <- ggplot(map.df, aes(x=long,y=lat,group= map.df$group))+
  geom_polygon(aes(fill=`2013-12-01`))+
  geom_path()+ 
  scale_fill_gradientn(colours=rev(heat.colors(10)),na.value="grey90", limits=c(0,100))+
  coord_map()
print(a)
