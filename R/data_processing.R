library(tibble)
library(dplyr)
library(purrr)

get_data <- function(value) {

  # To obtain the response
  locations_list <- value[[2]]

  # Convert locations_list to tibble
  # Extract data from locations_list and combine into air_df
  air_df <- locations_list |>
    map_dfr(~ tibble(
      location_id = .x$locationId,
      location = .x$location,
      parameter = .x$parameter,
      value = .x$value,
      date_utc = .x$date$utc,
      unit = .x$unit,
      lat = .x$coordinates$latitude,
      long = .x$coordinates$longitude,
      country = .x$country,
      city = .x$city
    ))

  return(air_df)

}

get_data(value = value)
