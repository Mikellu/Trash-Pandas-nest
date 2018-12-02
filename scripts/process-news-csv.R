library(dplyr)

process_csv_guardian <- function(csv_file_name) {
  file <- read.csv(paste("guardian-data/", csv_file_name, "-guardian.csv", sep=""))
  file <- file %>%
    mutate(Time = sub("T.*$", "", webPublicationDate)) %>%
    select(Time) %>%
    count(Time)
  write.csv(file, file = paste(csv_file_name, "-", "count.csv", sep=""))
}
process_csv_guardian("amazon")
process_csv_guardian("bitcoin")
process_csv_guardian("facebook")
process_csv_guardian("tesla")
process_csv_guardian("twitter")

process_csv_nytimes <- function(csv_file_name) {
  file <- read.csv(paste("nytimes-data/", "bitcoin", "-nytimes.csv", sep=""))
  final <- read.csv("bitcoin-count.csv")
  file <- file %>%
    mutate(Time = sub("T.*$", "", pub_date)) %>%
    select(Time) %>%
    count(Time)
  save <- left_join(final, file, by = "Time", suffix = c("1", "2")) 
  save$sum <- rowSums(save[,c("n1", "n2")], na.rm=TRUE)
  save <- save %>%
    select(Time, sum) %>%
    mutate(Time = as.Date(Time, "%Y-%m-%d"))
  write.csv(save, file = paste(csv_file_name, "-", "count.csv", sep=""))
}

process_csv_nytimes("amazon")
process_csv_nytimes("bitcoin")
process_csv_nytimes("facebook")
process_csv_nytimes("tesla")
process_csv_nytimes("twitter")