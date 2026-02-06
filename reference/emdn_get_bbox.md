# Individual coverage level metadata

Get coverage metadata from a `<WCSCoverageSummary>` object.

## Usage

``` r
emdn_get_bbox(summary)

emdn_get_WGS84bbox(summary)

emdn_get_band_nil_values(summary, band = NULL)

emdn_get_band_descriptions(summary)

emdn_get_band_uom(summary)

emdn_get_band_constraints(summary)

emdn_get_grid_size(summary)

emdn_get_resolution(summary)

emdn_get_coverage_function(summary)

emdn_get_temporal_extent(summary)

emdn_get_vertical_extent(summary)

emdn_get_dimensions_info(
  summary,
  format = c("character", "list", "tibble"),
  include_coeffs = FALSE
)

emdn_get_dimensions_names(summary)

emdn_get_dimensions_n(summary)

emdn_get_dimension_types(summary)
```

## Arguments

- summary:

  a `<WCSCoverageSummary>` object.

- band:

  Character vector of bands. By default all bands.

- format:

  character string. Coverage dimension info output format. One of
  `"character"` (default), `"list"` or `"tibble"`.

- include_coeffs:

  whether to include a vector of temporal or vertical dimension
  coefficients (if applicable) in the coverage dimension info `"list"`
  output format. Defaults to `FALSE`. Ignored for other formats.

## Value

