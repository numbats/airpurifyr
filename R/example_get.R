
library(httr)

url <- "https://api.openaq.org/v2/locations"

queryString <- list(
  limit = "100",
  page = "1",
  offset = "0",
  sort = "desc",
  radius = "1000",
  order_by = "lastUpdated",
  dump_raw = "false"
)

response <- VERB(
    "GET", url, 
    query = queryString, 
    add_headers(`X-API-Key` = "d60d5cb45817fa697be59eb267b6c6863b46848a9b8e9514a39f61cc5f0b252e"),
    content_type("application/octet-stream"), 
    accept("application/json"))

value <- content(response, "parsed")