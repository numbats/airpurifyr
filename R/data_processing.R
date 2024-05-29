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
content(response, "parsed")[[2]][1] ## Go to a location (should goes from 1 to 100). This should be pass as a paramater 100

data_list <- content(response, "parsed")[[2]][1][[1]] ## Go inside the list

tibble(location_id = data_list$id,
       city = data_list$city,
       name = data_list$name,
       country = data_list$country,
       lat = data_list$coordinates$latitude,
       long = data_list$coordinates$longitude
       )


param_list <- data_list$parameters
tibble(param_id = param_list[[1]]$id,
       name = param_list[[1]]$parameter,
       unit = param_list[[1]]$unit,
       count = param_list[[1]]$count,
       average = param_list[[1]]$average,
       last_updated = param_list[[1]]$lastUpdated
)
