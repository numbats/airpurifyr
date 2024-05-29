library(tibble)
library(purrr)
library(lubridate)

get_measures <- function(req_cont) {

  # To obtain the response
  locations_list <- req_cont[[2]]

  # Extract data from locations_list and combine into air_df
  air_df <- locations_list |>
    map_dfr(~ tibble(
      location_id = .x$locationId,
      location = .x$location,
      parameter = .x$parameter,
      value = .x$value,
      date_utc = ymd_hms(.x$date$utc),
      unit = .x$unit,
      lat = .x$coordinates$latitude,
      long = .x$coordinates$longitude,
      country = .x$country,
      city = .x$city
    ))

  return(air_df)

}

