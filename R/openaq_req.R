library(httr)
library(stringr)

endpoint <- function(name, version=2){
    paste0("https://api.openaq.org/v", version, "/", name)
}

get_response <- function(endpoint_name, query_params){
  api_key <- get_openaq_api_key()

  query_string <- list(
  limit = "100",
  page = "1",
  offset = "0",
  sort = "asc",
  order_by = "id"
  )

  full_query_string <- append(
    query_string, 
    query_params
  )

  url <- endpoint(endpoint_name)

  response <- VERB(
    "GET", url,
    query = full_query_string,
    add_headers(`X-API-Key` = api_key),
    content_type("application/octet-stream"), 
    accept("application/json")
  )

  response_value <- content(response, "parsed")

  if (response$status == 200) {
    response_value
  }
  else if (response$status == 422) {
    message("response query malformed")
    response_value
  }
  else {
    message("unknown response code")
  }
}
