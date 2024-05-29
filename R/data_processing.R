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

get_data <- function(value) {

  # To obtain the response
  locations_list <- value[[2]]

  # Convert locations_list to tibble
  location_tibble <- map_dfr(locations_list, ~ tibble(
    location_id = .x$id,
    city = .x$city,
    name = .x$name,
    country = .x$country,
    lat = .x$coordinates$latitude,
    long = .x$coordinates$longitude
  ))

  # Convert parameters to tibble and unnest
  param_tibble <- locations_list |>
    map(~ tibble(
      location_id = .x$id,
      param_name = .x$parameters |> map_chr("parameter"),
      unit = .x$parameters |> map_chr("unit"),
      count = .x$parameters |> map_dbl("count"),
      average = .x$parameters |> map_dbl("average"),
      last_updated = .x$parameters |> map_chr("lastUpdated")
    )) |>
    bind_rows()

  # Join location and parameter data
  air_df <- inner_join(location_tibble, param_tibble, by = "location_id")

  return(air_df)

}