- `emdn_get_bbox`: an object of class `bbox` of length 4 expressing the
  boundaries coverage extent/envelope. See
  [`sf::st_bbox()`](https://r-spatial.github.io/sf/reference/st_bbox.html)
  for more details.

- `emdn_get_WGS84bbox`: an object of class `bbox` of length 4 expressing
  the boundaries coverage extent/envelope. See
  [`sf::st_bbox()`](https://r-spatial.github.io/sf/reference/st_bbox.html)
  for more details.

- `emdn_get_band_nil_values` a numeric scalar of the value representing
  nil values in a coverage.

- `emdn_get_band_descriptions` a character vector of band descriptions.

- `emdn_get_band_uom` a character vector of band units of measurement.

- `emdn_get_band_constraints` a list of numeric vectors of length 2
  indicating the min and max values of the data contained in each bands
  of the coverage.

- `emdn_get_grid_size` a numeric vector of length 2 giving the spatial
  size in grid cells (pixels) of the coverage grid (ncol x nrow)

- `emdn_get_resolution` a numeric vector of length 2 giving the spatial
  resolution of grid cells (size in the `x` dimension, size in the `y`
  dimension) of a coverage. The attached attribute `uom` gives the units
  of measurement of each dimension.

- `emdn_get_coverage_function` a list with elements:

  - `sequence_rule`, character string, the function describing the
    sequence rule, i.e. the relationship between the axes of data and
    coordinate system axes.

  - `starting_point` a numeric vector of length 2, the location of the
    origin of the data in the coordinate system.

  - `axis_order` a character vector of length 2 specifying the axis
    order and direction of mapping of values onto the grid, beginning at
    the starting point. For example, `"+2 +1"` indicates the value range
    is ordered from the bottom left to the top right of the grid
    envelope - lowest to highest in the x-axis direction first (`+2`),
    then lowest to highest in the y-axis direction (`+1`) from the
    `starting_point`.

- `emdn_get_temporal_extent` if the coverage has a temporal dimension, a
  numeric vector of length 2 giving the min and max values of the
  dimension. Otherwise, NA.

- `emdn_get_vertical_extent` if the coverage has a vertical dimension, a
  numeric vector of length 2 giving the min and max values of the
  dimension. Otherwise, NA.

- `emdn_get_dimensions_info` output depends on `format` argument:

  - `character`: (default) a concatenated character string of dimension
    information

  - `list`: a list of dimension information

  - `tibble`: a tibble of dimension information

## Functions

- `emdn_get_bbox()`: Get the announced bounding box (geographic extent)
  of a coverage. Coordinates are given in the same Coordinate Reference
  System as the coverage. The bounding box is approximate and may
  overestimate coverage.

- `emdn_get_WGS84bbox()`: Get the announced bounding box (geographic
  extent) of a coverage in World Geodetic System 1984 (WGS84) Coordinate
  Reference System (or `EPSG:4326`). The bounding box is approximate and
  may overestimate coverage.

- `emdn_get_band_nil_values()`: Get the value representing nil values in
  a coverage.

- `emdn_get_band_descriptions()`: Get the band descriptions of a
  coverage.

- `emdn_get_band_uom()`: Get the units of measurement of the data
  contained in the bands values of a coverage.

- `emdn_get_band_constraints()`: Get the range of values of the data
  allowed in the bands of the coverage, for requests.

- `emdn_get_grid_size()`: Get the grid size of a coverage.

- `emdn_get_resolution()`: Get the resolution of a coverage.

- `emdn_get_coverage_function()`: Get the grid function of a coverage.

- `emdn_get_temporal_extent()`: Get the temporal extent of a coverage.

- `emdn_get_vertical_extent()`: Get the vertical (elevation) extent of a
  coverage.

- `emdn_get_dimensions_info()`: Get information on dimensions of a
  coverage in various formats. Information includes dimension label,
  type, unit and range (in tibble format).

- `emdn_get_dimensions_names()`: Get coverage dimension names (labels)
  and units.

- `emdn_get_dimensions_n()`: Get number of coverage dimensions.

- `emdn_get_dimension_types()`: Get dimensions types of a coverage.

## Examples

``` r
wcs <- emdn_init_wcs_client(service = "biology")
#> ✔ WCS client created succesfully
#> ℹ Service: <https://geo.vliz.be/geoserver/Emodnetbio/wcs>
#> ℹ Service: "2.0.1"
summaries <- emdn_get_coverage_summaries_all(wcs)
summary <- summaries[[1]]
# get bbox
emdn_get_bbox(summary)
#>   xmin   ymin   xmax   ymax 
#> -75.05  34.95  20.05  75.05 
# get WGS84 bbox
emdn_get_WGS84bbox(summary)
#>   xmin   ymin   xmax   ymax 
#> -75.05  34.95  20.05  75.05 
# get the nil value of a coverage
emdn_get_band_nil_values(summary)
#> Loading required package: sf
#> Linking to GEOS 3.12.1, GDAL 3.8.4, PROJ 9.4.0; sf_use_s2() is FALSE
#> Relative abundance     Relative error 
#>        9.96921e+36        9.96921e+36 
# get coverage band descriptions
emdn_get_band_descriptions(summary)
#> [1] "Relative abundance" "Relative error"    
#> attr(,"uom")
#> [1] "W.m-2.Sr-1" "W.m-2.Sr-1"
# get band units of measurement
emdn_get_band_uom(summary)
#> Relative abundance     Relative error 
#>       "W.m-2.Sr-1"       "W.m-2.Sr-1" 
# get range of band values
emdn_get_band_constraints(summary)
#> $`Relative abundance`
#> [1] -3.402823e+38  3.402823e+38
#> 
#> $`Relative error`
#> [1] -3.402823e+38  3.402823e+38
#> 
# get coverage grid size
emdn_get_grid_size(summary)
#> No encoding supplied: defaulting to UTF-8.
#> ncol nrow 
#>  951  401 
# get coverage resolution
emdn_get_resolution(summary)
#>   x   y 
#> 0.1 0.1 
#> attr(,"uom")
#> [1] "Deg" "Deg"
# get coverage grid function
emdn_get_coverage_function(summary)
#> $sequence_rule
#> [1] "Linear"
#> 
#> $start_point
#> [1] 0 0
#> 
#> $axis_order
#> [1] "+2" "+1"
#> 
# get the extent of the temporal dimension
emdn_get_temporal_extent(summary)
#> [1] "1958-02-16T01:00:00" "2016-11-16T01:00:00"
# get the extent of the vertical dimension
emdn_get_vertical_extent(summary)
#> [1] NA
# get information about coverage dimensions in various formats
emdn_get_dimensions_info(summary)
#> lat(deg):geographic; long(deg):geographic; time(s):temporal
emdn_get_dimensions_info(summary, format = "list")
#> $dim_1
#> $dim_1$label
#> [1] "Lat"
#> 
#> $dim_1$uom
#> [1] "Deg"
#> 
#> $dim_1$type
#> [1] "geographic"
#> 
#> 
#> $dim_2
#> $dim_2$label
#> [1] "Long"
#> 
#> $dim_2$uom
#> [1] "Deg"
#> 
#> $dim_2$type
#> [1] "geographic"
#> 
#> 
#> $dim_3
#> $dim_3$label
#> [1] "time"
#> 
#> $dim_3$uom
#> [1] "s"
#> 
#> $dim_3$type
#> [1] "temporal"
#> 
#> 
emdn_get_dimensions_info(summary, format = "tibble")
#> # A tibble: 3 × 5
#>   dimension label uom   type       range                                    
#>       <int> <chr> <chr> <chr>      <chr>                                    
#> 1         1 lat   deg   geographic NA                                       
#> 2         2 long  deg   geographic NA                                       
#> 3         3 time  s     temporal   1958-02-16T01:00:00 - 2016-11-16T01:00:00
# get dimension names
emdn_get_dimensions_names(summary)
#> [1] "Lat (Deg), Long (Deg), time (s)"
# get number of dimensions
emdn_get_dimensions_n(summary)
#> [1] 3
# get dimensions types
emdn_get_dimension_types(summary)
#> [1] "geographic" "geographic" "temporal"  
```
