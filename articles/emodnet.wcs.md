# Get Started with emodnet.wcs

## WCS Basics

The [Web Coverage Service (WCS)](https://www.ogc.org/standards/wcs)is a
standard issued by the Open Geospatial Consortium (OGC). It is designed
to simplify remote access to coverages, commonly known as raster maps in
GIS. WCS functions over the HTTP protocol, setting out how to obtain
data and metadata using the requests available in the protocol. In
practice it allows metadata and raster maps to be obtained from a web
browser or from any other programme that uses the protocol.

An important distinction must be made between WCS and Web Map Service
(WMS). They are similar, and can return similar formats, but a WCS is
able to return more information, including valuable metadata and more
formats. It additionally allows more precise queries, potentially
against multi-dimensional backend formats.

The WCS standard is composed by three core requests, each with a
particular purpose:

1.  `GetCapabilities`: This request provides information on a particular
    service.
2.  `DescribeCoverage`: This request provides more detailed information
    about a particular coverage.
3.  `GetCoverage`: This request actually obtains coverage data.

WCS requests are handled in emodnet.wcs through the [ows4R
package](https://eblondel.github.io/ows4R/). ows4R uses [R6
classes](https://r6.r-lib.org/articles/Introduction.html) and implements
an encapsulated object-oriented programming paradigm which may be
unfamiliar to some R users. emodnet.wcs wraps ows4R and aims to provide
more familiar workflows and return more familiar, usable and easy to
review outputs. It also provides checks and validations to ensure smooth
and easy interaction with EMODnet WCS services. You can however use
ows4R with any of the EMODnet WCS endpoints if you prefer.

## EMODnet WCS Services

The EMODnet portals provide a number of Web Coverage Services (WCS) to
support requests for coverage data (rasters) or gridded data products.

### Available services

To view the available services and their endpoints, you can use
[`emdn_wcs()`](https://emodnet.github.io/emodnet.wcs/reference/emdn_wcs.md)

``` r
library(emodnet.wcs)
#> Loading ISO 19139 XML schemas...
#> Loading ISO 19115-3 XML schemas...
#> Loading ISO 19139 codelists...
```

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

The `service_name` column contains the service names that can be used to
establish connections and make requests to EMODnet WCS services.

## Connecting to EMODnet WCS Services

Before we can make requests to any of the services, we first need to
create a new WCS Client. We specify the service we want to connect to
using the `service` argument.

``` r
wcs <- emdn_init_wcs_client("biology")
#> ✔ WCS client created succesfully
#> ℹ Service: <https://geo.vliz.be/geoserver/Emodnetbio/wcs>
#> ℹ Service: "2.0.1"
```

There are options for logging additional messages arising from ows4R and
the underlying `libculrl`/`curl` library through the `logger` argument.
These can be useful in troubleshooting issues.

There are 3 levels of potential logging:

- `'NONE'` (the default) for no logger.
- `'INFO'` includes ows4R logs.
- `'DEBUG'` for all internal logs (such as as curl details)

The following example sets the logger to `"DEBUG"`.

``` r
debug_wcs <- emdn_init_wcs_client("biology", logger = "DEBUG")
#> [ows4R][INFO] OWSGetCapabilities - Fetching https://geo.vliz.be/geoserver/Emodnetbio/wcs?service=WCS&version=2.0.1&request=GetCapabilities
#> ✔ WCS client created succesfully
#> ℹ Service: <https://geo.vliz.be/geoserver/Emodnetbio/wcs>
#> ℹ Service: "2.0.1"
```

The
[`emdn_init_wcs_client()`](https://emodnet.github.io/emodnet.wcs/reference/emdn_init_wcs_client.md)
functions returns an R6 object of class
[`<WCSClient>`](https://eblondel.github.io/ows4R/reference/WCSClient.html).

``` r
debug_wcs
#> <WCSClient>
#> ....|-- url: https://geo.vliz.be/geoserver/Emodnetbio/wcs
#> ....|-- version: 2.0.1
#> ....|-- capabilities <WCSCapabilities>
```

You can use any of the methods provided within the class should you wish
(see [ows4R
documentation](https://eblondel.github.io/ows4R/articles/wcs.html) for
details).

``` r
debug_wcs$getUrl()
#> [1] "https://geo.vliz.be/geoserver/Emodnetbio/wcs"

debug_wcs$loggerType
#> [1] "DEBUG"
```

However emodnet.wcs provides a host of functions for
extracting/compiling useful metadata in a variety of forms as well
downloading raster data from emodnet.wcs service which you will likely
find easier to work with.

Here are some examples of functionality provided by emodnet.wcs. For
more details see the other vignettes.

## Getting Metadata

Get service level and a subset of coverage level metadata, compiled for
easy review.

``` r
emdn_get_wcs_info(wcs = wcs)
#> $data_source
#> [1] "emodnet_wcs"
#> 
#> $service_name
#> [1] "biology"
#> 
#> $service_url
#> [1] "https://geo.vliz.be/geoserver/Emodnetbio/wcs"
#> 
#> $service_title
#> [1] "EMODnet Biology"
#> 
#> $service_abstract
#> [1] "The EMODnet Biology products include a set of gridded map layers showing the average abundance of marine species for different time windows (seasonal, annual) using geospatial modelling. The spatial modelling tool used to calculate the gridded abundance maps is based on DIVA. DIVA (Data-Interpolating Variational Analysis) is a tool to create gridded data sets from discrete point measurements of the ocean. For the representation of time dynamics, it was decided to produce gridded maps for sliding time windows, e.g. combining one or more years  in one gridded map, so that relatively smooth animated GIF presentations can be produced that show the essential change over time. EMODnet Biology’s data products include the Operational Ocean Products and Services (OOPS), harvested by ICES."
#> 
#> $service_access_constraits
#> [1] "NONE"
#> 
#> $service_fees
#> [1] "NONE"
#> 
#> $service_type
#> [1] "urn:ogc:service:wcs"
#> 
#> $coverage_details
#> # A tibble: 10 × 9
#>    coverage_id           dim_n dim_names extent crs   wgs84_bbox temporal_extent
#>    <chr>                 <int> <chr>     <chr>  <chr> <chr>      <chr>          
#>  1 Emodnetbio__ratio_la…     3 lat(deg)… -75.0… EPSG… -75.05, 3… 1958-02-16T01:…
#>  2 Emodnetbio__aca_spp_…     3 lat(deg)… -75.0… EPSG… -75.05, 3… 1958-02-16T01:…
#>  3 Emodnetbio__cal_fin_…     3 lat(deg)… -75.0… EPSG… -75.05, 3… 1958-02-16T01:…
#>  4 Emodnetbio__cal_hel_…     3 lat(deg)… -75.0… EPSG… -75.05, 3… 1958-02-16T01:…
#>  5 Emodnetbio__met_luc_…     3 lat(deg)… -75.0… EPSG… -75.05, 3… 1958-02-16T01:…
#>  6 Emodnetbio__oit_spp_…     3 lat(deg)… -75.0… EPSG… -75.05, 3… 1958-02-16T01:…
#>  7 Emodnetbio__tem_lon_…     3 lat(deg)… -75.0… EPSG… -75.05, 3… 1958-02-16T01:…
#>  8 Emodnetbio__chli_195…     3 lat(deg)… -75.0… EPSG… -75.05, 3… 1958-02-16T01:…
#>  9 Emodnetbio__tot_lar_…     3 lat(deg)… -75.0… EPSG… -75.05, 3… 1958-02-16T01:…
#> 10 Emodnetbio__tot_sma_…     3 lat(deg)… -75.0… EPSG… -75.05, 3… 1958-02-16T01:…
#> # ℹ 2 more variables: vertical_extent <chr>, subtype <chr>
```

Get more detailed coverage metadata about specific coverage.

``` r
emdn_get_coverage_info(
  wcs,
  coverage_ids = "Emodnetbio__cal_fin_19582016_L1_err"
)
#> # A tibble: 1 × 21
#>   data_source service_name     service_url coverage_id band_description band_uom
#>   <chr>       <chr>            <chr>       <chr>       <chr>            <chr>   
#> 1 emodnet_wcs https://geo.vli… biology     Emodnetbio… Relative abunda… W.m-2.S…
#> # ℹ 15 more variables: constraint <chr>, nil_value <dbl>, dim_n <int>,
#> #   dim_names <chr>, grid_size <chr>, resolution <chr>, extent <chr>,
#> #   crs <chr>, wgs84_extent <chr>, temporal_extent <chr>,
#> #   vertical_extent <chr>, subtype <chr>, fn_seq_rule <chr>,
#> #   fn_start_point <chr>, fn_axis_order <chr>
```

The package offers a number of functions for extracting individual
metadata in more usable forms, for instance:

``` r
emdn_get_coverage_ids(wcs)
#>  [1] "Emodnetbio__ratio_large_to_small_19582016_L1_err"
#>  [2] "Emodnetbio__aca_spp_19582016_L1"                 
#>  [3] "Emodnetbio__cal_fin_19582016_L1_err"             
#>  [4] "Emodnetbio__cal_hel_19582016_L1_err"             
#>  [5] "Emodnetbio__met_luc_19582016_L1_err"             
#>  [6] "Emodnetbio__oit_spp_19582016_L1_err"             
#>  [7] "Emodnetbio__tem_lon_19582016_L1_err"             
#>  [8] "Emodnetbio__chli_19582016_L1_err"                
#>  [9] "Emodnetbio__tot_lar_19582016_L1_err"             
#> [10] "Emodnetbio__tot_sma_19582016_L1_err"
```

For more details, please refer to the [Getting metadata about Services &
Coverages](https://emodnet.github.io/emodnet.wcs/articles/metadata.html)
article in the emodnet.wcs online documentation.

## Downloading Coverages

The package also provides a function to download full or subsets of
coverages from emodnet.wcs services.

The following example downloads a spatial subset of a coverage using a
bounding box.

``` r
coverage_id <- "Emodnetbio__cal_fin_19582016_L1_err"
cov <- emdn_get_coverage(
  wcs,
  coverage_id = coverage_id,
  bbox = c(
    xmin = 0L,
    ymin = 40L,
    xmax = 5L,
    ymax = 45L
  )
)
#> ── Downloading coverage "Emodnetbio__cal_fin_19582016_L1_err" ──────────────────
#> <GMLEnvelope>
#> ....|-- lowerCorner: 40 0 "1958-02-16T01:00:00"
#> ....|-- upperCorner: 45 5 "2016-11-16T01:00:00"
#> ✔ Coverage "Emodnetbio__cal_fin_19582016_L1_err" downloaded succesfully as a
#> terra <SpatRaster> .

cov
#> class       : SpatRaster 
#> size        : 50, 50, 2  (nrow, ncol, nlyr)
#> resolution  : 0.1, 0.1  (x, y)
#> extent      : 0.05, 5.05, 39.95, 44.95  (xmin, xmax, ymin, ymax)
#> coord. ref. : lon/lat WGS 84 (EPSG:4326) 
#> source      : Emodnetbio__cal_fin_19582016_L1_err_2016-11-16T01_00_00_40,0,45,5.tif 
#> names       : Emodnetbio__cal~_00_40,0,45,5_1, Emodnetbio__cal~_00_40,0,45,5_2
```

``` r
terra::plot(cov)
```

![](emodnet.wcs_files/figure-html/unnamed-chunk-5-1.png)

For more details on downloading coverages, please refer to the [Download
Coverages](https://emodnet.github.io/emodnet.wcs/articles/coverages.html)
article in the emodnet.wcs online documentation.
