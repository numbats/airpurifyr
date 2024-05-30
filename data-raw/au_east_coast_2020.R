# Without a way to search for locations, the easiest way to find particular stations
# is with a lat/long filter on all of Australia.
# For the sake of computation time, restrict the number of days we look at.
all_aus_locations <- get_measurements_for_location(
    country = "AU",
    max_observations = 1000,
    date_from = lubridate::ymd("2020-01-01"),
    date_to = lubridate::ymd("2020-01-14"),
    parameter = "pm25"
)

locations_of_interest <- all_aus_locations |>
    # East coast of Australia (roughly)
    dplyr::filter(long > 141, lat < -31) |>
    dplyr::distinct(location) |>
    dplyr::pull()

au_east_coast_2020 <- get_measurements_for_location(
    country = "AU",
    location = locations_of_interest,
    max_observations = 10000,
    date_from = lubridate::ymd("2019-12-01"),
    date_to = lubridate::ymd("2020-02-01"),
    parameter = "pm25"
)

usethis::use_data(au_east_coast_2020, overwrite = TRUE)
