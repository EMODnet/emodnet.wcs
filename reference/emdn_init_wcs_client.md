# Connect to a data source (service)

Initialise an EMODnet WCS client

## Usage

``` r
emdn_init_wcs_client(
  service,
  service_version = c("2.0.1", "2.1.0", "2.0.0", "1.1.1", "1.1.0"),
  logger = c("NONE", "INFO", "DEBUG")
)
```

## Arguments

- service:

  the EMODnet OGC WCS service name. For available services, see
  [`emdn_wcs()`](https://emodnet.github.io/emodnet.wcs/reference/emdn_wcs.md).

- service_version:

  the WCS service version. Defaults to "2.0.1".

- logger:

  character string. Level of logger: 'NONE' for no logger, 'INFO' to get
  ows4R logs, 'DEBUG' for all internal logs (such as as Curl details)

## Value

An
[`ows4R::WCSClient`](https://eblondel.github.io/ows4R/reference/WCSClient.html)
R6 object with methods for interfacing an OGC Web Coverage Service.

## See also

`WCSClient` in package `ows4R`.

## Examples

``` r
(wcs <- emdn_init_wcs_client(service = "bathymetry"))
#> ✔ WCS client created succesfully
#> ℹ Service: <https://ows.emodnet-bathymetry.eu/wcs>
#> ℹ Service: "2.0.1"
#> <WCSClient>
#> ....|-- url: https://ows.emodnet-bathymetry.eu/wcs
#> ....|-- version: 2.0.1
#> ....|-- capabilities <WCSCapabilities>
```
