#' @export
get_measurements_for_location <- function(
    country = "",
    city = "",
    location = "",
    date_from = Sys.Date() - 365,
    date_to = Sys.Date(),
    is_mobile = FALSE,
    max_observations = 1000
) {

    assertthat::assert_that(inherits(date_from, "Date"))
    assertthat::assert_that(inherits(date_to, "Date"))
    assertthat::assert_that(inherits(country, "character"))
    assertthat::assert_that(inherits(city, "character"))
    assertthat::assert_that(inherits(location, "character"))
    assertthat::assert_that(inherits(is_mobile, "logical"))

    attr(date_from, "tzone") <- "UTC"
    attr(date_to, "tzone") <- "UTC"
    
    query_params <- list(
        country = country,
        city = city,
        location = location,
        date_from = as.character(date_from),
        date_to = as.character(date_to),
        is_mobile = tolower(as.character(is_mobile)),
        limit = as.character(max_observations)
    )

    api_response <- run_query(
        endpoint_name = "measurements",
        query_params = query_params
    )

    measures_list <- list()

    measures_list[[1]] <- get_measures(api_response)
    i <- 1
    
    while (length(api_response[[2]]) == max_observations) {
        query_params[["page"]] <- as.character(i + 1)
        
        api_response <- run_query(
            endpoint_name = "measurements",
            query_params = query_params
        )

        measures_list[[i + 1]] <- get_measures(api_response)

        i <- i+1
    }

    do.call(rbind, measures_list)

}