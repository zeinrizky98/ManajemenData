library(dplyr)
library(rvest)
library(htmltools)
library(webshot)
library(formattable)
library(RPostgreSQL)
webshot::install_phantomjs()

drv <- dbDriver("PostgreSQL")

con <- dbConnect(drv,
                 dbname = "ddykovrz", 
                 host = "john.db.elephantsql.com",
                 port = 5432,
                 user = "ddykovrz",
                 password = "COG8VZQCXRuhlDEwQEDDmkuQ4iPXAoAF")

query2 <- '
SELECT * FROM "public"."primer2" limit 1
'

data <- dbGetQuery(con, query2)

# # Tabel Klasemen
# export_formattable <- function(f, file, width = "100%", height = NULL, 
#                                background = "white", delay = 0.2)
# {
#   w <- as.htmlwidget(f, width = width, height = height)
#   path <- html_print(w, background = background, viewer = NULL)
#   url <- paste0("file:///", gsub("\\\\", "/", normalizePath(path)))
#   webshot(url,
#           file = file,
#           selector = ".formattable_widget",
#           delay = delay)
# }
# 
# ## Download the image to a temporary location
# ## save to a temp file
# file <- tempfile(fileext = ".png")
# 
# p = formattable(data[[2]])
# 
# export_formattable(
#   p,
#   file,
#   width = "100%",
#   height = "100%",
#   background = "white",
#   delay = 10
# )

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
  app = "LigaEropaBOT",
  consumer_key =    Sys.getenv("KkOXL26usvkE5Q9XYxZsqISMv"),
  consumer_secret = Sys.getenv("beaa0xv5rWIuN0Tll6pgase4nl6rCXk9k7XmOZI9eZMVHhLQNT"),
  access_token =    Sys.getenv("1489083674561683461-4C2bPcSJnArO5W0vFIJsbYWIqaUeAk"),
  access_secret =   Sys.getenv("LKmpehtvjZ8YwsXam4X2waXW3YB5T56EyGc64SqwcxFz2")
)


## Post the image to Twitter
rtweet::post_tweet(
  status = status_details,
  token = bola_token)
