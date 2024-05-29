#' @export
set_openaq_api_key <- function(api_key) {
  Sys.setenv(PURIFYR_OPENAQ_API_KEY = api_key)
}

get_openaq_api_key <- function() {
    key <- Sys.getenv("PURIFYR_OPENAQ_API_KEY")

    if (key == "") {
        cli::cli_alert_warning("No API key detected. Set using {.code set_openaq_api_key()}")

        # Don't really want to print the API key if it's blank but need to return something
        return(invisible(key))
    }

    key
}
