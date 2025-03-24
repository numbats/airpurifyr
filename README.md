
<!-- README.md is generated from README.Rmd. Please edit that file -->
# NOTICE

As of 1 February 2025, OpenAQ is no longer operating the v2 endpoint that this package relies on. We have been advised that OpenAQ are working on their own R package, and as such this package is now officially discontinued, and no longer operational.


# airpurifyr <img src="man/figures/logo.png" align="right" height="139" alt="" />

`airpurifyr` makes it easy to grab air quality data from
[OpenAQ](https://www.openaq.org).

# Previous instructions - no longer applicable, maintained here for archival purposes

## Installation

You can install the development version of `airpurifyr` from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("numbats/airpurifyr")
```

## Usage

### Setting you API key

You will need to register an API key, which you can do
[here](https://explore.openaq.org/register). Keep note of the API key,
and set it using `set_openaq_api_key()`.

If you are using the package regularly, you can set this API key using a
`.Renviron` or inside your `.Rprofile`, but don’t share it publicly!

### Getting data

To get data, use the function `get_measurements_for_location()`. You’ll
probably want to provide at least a country, and maybe a city. For
example,

``` r
melbourne_data <- get_measurements_for_location(country = "AU", city = "Melbourne")
```

You may also want to filter by *locations*, which are almost like
suburbs but are dependent on the location of sensors. More info on the
API fields can be found on the [OpenAQ
Documentation](https://api.openaq.org/redoc#tag/v2).
