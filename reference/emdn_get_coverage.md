# Download data (coverage)

Get a coverage from an EMODnet WCS Service

## Usage

``` r
emdn_get_coverage(
  wcs = NULL,
  service = NULL,
  coverage_id,
  service_version = c("2.0.1", "2.1.0", "2.0.0", "1.1.1", "1.1.0"),
  logger = c("NONE", "INFO", "DEBUG"),
  bbox = NULL,
  crs = "EPSG:4326",
  time = NULL,
  elevation = NULL,
  format = NULL,
  rangesubset = NULL,
  filename = NULL,
  nil_values_as_na = FALSE
)
```

## Arguments

- wcs:

  A `WCSClient` R6 object, created with function
  [`emdn_init_wcs_client`](https://emodnet.github.io/emodnet.wcs/reference/emdn_init_wcs_client.md).

- service:

  the EMODnet OGC WCS service name. For available services, see
  [`emdn_wcs()`](https://emodnet.github.io/emodnet.wcs/reference/emdn_wcs.md).

- coverage_id:

  character string. Coverage ID. Inspect your `wcs` object for available
  coverages.

- service_version:

  the WCS service version. Defaults to "2.0.1".

- logger:

  character string. Level of logger: 'NONE' for no logger, 'INFO' to get
  ows4R logs, 'DEBUG' for all internal logs (such as as Curl details)

- bbox:

  a named numeric vector of length 4, with names `xmin`, `ymin`, `xmax`
  and `ymax`, specifying the bounding box (extent) of the raster to be
  returned. Can also be an object that can be coerced to a `bbox` object
  with
  [`sf::st_bbox()`](https://r-spatial.github.io/sf/reference/st_bbox.html).

- crs:

  the CRS of the supplied bounding box (EPSG prefixed code, or URI/URN).
  Defaults to `"EPSG:4326"`. It will be ignored when the CRS is already
  defined for argument `bbox`.

- time:

  for coverages that include a temporal dimension, a vector of temporal
  coefficients specifying the time points for which coverage data should
  be returned. If `NULL` (default), the last time point is returned. To
  get a list of all available temporal coefficients, see
  [`emdn_get_coverage_dim_coefs`](https://emodnet.github.io/emodnet.wcs/reference/emdn_get_coverage_summaries.md).
  For a single time point, a `SpatRaster` is returned. For more than one
  time points, `SpatRaster` stack is returned.

- elevation:

  for coverages that include a vertical dimension, a vector of vertical
  coefficients specifying the elevation for which coverage data should
  be returned. If `NULL` (default), the last elevation is returned. To
  get a list of all available vertical coefficients, see
  [`emdn_get_coverage_dim_coefs`](https://emodnet.github.io/emodnet.wcs/reference/emdn_get_coverage_summaries.md).
  For a single elevation, a `SpatRaster` is returned. For more than one
  elevation, `SpatRaster` stack is returned.

- format:

  the format of the file the coverage should be written out to.

- rangesubset:

  character vector of band descriptions to subset. Can work better if
  you use a bounding box (https://github.com/eblondel/ows4R/issues/147).

- filename:

  the file name to write to.

- nil_values_as_na:

  logical. Should raster nil values be converted to `NA`?

## Value

an object of class
[`terra::SpatRaster`](https://rspatial.github.io/terra/reference/SpatRaster-class.html).
The function also writes the coverage to a local file.

## Examples

``` r
wcs <- emdn_init_wcs_client(service = "biology")
#> ✔ WCS client created succesfully
#> ℹ Service: <https://geo.vliz.be/geoserver/Emodnetbio/wcs>
#> ℹ Service: "2.0.1"
coverage_id <- "Emodnetbio__cal_fin_19582016_L1_err"
# Subset using a bounding box
emdn_get_coverage(wcs,
  coverage_id = coverage_id,
  bbox = c(
    xmin = 0, ymin = 40,
    xmax = 5, ymax = 45
  )
)
#> No encoding supplied: defaulting to UTF-8.
#> ── Downloading coverage "Emodnetbio__cal_fin_19582016_L1_err" ──────────────────
#> <GMLEnvelope>
#> ....|-- lowerCorner: 40 0 "1958-02-16T01:00:00"
#> ....|-- upperCorner: 45 5 "2016-11-16T01:00:00"
#> ✔ Coverage "Emodnetbio__cal_fin_19582016_L1_err" downloaded succesfully as a
#> terra <SpatRaster> .
#> class       : SpatRaster 
#> size        : 50, 50, 2  (nrow, ncol, nlyr)
#> resolution  : 0.1, 0.1  (x, y)
#> extent      : 0.05, 5.05, 39.95, 44.95  (xmin, xmax, ymin, ymax)
#> coord. ref. : lon/lat WGS 84 (EPSG:4326) 
#> source      : Emodnetbio__cal_fin_19582016_L1_err_2016-11-16T01_00_00_40,0,45,5.tif 
#> names       : Emodnetbio__cal~ative-abundance, Emodnetbio__cal~_relative-error 
# Subset using a bounding box and specific timepoints
emdn_get_coverage(wcs,
  coverage_id = coverage_id,
  bbox = c(
    xmin = 0, ymin = 40,
    xmax = 5, ymax = 45
  ),
  time = c(
    "1958-02-16T01:00:00",
    "1958-05-16T01:00:00"
  )
)
#> ── Downloading coverage "Emodnetbio__cal_fin_19582016_L1_err" ──────────────────
#> <GMLEnvelope>
#> ....|-- lowerCorner: 40 0 "1958-02-16T01:00:00"
#> ....|-- upperCorner: 45 5 "2016-11-16T01:00:00"<GMLEnvelope>
#> ....|-- lowerCorner: 40 0 "1958-02-16T01:00:00"
#> ....|-- upperCorner: 45 5 "2016-11-16T01:00:00"
#> ✔ Coverage "Emodnetbio__cal_fin_19582016_L1_err" downloaded succesfully as a
#> terra <SpatRaster> Stack.
#> class       : SpatRaster 
#> size        : 50, 50, 4  (nrow, ncol, nlyr)
#> resolution  : 0.1, 0.1  (x, y)
#> extent      : 0.05, 5.05, 39.95, 44.95  (xmin, xmax, ymin, ymax)
#> coord. ref. : lon/lat WGS 84 (EPSG:4326) 
#> sources     : Emodnetbio__cal_fin_19582016_L1_err_1958-02-16T01_00_00_40,0,45,5.tif  (2 layers) 
#>               Emodnetbio__cal_fin_19582016_L1_err_1958-05-16T01_00_00_40,0,45,5.tif  (2 layers) 
#> names       : Emodnet~undance, Emodnet~e-error, Emodnet~undance, Emodnet~e-error 
# Subset using a bounding box and a specific band
north_sea_bbox <- c(xmin = -4, ymin = 50, xmax = 10, ymax = 62)
emdn_get_coverage(wcs,
  coverage_id = coverage_id,
  bbox = north_sea_bbox,
  rangesubset = "Relative abundance"
)
#> ── Downloading coverage "Emodnetbio__cal_fin_19582016_L1_err" ──────────────────
#> <GMLEnvelope>
#> ....|-- lowerCorner: 50 -4 "1958-02-16T01:00:00"
#> ....|-- upperCorner: 62 10 "2016-11-16T01:00:00"
#> ✔ Coverage "Emodnetbio__cal_fin_19582016_L1_err" downloaded succesfully as a
#> terra <SpatRaster> .
#> class       : SpatRaster 
#> size        : 120, 140, 1  (nrow, ncol, nlyr)
#> resolution  : 0.1, 0.1  (x, y)
#> extent      : -4.05, 9.95, 49.95, 61.95  (xmin, xmax, ymin, ymax)
#> coord. ref. : lon/lat WGS 84 (EPSG:4326) 
#> source      : Emodnetbio__cal_fin_19582016_L1_err_2016-11-16T01_00_00_50,-4,62,10.tif 
#> name        : Emodnetbio__cal_fin_19582016_L~50,-4,62,10_relative-abundance 
```
