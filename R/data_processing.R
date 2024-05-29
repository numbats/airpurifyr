library(httr)
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

# content(response, "parsed")[[2]] ## Go to response
# content(response, "parsed")[[2]][1] ## Go to a location (should goes from 1 to 100). This should be pass as a paramater 100
#
# data_list <- content(response, "parsed")[[2]][1][[1]] ## Go inside the list
#
# tibble(location_id = data_list$id,
#        city = data_list$city,
#        name = data_list$name,
#        country = data_list$country,
#        lat = data_list$coordinates$latitude,
#        long = data_list$coordinates$longitude
#        )

air_df <- tibble(
  location_id = numeric(0),
  city = character(0),
  name = character(0),
  country = character(0),
  lat = numeric(0),
  long = numeric(0),
  param_name = character(0),
  unit = character(0),
  count = numeric(0),
  average = numeric(0),
  last_updated = character(0)
)

locations_list <- content(response, "parsed")[[2]]

# Create an empty tibble with column names
location_tibble <- tibble(
  location_id = numeric(0),
  city = character(0),
  name = character(0),
  country = character(0),
  lat = numeric(0),
  long = numeric(0)
)

for (loc in seq_along(locations_list)) {

  ## Get an specific location
  spec_loc_list <- locations_list[loc][[1]]

  loc_n <- tibble(location_id = spec_loc_list$id,
                  city = spec_loc_list$city,
                  name = spec_loc_list$name,
                  country = spec_loc_list$country,
                  lat = spec_loc_list$coordinates$latitude,
                  long = spec_loc_list$coordinates$longitude
  )

  location_tibble <- bind_rows(location_tibble, loc_n)

  # Create an empty tibble with column names
  param_tibble <- tibble(
    location_id = numeric(0),
    param_name = character(0),
    unit = character(0),
    count = numeric(0),
    average = numeric(0),
    last_updated = character(0)
  )

  for (param in seq_along(param_list)) {

    param_n <- tibble(location_id = data_list$id,
                      param_id = param_list[[param]]$id,
                      param_name = param_list[[param]]$parameter,
                      unit = param_list[[param]]$unit,
                      count = param_list[[param]]$count,
                      average = param_list[[param]]$average,
                      last_updated = param_list[[param]]$lastUpdated
    )

    param_tibble <- bind_rows(param_tibble, param_n)

  }

  air_df_n <- inner_join(location_tibble, param_tibble, by = "location_id")

  air_df <- bind_rows(air_df, air_df_n)

}


# param_list <- data_list$parameters
# tibble(param_id = param_list[[1]]$id,
#        name = param_list[[1]]$parameter,
#        unit = param_list[[1]]$unit,
#        count = param_list[[1]]$count,
#        average = param_list[[1]]$average,
#        last_updated = param_list[[1]]$lastUpdated
# )

