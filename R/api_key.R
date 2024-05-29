set_openaq_api_key <- function(api_key) {
  Sys.setenv(PURIFYR_OPENAQ_API_KEY = api_key)
}

get_openaq_api_key <- function() {
  tryCatch(
    Sys.getenv("PURIFYR_OPENAQ_API_KEY"),
    error = function(e) {
      warning(
        paste0(
          "Could not find environment variable PURIFYR_OPENAQ_API_KEY, ",
          "proceeding with no key; your rate limit will be reduced"
        )
      )

      NULL
    },
  )
}
