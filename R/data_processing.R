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

#' Collate paginated output for a given query
#' 
#' Collates output for a given query, where the query must be called multiple times 
#' due to pagination in the API. Assumes that there is a parser for the JSON response
#' from the API.
#' 
#' @param endpoint Endpoint of the API
#' @param query_params List of parameters to pass to the API, values must be strings
#' @param pagination_size The size of the response returned (the page size). Should be equal to the value in the query_params
#' @param response_parser A callable that parses the response into something that can be concatenated
#' 
#' @examples 
#' 
#' # Construct a query
#' endpoint <- "measurements"
#' query_params <- list(
#'      location = "Melbourne", 
#'      date_from="2024-05-24", 
#'      date_to="2024-05-25",
#'      limit="100"
#' )
#' 
#' # Paginate over results
#' collate_paginated_output(
#'  endpoint = endpoint,
#'  query_params = query_params,
#'  pagination_size = 100,
#'  response_parser = get_measures
#' )
#' 

collate_paginated_output <- function(
    endpoint,
    query_params,
    pagination_size,
    response_parser
) {

    output_list <- list()

    api_response <- run_query(endpoint, query_params)
    
    output_list[[1]] <- response_parser(api_response)
    i <- 1

    while (length(api_response[[2]]) == pagination_size){
        query_params[["page"]] <- as.character(i + 1)

        api_response <- run_query(
            endpoint_name = endpoint,
            query_params = query_params,
        )

        output_list[[i + 1]] <- response_parser(api_response)

        i <- i + 1
    }

    do.call(rbind, output_list)
}