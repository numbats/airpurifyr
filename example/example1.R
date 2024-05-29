library(httr)

url <- "https://api.openaq.org/v2/measurements"

queryString <- list(
  date_from = "2024-01-01",
  date_to = "2024-05-29",
  limit = "100",
  page = "1",
  offset = "0",
  sort = "desc",
  radius = "1000",
  country = "AU",
  city = "Melbourne",
  location = "Footscray",
  order_by = "datetime",
  is_mobile = "false"
)

response <- VERB("GET", url, query = queryString,
                 content_type("application/octet-stream"),
                 accept("application/json"))

value <- content(response, "parsed")
