# Which data sources (services) are available?

Available EMODnet Web Coverage Services

## Usage

``` r
emdn_wcs()
```

## Value

Tibble of available EMODnet Web Coverage Services

## Examples

``` r
emdn_wcs()
#> # A tibble: 4 × 2
#>   service_name     service_url                                                  
#>   <chr>            <chr>                                                        
#> 1 bathymetry       https://ows.emodnet-bathymetry.eu/wcs                        
#> 2 biology          https://geo.vliz.be/geoserver/Emodnetbio/wcs                 
#> 3 human_activities https://ows.emodnet-humanactivities.eu/wcs                   
#> 4 seabed_habitats  https://ows.emodnet-seabedhabitats.eu/geoserver/emodnet_open…
```
