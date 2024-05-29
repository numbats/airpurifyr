library(httr)
library(tibble)
library(dplyr)
library(purrr)

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

response <- VERB("GET", url, query = queryString, content_type("application/octet-stream"), accept("application/json"))
value <- content(response, "parsed")

content(response, "parsed")[[2]] ## Go to response
content(response, "parsed")[[2]][1] ## Go to a location (should goes from 1 to 100)
