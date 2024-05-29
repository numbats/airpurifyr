endpoint <- function(name, version=2){
  paste0("https://api.openaq.org/v", version, "/", name)
}

parse_malformed_request_response <- function(response_value) {
  N = nchar(response_value)
  normalised_responses <- yaml::yaml.load(
    gsub("\\(", "[",
      gsub("\\)", "]",
        response_value
      )
    )
  )
  collated_errors <- list()
  for (error_resp in normalised_responses) {
    collated_errors <- append(
      collated_errors,
      paste0(
        "Error of type ",
        error_resp$type,
        " at ",
        paste0(error_resp$loc, collapse=" "),
        ". ",
        error_resp$msg,
        ". Input provided: ",
        error_resp$input
      )
    )
  }

  paste0(collated_errors, collapse=" ")
}

#' @importFrom httr VERB add_headers content content_type accept
run_query <- function(endpoint_name, query_params = list()){
  api_key <- get_openaq_api_key()

  query_string <- list(
    page = "1",
    offset = "0"
  )

  full_query_string <- modifyList(
    query_string,
    query_params
  ) |> lapply(I) # I wraps arguments so they do not get html escaped

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
  } else if (response$status == 422) {
    cli::cli_alert(
      paste0(
        "Response query malformed: ",
        parse_malformed_request_response(response_value)
      )
    )
  } else {
    cli::cli_alert(paste0("Unknown response code: ", as.character(response$status)))
  }
}
