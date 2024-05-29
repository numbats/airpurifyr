#' Get air quality measurements for a location
#' 
#' Gets the set of air quality measurements from the OpenAQ API. You can filter
#' by location, date, and type of station
#' 
#' @param country Two-character ISO country code
#' @param city String for the city of interest
#' @param location smaller-geographical identifier (i..e suburb)
#' @param date_from Date observations to start (will be converted to UTC)
#' @param date_to Date observations will end (will be converted to UTC)
#' @param is_mobile Include mobile station types
#' @param max_observations Number of observations to be returned per page.
#' Larger numbers mean less API calls but more single server load.
#' @param ... Extra API parameters. Note all must be name-value pairs, and all
#' values must be of type character.
#' 
#' @export
get_measurements_for_location <- function(
    country = NULL,
    city = NULL,
    location = NULL,
    date_from = Sys.Date() - 365,
    date_to = Sys.Date(),
    is_mobile = FALSE,
    max_observations = 1000,
    ...
) {

    assertthat::assert_that(inherits(date_from, "Date"))
    assertthat::assert_that(inherits(date_to, "Date"))
    assertthat::assert_that(inherits(country, "character") | is.null(country))
    assertthat::assert_that(inherits(city, "character") | is.null(city))
    assertthat::assert_that(inherits(location, "character") | is.null(location))
    assertthat::assert_that(inherits(is_mobile, "logical"))

    attr(date_from, "tzone") <- "UTC"
    attr(date_to, "tzone") <- "UTC"

    country <- restify_vector(country)
    city <- restify_vector(city)
    location <- restify_vector(location)
    
    additional_args <- list(...)
    parsed_args <- lapply(seq_along(additional_args), function(i) {
        restify_vector(input = additional_args[[i]], name = names(additional_args)[i])
    })
    names(parsed_args) <- names(additional_args)

    query_params <- list(
        country = country,
        city = city,
        location = location,
        date_from = as.character(date_from),
        date_to = as.character(date_to),
        is_mobile = tolower(as.character(is_mobile)),
        limit = as.character(max_observations)
    )

    query_params <- modifyList(query_params, parsed_args)
    
    collate_paginated_output(
        endpoint = "measurements",
        query_params = query_params,
        pagination_size = max_observations,
        response_parser = parse_measures
    )

}


#' @export
get_cities <- function(
    country = NULL,
    max_observations = 1000,
    ...
) {

    assertthat::assert_that(inherits(country, "character") | is.null(country))

    country <- restify_vector(country)

    additional_args <- list(...)
    parsed_args <- lapply(seq_along(additional_args), function(i) {
        restify_vector(input = additional_args[[i]], name = names(additional_args)[i])
    })
    names(parsed_args) <- names(additional_args)

    query_params <- list(
        country = country,
        limit = as.character(max_observations)
    )

    query_params <- modifyList(query_params, parsed_args)
    
    collate_paginated_output(
        endpoint = "cities",
        query_params = query_params,
        pagination_size = max_observations,
        response_parser = parse_cities
    )
}