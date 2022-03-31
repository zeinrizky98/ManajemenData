# Data
library(dplyr)
library(rvest)
urlPT <- "https://https://www.goal.com/id/bundesliga/tabel/6by3h89i2eykc341oz7lv1ddd"
data4 <- urlPT %>% read_html() %>% html_table()

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

p = formattable(data2[[2]], list(
  "Pos" = color_tile("purple", "white"),
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

# Hashtag
hashtag <- c("Laliga","LigaInggris","SerieA","LigaSpanyol","PremierLeague","Bundesliga","Sepakbola","Football",
             "github","rvest","rtweet", "bot", "opensource", "ggplot2", "dplyr", "tidyr")

samp_word <- sample(hashtag, 1)

## Status Message

status_details <- paste0(Sys.Date(),": Top 3 Kelasemen Sementara Liga Jerman Musim 2021-2022 :", "\n",
                         "1.",    data4[[2]][1,2],"\n", 
                         "2.",    data4[[2]][2,2],"\n",
                         "3.",    data4[[2]][3,2],"\n",
                         
                         "#",samp_word, "#infobola", "\n",
                         "Selengkapnya sebagai berikut:",
                         "\n")

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
