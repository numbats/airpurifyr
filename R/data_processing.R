#' Get Air Quality Measures
#'
#' This function extracts air quality measures from a parsed API response.
#'
#' @param req_cont A list containing the parsed API response. The location data
#'                 should be stored in the second element of this list.
#'
#' @return A tibble containing air quality measures with columns for location ID,
#'         location name, parameter name, measured value, date and time of measurement
#'         (in UTC), unit of measurement, latitude, longitude, country, and city.
#'
#' @importFrom tibble tibble
#' @importFrom purrr map_dfr
#' @importFrom lubridate ymd_hms
#'
#' @examples
#' # Sample usage:
#' library(tibble)
#' library(purrr)
#' library(lubridate)
#'
#' # Sample parsed API response
#' req_cont <- content(response, "parsed")
#'
#' # Get air quality measures
#' measures <- get_measures(req_cont)
#'

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

