# Metadata about data available from the different services: data (coverage) from a data source (service), metadata on coverage from a service.

Get EMODnet WCS service and available coverage information.

## Usage

``` r
emdn_get_wcs_info(
  wcs = NULL,
  service = NULL,
  service_version = c("2.0.1", "2.1.0", "2.0.0", "1.1.1", "1.1.0"),
  logger = c("NONE", "INFO", "DEBUG")
)

emdn_get_wcs_info_all(logger = c("NONE", "INFO", "DEBUG"))

emdn_get_coverage_info(
  wcs = NULL,
  service = NULL,
  coverage_ids,
  service_version = c("2.0.1", "2.1.0", "2.0.0", "1.1.1", "1.1.0"),
  logger = c("NONE", "INFO", "DEBUG")
)
```

## Arguments

- wcs:

  A `WCSClient` R6 object, created with function
  [`emdn_init_wcs_client`](https://emodnet.github.io/emodnet.wcs/reference/emdn_init_wcs_client.md).

- service:

  the EMODnet OGC WCS service name. For available services, see
  [`emdn_wcs()`](https://emodnet.github.io/emodnet.wcs/reference/emdn_wcs.md).

- service_version:

  the WCS service version. Defaults to "2.0.1".

- logger:

  character string. Level of logger: 'NONE' for no logger, 'INFO' to get
  ows4R logs, 'DEBUG' for all internal logs (such as as Curl details)

- coverage_ids:

  character vector of coverage IDs.

## Value

`emdn_get_wcs_info` & `emdn_get_wcs_info` return a list of service level
metadata, including a tibble containing coverage level metadata for each
coverage available from the service. `emdn_get_coverage_info` returns a
list containing a tibble of more detailed metadata for each coverage
specified.

### `emdn_get_wcs_info` / `emdn_get_wcs_info_all`

`emdn_get_wcs_info` and `emdn_get_wcs_info_all` return a list with the
following metadata:

- **`data_source`:** the EMODnet source of data.

- **`service_name`:** the EMODnet WCS service name.

- **`service_url`:** the EMODnet WCS service URL.

- **`service_title`:** the EMODnet WCS service title.

- **`service_abstract`:** the EMODnet WCS service abstract.

- **`service_access_constraits`:** any access constraints associated
  with the EMODnet WCS service.

- **`service_fees`:** any access fees associated with the EMODnet WCS
  service.

- **`service_type`:** the EMODnet WCS service type.

- **`coverage_details`:** a tibble of details of each coverage available
  through EMODnet WCS service:

  - **`coverage_id`:** the coverage ID.

  - **`dim_n`:** the number of coverage dimensions

  - **`dim_names`:** the coverage dimension names, units (in brackets)
    and types.

  - **`extent`:** the coverage extent (`xmin`, `ymin`, `xmax` and
    `ymax`).

  - **`crs`:** the coverage CRS (Coordinate Reference System).

  - **`wgs84_bbox`:** the coverage extent (`xmin`, `ymin`, `xmax` and
    `ymax`) in WGS84 (EPSG:4326) CRS coordinates.

  - **`temporal_extent`:** the coverage temporal extent (`min` - `max`),
    `NA` if coverage contains no temporal dimension.

  - **`vertical_extent`:** the coverage vertical extent (`min` - `max`),
    `NA` if coverage contains no vertical dimension.

  - **`subtype`:** the coverage subtype.

### `emdn_get_coverage_info`

`emdn_get_coverage_info` returns a tibble with a row for each coverage
specified and columns with the following details:

- **`data_source`:** the EMODnet source of data.

- **`service_name`:** the EMODnet WCS service name.

- **`service_url`:** the EMODnet WCS service URL.

- **`coverage_ids`:** the coverage ID.

- **`band_description`:** the description of the data contained each
  band of the coverage.

- **`band_uom`:** the unit of measurement of the data contained each
  band of the coverage. If all bands share the same unit of measurement,
  the single shared uom is shown.

- **`constraint`:** the range of values of the data contained in each
  band of the coverage. If all bands share the same constraint, the
  single shared constraint range is shown.

- **`nil_value`:** the nil values of the data contained each band of the
  coverage. If all bands share the same nil value, the single shared nil
  value is shown.

- **`grid_size`:** the spatial size of the coverage grid (ncol x nrow).

- **`resolution`:** the spatial resolution (pixel size) of the coverage
  grid in the CRS units of measurement (size in the `x` dimension x size
  in the `y` dimension).

- **`dim_n`:** the number of coverage dimensions

- **`dim_names`:** the coverage dimension names, units (in brackets) and
  types.

- **`extent`:** the coverage extent (`xmin`, `ymin`, `xmax` and `ymax`).

- **`crs`:** the coverage CRS (Coordinate Reference System).

- **`wgs84_bbox`:** the coverage extent (`xmin`, `ymin`, `xmax` and
  `ymax`) in WGS84 (EPSG:4326) CRS coordinates.

- **`temporal_extent`:** the coverage temporal extent (`min` - `max`),
  `NA` if coverage contains no temporal dimension.

- **`vertical_extent`:** the coverage vertical extent (`min` - `max`),
  `NA` if coverage contains no vertical dimension.

- **`subtype`:** the coverage subtype.

- **`fn_seq_rule`:** the function describing the sequence rule which
  specifies the relationship between the axes of data and coordinate
  system axes.

- **`fn_start_point`:** the location of the origin of the data in the
  coordinate system.

- **`fn_axis_order`:** the axis order and direction of mapping of values
  onto the grid, beginning at the starting point. For example, `"+2 +1"`
  indicates the value range is ordered from the bottom left to the top
  right of the grid envelope - lowest to highest in the x-axis direction
  first (`+2`), then lowest to highest in the y-axis direction (`+1`)
  from the `starting_point`.

For additional details on WCS metadata, see the GDAL wiki section on
[WCS Basics and
GDAL](https://trac.osgeo.org/gdal/wiki/WCS%2Binteroperability)

## Details

To minimize the number of requests sent to webservices, these functions
use [`memoise`](https://memoise.r-lib.org/) to cache results inside the
active R session. To clear the cache, re-start R or run
`memoise::forget(emdn_get_wcs_info)`/`memoise::forget(emdn_get_coverage_info)`

## Functions

- `emdn_get_wcs_info()`: Get info on all coverages from am EMODnet WCS
  service.

- `emdn_get_wcs_info_all()`: Get metadata on all services and all
  available coverages from each service.

- `emdn_get_coverage_info()`: Get metadata for specific coverages.
  Requires a `WCSClient` R6 object as input.

## Examples

``` r
# Get information from a wcs object.
wcs <- emdn_init_wcs_client(service = "seabed_habitats")
#> ✔ WCS client created succesfully
#> ℹ Service: <https://ows.emodnet-seabedhabitats.eu/geoserver/emodnet_open_maplibrary/wcs>
#> ℹ Service: "2.0.1"
emdn_get_wcs_info(wcs)
#> ! Error in `length` and `suppressMessages(.x$getDimensions())` Returning NA
#> ! Error in `length` and `suppressMessages(.x$getDimensions())` Returning NA
#> ! Error in `length` and `suppressMessages(.x$getDimensions())` Returning NA
#> ! Error in `length` and `suppressMessages(.x$getDimensions())` Returning NA
#> ! Error in `length` and `suppressMessages(.x$getDimensions())` Returning NA
#> ! Error in `length` and `suppressMessages(.x$getDimensions())` Returning NA
#> ! Error in `length` and `suppressMessages(.x$getDimensions())` Returning NA
#> ! Error in `length` and `suppressMessages(.x$getDimensions())` Returning NA
#> ! Error in `length` and `suppressMessages(.x$getDimensions())` Returning NA
#> ! Error in `length` and `suppressMessages(.x$getDimensions())` Returning NA
#> ! Error in `length` and `suppressMessages(.x$getDimensions())` Returning NA
#> ! Error in `length` and `suppressMessages(.x$getDimensions())` Returning NA
#> ! Error in `length` and `suppressMessages(.x$getDimensions())` Returning NA
#> ! Error in `length` and `suppressMessages(.x$getDimensions())` Returning NA
#> ! Error in `length` and `suppressMessages(.x$getDimensions())` Returning NA
#> ! Error in `length` and `suppressMessages(.x$getDimensions())` Returning NA
#> ! Error in `length` and `suppressMessages(.x$getDimensions())` Returning NA
#> ! Error in `length` and `suppressMessages(.x$getDimensions())` Returning NA
#> ! Error in `length` and `suppressMessages(.x$getDimensions())` Returning NA
#> ! Error in `length` and `suppressMessages(.x$getDimensions())` Returning NA
#> ! Error in `length` and `suppressMessages(.x$getDimensions())` Returning NA
#> ! Error in `length` and `suppressMessages(.x$getDimensions())` Returning NA
#> ! Error in `length` and `suppressMessages(.x$getDimensions())` Returning NA
#> ! Error in `length` and `suppressMessages(.x$getDimensions())` Returning NA
#> ! Error in `length` and `suppressMessages(.x$getDimensions())` Returning NA
#> ! Error in `length` and `suppressMessages(.x$getDimensions())` Returning NA
#> ! Error in `length` and `suppressMessages(.x$getDimensions())` Returning NA
#> ! Error in `emdn_get_dimensions_info`, `.x`, and `character` Returning NA
#> ! Error in `emdn_get_dimensions_info`, `.x`, and `character` Returning NA
#> ! Error in `emdn_get_dimensions_info`, `.x`, and `character` Returning NA
#> ! Error in `emdn_get_dimensions_info`, `.x`, and `character` Returning NA
#> ! Error in `emdn_get_dimensions_info`, `.x`, and `character` Returning NA
#> ! Error in `emdn_get_dimensions_info`, `.x`, and `character` Returning NA
#> ! Error in `emdn_get_dimensions_info`, `.x`, and `character` Returning NA
#> ! Error in `emdn_get_dimensions_info`, `.x`, and `character` Returning NA
#> ! Error in `emdn_get_dimensions_info`, `.x`, and `character` Returning NA
#> ! Error in `emdn_get_dimensions_info`, `.x`, and `character` Returning NA
#> ! Error in `emdn_get_dimensions_info`, `.x`, and `character` Returning NA
#> ! Error in `emdn_get_dimensions_info`, `.x`, and `character` Returning NA
#> ! Error in `emdn_get_dimensions_info`, `.x`, and `character` Returning NA
#> ! Error in `emdn_get_dimensions_info`, `.x`, and `character` Returning NA
#> ! Error in `emdn_get_dimensions_info`, `.x`, and `character` Returning NA
#> ! Error in `emdn_get_dimensions_info`, `.x`, and `character` Returning NA
#> ! Error in `emdn_get_dimensions_info`, `.x`, and `character` Returning NA
#> ! Error in `emdn_get_dimensions_info`, `.x`, and `character` Returning NA
#> ! Error in `emdn_get_dimensions_info`, `.x`, and `character` Returning NA
#> ! Error in `emdn_get_dimensions_info`, `.x`, and `character` Returning NA
#> ! Error in `emdn_get_dimensions_info`, `.x`, and `character` Returning NA
#> ! Error in `emdn_get_dimensions_info`, `.x`, and `character` Returning NA
#> ! Error in `emdn_get_dimensions_info`, `.x`, and `character` Returning NA
#> ! Error in `emdn_get_dimensions_info`, `.x`, and `character` Returning NA
#> ! Error in `emdn_get_dimensions_info`, `.x`, and `character` Returning NA
#> ! Error in `emdn_get_dimensions_info`, `.x`, and `character` Returning NA
#> ! Error in `emdn_get_dimensions_info`, `.x`, and `character` Returning NA
#> ! Error in `paste`, `emdn_get_temporal_extent(.x)`, and ` - ` Returning NA
#> ! Error in `paste`, `emdn_get_temporal_extent(.x)`, and ` - ` Returning NA
#> ! Error in `paste`, `emdn_get_temporal_extent(.x)`, and ` - ` Returning NA
#> ! Error in `paste`, `emdn_get_temporal_extent(.x)`, and ` - ` Returning NA
#> ! Error in `paste`, `emdn_get_temporal_extent(.x)`, and ` - ` Returning NA
#> ! Error in `paste`, `emdn_get_temporal_extent(.x)`, and ` - ` Returning NA
#> ! Error in `paste`, `emdn_get_temporal_extent(.x)`, and ` - ` Returning NA
#> ! Error in `paste`, `emdn_get_temporal_extent(.x)`, and ` - ` Returning NA
#> ! Error in `paste`, `emdn_get_temporal_extent(.x)`, and ` - ` Returning NA
#> ! Error in `paste`, `emdn_get_temporal_extent(.x)`, and ` - ` Returning NA
#> ! Error in `paste`, `emdn_get_temporal_extent(.x)`, and ` - ` Returning NA
#> ! Error in `paste`, `emdn_get_temporal_extent(.x)`, and ` - ` Returning NA
#> ! Error in `paste`, `emdn_get_temporal_extent(.x)`, and ` - ` Returning NA
#> ! Error in `paste`, `emdn_get_temporal_extent(.x)`, and ` - ` Returning NA
#> ! Error in `paste`, `emdn_get_temporal_extent(.x)`, and ` - ` Returning NA
#> ! Error in `paste`, `emdn_get_temporal_extent(.x)`, and ` - ` Returning NA
#> ! Error in `paste`, `emdn_get_temporal_extent(.x)`, and ` - ` Returning NA
#> ! Error in `paste`, `emdn_get_temporal_extent(.x)`, and ` - ` Returning NA
#> ! Error in `paste`, `emdn_get_temporal_extent(.x)`, and ` - ` Returning NA
#> ! Error in `paste`, `emdn_get_temporal_extent(.x)`, and ` - ` Returning NA
#> ! Error in `paste`, `emdn_get_temporal_extent(.x)`, and ` - ` Returning NA
#> ! Error in `paste`, `emdn_get_temporal_extent(.x)`, and ` - ` Returning NA
#> ! Error in `paste`, `emdn_get_temporal_extent(.x)`, and ` - ` Returning NA
#> ! Error in `paste`, `emdn_get_temporal_extent(.x)`, and ` - ` Returning NA
#> ! Error in `paste`, `emdn_get_temporal_extent(.x)`, and ` - ` Returning NA
#> ! Error in `paste`, `emdn_get_temporal_extent(.x)`, and ` - ` Returning NA
#> ! Error in `paste`, `emdn_get_temporal_extent(.x)`, and ` - ` Returning NA
#> ! Error in `paste`, `emdn_get_vertical_extent(.x)`, and ` - ` Returning NA
#> ! Error in `paste`, `emdn_get_vertical_extent(.x)`, and ` - ` Returning NA
#> ! Error in `paste`, `emdn_get_vertical_extent(.x)`, and ` - ` Returning NA
#> ! Error in `paste`, `emdn_get_vertical_extent(.x)`, and ` - ` Returning NA
#> ! Error in `paste`, `emdn_get_vertical_extent(.x)`, and ` - ` Returning NA
#> ! Error in `paste`, `emdn_get_vertical_extent(.x)`, and ` - ` Returning NA
#> ! Error in `paste`, `emdn_get_vertical_extent(.x)`, and ` - ` Returning NA
#> ! Error in `paste`, `emdn_get_vertical_extent(.x)`, and ` - ` Returning NA
#> ! Error in `paste`, `emdn_get_vertical_extent(.x)`, and ` - ` Returning NA
#> ! Error in `paste`, `emdn_get_vertical_extent(.x)`, and ` - ` Returning NA
#> ! Error in `paste`, `emdn_get_vertical_extent(.x)`, and ` - ` Returning NA
#> ! Error in `paste`, `emdn_get_vertical_extent(.x)`, and ` - ` Returning NA
#> ! Error in `paste`, `emdn_get_vertical_extent(.x)`, and ` - ` Returning NA
#> ! Error in `paste`, `emdn_get_vertical_extent(.x)`, and ` - ` Returning NA
#> ! Error in `paste`, `emdn_get_vertical_extent(.x)`, and ` - ` Returning NA
#> ! Error in `paste`, `emdn_get_vertical_extent(.x)`, and ` - ` Returning NA
#> ! Error in `paste`, `emdn_get_vertical_extent(.x)`, and ` - ` Returning NA
#> ! Error in `paste`, `emdn_get_vertical_extent(.x)`, and ` - ` Returning NA
#> ! Error in `paste`, `emdn_get_vertical_extent(.x)`, and ` - ` Returning NA
#> ! Error in `paste`, `emdn_get_vertical_extent(.x)`, and ` - ` Returning NA
#> ! Error in `paste`, `emdn_get_vertical_extent(.x)`, and ` - ` Returning NA
#> ! Error in `paste`, `emdn_get_vertical_extent(.x)`, and ` - ` Returning NA
#> ! Error in `paste`, `emdn_get_vertical_extent(.x)`, and ` - ` Returning NA
#> ! Error in `paste`, `emdn_get_vertical_extent(.x)`, and ` - ` Returning NA
#> ! Error in `paste`, `emdn_get_vertical_extent(.x)`, and ` - ` Returning NA
#> ! Error in `paste`, `emdn_get_vertical_extent(.x)`, and ` - ` Returning NA
#> ! Error in `paste`, `emdn_get_vertical_extent(.x)`, and ` - ` Returning NA
#> $data_source
#> [1] "emodnet_wcs"
#> 
#> $service_name
#> [1] "seabed_habitats"
#> 
#> $service_url
#> [1] "https://ows.emodnet-seabedhabitats.eu/geoserver/emodnet_open_maplibrary/wcs"
#> 
#> $service_title
#> [1] "EMODnet Seabed Habitats Map Library WCS Service"
#> 
#> $service_abstract
#> [1] "WCS end-point for individual habitat maps and models held by EMODnet Seabed Habitats.\r\n\r\nIncludes all data with access limitations of \"View and Download\" (excluding \"View only\" data)"
#> 
#> $service_access_constraits
#> [1] "None"
#> 
#> $service_fees
#> [1] "None"
#> 
#> $service_type
#> [1] "urn:ogc:service:wcs"
#> 
#> $coverage_details
#> # A tibble: 75 × 9
#>    coverage_id           dim_n dim_names extent crs   wgs84_bbox temporal_extent
#>    <chr>                 <int> <chr>     <chr>  <chr> <chr>      <chr>          
#>  1 emodnet_open_maplibr…     2 lat(deg)… -56.5… EPSG… -56.51, 2… NA             
#>  2 emodnet_open_maplibr…     2 x(m):geo… 28763… EPSG… -16.25, 4… NA             
#>  3 emodnet_open_maplibr…     2 x(m):geo… 30398… EPSG… -12.97, 4… NA             
#>  4 emodnet_open_maplibr…     2 x(m):geo… 17828… EPSG… -39.03, 4… NA             
#>  5 emodnet_open_maplibr…     2 lat(deg)… -66, … EPSG… -66, -62.… NA             
#>  6 emodnet_open_maplibr…     2 lat(deg)… -66, … EPSG… -66, -62.… NA             
#>  7 emodnet_open_maplibr…     2 lat(deg)… -66, … EPSG… -66, -62.… NA             
#>  8 emodnet_open_maplibr…     2 lat(deg)… -75, … EPSG… -75, 54.3… NA             
#>  9 emodnet_open_maplibr…     2 lat(deg)… -75, … EPSG… -75, 54.3… NA             
#> 10 emodnet_open_maplibr…     2 x(m):geo… -7299… EPSG… -6.56, 29… NA             
#> # ℹ 65 more rows
#> # ℹ 2 more variables: vertical_extent <chr>, subtype <chr>
#> 
# Get information using a service name.
emdn_get_wcs_info(service = "seabed_habitats")
#> Error in RequestHandlerHttr2$new(req)$handle(): Failed to find matching request in active cassette, "info".
#> ℹ Use `local_vcr_configure_log()` to get more details.
#> ℹ Learn more in `vignette(vcr::debugging)`.
# Get detailed info for specific coverages from wcs object
coverage_ids <- c(
  "emodnet_open_maplibrary__mediseh_cora",
  "emodnet_open_maplibrary__mediseh_posidonia"
)
emdn_get_coverage_info(
  wcs = wcs,
  coverage_ids = coverage_ids
)
#> # A tibble: 2 × 21
#>   data_source service_name     service_url coverage_id band_description band_uom
#>   <chr>       <chr>            <chr>       <chr>       <chr>            <chr>   
#> 1 emodnet_wcs https://ows.emo… seabed_hab… emodnet_op… GRAY_INDEX       W.m-2.S…
#> 2 emodnet_wcs https://ows.emo… seabed_hab… emodnet_op… Probability_occ… W.m-2.S…
#> # ℹ 15 more variables: constraint <chr>, nil_value <dbl>, dim_n <int>,
#> #   dim_names <chr>, grid_size <chr>, resolution <chr>, extent <chr>,
#> #   crs <chr>, wgs84_extent <chr>, temporal_extent <chr>,
#> #   vertical_extent <chr>, subtype <chr>, fn_seq_rule <chr>,
#> #   fn_start_point <chr>, fn_axis_order <chr>
```
