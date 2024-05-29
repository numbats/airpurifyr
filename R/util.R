restify_vector <- function(input, name = NULL) {
    if (is.null(input)) {
        return(NULL)
    }
    if (is.null(name)) {
        name <- deparse(substitute(input))
    }
    input <- sapply(input, function(s) {
        gsub(" ", "%20", s)
    })
    string <- paste0("&", name, "=")

    paste0(input, collapse=string)
}