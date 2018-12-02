library(dplyr)
library(httr)
library(jsonlite)
library(tidyr)
# The script is used for generating csv data files for news! There is no need of
# execution except obtaining NEW data
source("key.R")

guardian_news_search <- function(time, query) {
  g_pgnum <- 1
  guardian <- data.frame() 
  g_result <- "initial"
  while (!is.null(g_result)) {
    news_base <- "https://content.guardianapis.com/search"
    news_query <- list("api-key"=guardian_news_key, "page-size"=50, page=g_pgnum,"order-by"="newest", format="json", q=query, "from-date"=time, "to-date"="2016-01-14")
    news_result <- httr::GET(news_base, query=news_query)
    news_data <- news_result %>% httr::content("text") %>% jsonlite::fromJSON()
    g_result <- news_data$response$results
    guardian <- bind_rows(guardian, g_result)
    g_pgnum <- g_pgnum + 1
  }
  write.csv(guardian, file = paste(query, "-", "guardian.csv", sep=""))
}
# guardian_news_search("2013-12-02", "bitcoin")
# guardian_news_search("2013-12-02", "amazon")
# guardian_news_search("2013-12-02", "tesla")
# guardian_news_search("2013-12-02", "facebook")
# guardian_news_search("2013-12-02", "twitter")

nytimes_news_search <- function(time, query) {
  nytimes <- data.frame() 
  n_result <- "initial"
  for (n_pgnum in c(0:200)) {
    news_base <- "https://api.nytimes.com/svc/search/v2/articlesearch.json"
    news_query <- list("api-key"=nytimes_news_key, q=query, "end_date"="20140214", "begin_date"=time, sort="newest", fl="pub_date", page=n_pgnum)
    news_result <- httr::GET(news_base, query=news_query)
    news_data <- news_result %>% httr::content("text") %>% jsonlite::fromJSON()
    n_result <- news_data$response$docs
    nytimes <- bind_rows(nytimes, n_result)
    n_pgnum <- n_pgnum + 1
  }
  write.csv(nytimes, file = paste(query, "-", "2-nytimes.csv", sep=""))
}

# nytimes_news_search("20131202", "bitcoin")
# nytimes_news_search("20131202", "amazon")
# nytimes_news_search("20131202", "tesla")
# nytimes_news_search("20131202", "facebook")
# nytimes_news_search("20131202", "twitter")
