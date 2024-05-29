#' Set OpenAQ API Key
#' 
#' Sets your OpenAQ API key for use by the package `airpurifyr`
#' Register your API key at \url{https://explore.openaq.org/register}, and access your
#' account and get your API key from the dashboard \url{https://explore.openaq.org/account}
#' @param api_key API key to set
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
