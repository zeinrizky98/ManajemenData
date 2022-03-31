library(dplyr)
library(rvest)
urlPT <- "https://www.goal.com/id/liga-primer/tabel/2kwbbcootiqqgmrzs6o5inle5"
data <- urlPT %>% read_html() %>% html_table()

# Tabel Klasemen
library(htmltools)
library(webshot)
library(formattable)
export_formattable <- function(f, file, width = "100%", height = NULL, 
                               background = "white", delay = 0.2)
{
  w <- as.htmlwidget(f, width = width, height = height)
  path <- html_print(w, background = background, viewer = NULL)
  url <- paste0("file:///", gsub("\\\\", "/", normalizePath(path)))
  webshot(url,
          file = file,
          selector = ".formattable_widget",
          delay = delay)
}

## Download the image to a temporary location
## save to a temp file
file <- tempfile(fileext = ".png")

p = formattable(data[[2]], list(
  "Pos" = color_tile("orange", "white"),
  "+/-" = formatter("span",
                    style = x ~ style(color = ifelse(x <= 0, "red", "green")))
))
export_formattable(
  p,
  file,
  width = "100%",
  height = "100%",
  background = "white",
  delay = 10
)

## 1st Hashtag
hashtag <- c("ManajemenData","ManajemenDataStatistika", "github","rvest","rtweet", "ElephantSQL", "SQL", "bot", "opensource", "ggplot2","PostgreSQL","RPostgreSQL")

samp_word <- sample(hashtag, 1)

## Status Message

status_details <- paste0(Sys.Date(),": Kelasemen Sementara Liga Inggris:", "\n","\n",
                         "1:",    data[[2]][1,2],"\n",
                         "M:",    data[[2]][1,3],"\n", 
                         "+/-:",  data[[2]][1,4],"\n",
                         "P:",    data[[2]][1,5])

# Publish to Twitter
library(rtweet)

## Create Twitter token
bola_token <- rtweet::create_token(
  app = "StockID",
  consumer_key =    Sys.getenv("TWITTER_CONSUMER_API_KEY"),
  consumer_secret = Sys.getenv("TWITTER_CONSUMER_API_SECRET"),
  access_token =    Sys.getenv("TWITTER_ACCESS_TOKEN"),
  access_secret =   Sys.getenv("TWITTER_ACCESS_TOKEN_SECRET")
)


## Post the image to Twitter
rtweet::post_tweet(
  status = status_details,
  media = file,
  token = bola_token)