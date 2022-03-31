library(RPostgreSQL)
library(rvest)
library(dplyr)

query <- '
CREATE TABLE IF NOT EXISTS LIGA (
  No integer,
  Karakter character(1),
  Angka integer,
  PRIMARY KEY (No)
)
'

drv <- dbDriver("PostgreSQL")

con <- dbConnect(drv,
                 dbname = "ddykovrz", 
                 host = "john.db.elephantsql.com",
                 port = 5432,
                 user = "ddykovrz",
                 password = "COG8VZQCXRuhlDEwQEDDmkuQ4iPXAoAF")

# Membuat Tabel untuk Pertama Kalinya
data <- dbGetQuery(con, query)

# Memanggil Tabel, untuk membuat Primary Key nya berurutan.

query2 <- '
SELECT * FROM "public"."LIGA"
'

data <- dbGetQuery(con, query2)
baris <- nrow(data)

urlprimer <- "https://www.goal.com/id/liga-primer/tabel/2kwbbcootiqqgmrzs6o5inle5"
primer <- urlprimer %>% read_html() %>% html_table()
datap <- as.data.frame(primer[[2]])

urlserieA <- "https://www.goal.com/id/serie-a/tabel/1r097lpxe0xn03ihb7wi98kao"
serieA <- urlserieA %>% read_html() %>% html_table()

urllaliga <- "https://www.goal.com/id/laliga/tabel/34pl8szyvrbwcmfkuocjm3r6t"
laliga <- urllaliga %>% read_html() %>% html_table()

urlbundesliga <- "https://www.goal.com/id/bundesliga/tabel/6by3h89i2eykc341oz7lv1ddd"
bundesliga <- urlbundesliga %>% read_html() %>% html_table()

# data <- data.frame(Minggu = (baris+1),
#                    LigaPrimer = c(primer[[2]][1,2]$Tim[1]),
#                    LigaSerieA = c(serieA[[2]][1,2]$Tim[1]),
#                    LigaLaliga = c(laliga[[2]][1,2]$Tim[1]),
#                    LigaBundesliga = c(bundesliga[[2]][1,2]$Tim[1]))

dbWriteTable(conn = con, name = 'primer2', value = datap, append = TRUE, row.names = FALSE, overwrite=FALSE)

on.exit(dbDisconnect(con)) 
