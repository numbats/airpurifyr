#' Air Quality Data for Australian East Coast, 2019-2020
#' 
#' Air quality data from the OpenAQ API from 1 December 2020 to 1 February 2021,
#' which was a period of extreme bushfires in Australia
#' 
#' @format ## `au_east_coast_2020`
#' A data frame with 43,031 rows and 9 columns:
#' \describe{
#'  \item{location_id}{Numeric ID of the location}
#'  \item{location}{Character description of the location}
#'  \item{parameter}{Parameter measured (only pm2.5 included)}
#'  \item{value}{Value of the parameter}
#'  \item{date_utc}{Datetime of the observation (UTC timezeon)}
#'  \item{unit}{Units of the measurement}
#'  \item{lat, long}{Latitude and longitude of the station}
#'  \item{country}{Two-letter ISO country code of the station}
#' }
"au_east_coast_2020"