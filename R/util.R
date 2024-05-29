restify_vector <- function(input, name = NULL) {
    if (is.null(name)) {
        name <- deparse(substitute(input))
    }
    string <- paste0("&", name, "=")

    paste0(input, collapse=string)
}