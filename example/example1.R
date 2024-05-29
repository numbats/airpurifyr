library(httr)

url <- "https://api.openaq.org/v2/measurements"

queryString <- list(
  country = "AU",
  location = "Footscray",
  city = "Melbourne",
  date_from = "2024-05-24",
  date_to = "2024-05-30",
  limit = "1000"
)

# response <- VERB("GET", url, query = queryString,
#                  content_type("application/octet-stream"),
#                  accept("application/json"))

# value <- content(response, "parsed")

qr <- run_query("measurements", queryString)

tb <- get_measures(qr)

unique(tb$parameter)
nrow(tb)

a <- get_measurements_for_location(country = "AU", city = "Melbourne",
                                   location = "Footscray",
                                   max_observations = 100,
                                   date_from = lubridate::ymd("2024-05-24"),
                                   parameter = c("pm10", "pm25"))
