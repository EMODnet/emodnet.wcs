# Getting metadata about Services & Coverages

emodnet.wcs offers a number of functions to download and extract
metadata about EMODnet WCS services and available coverages.

Metadata include information about each service, the coverages served by
the server and information about individual coverages including the
geographic, temporal and elevation extents, grid sizes and resolution,
coverage coordinate reference systems and how grid coordinates relate to
geographic coordinates as well as the names, units and ranges of bands
contained in a coverage.

There are functions for downloading compiled metadata for easy review as
well as for extracting individual metadata in more usable forms.

## Downloading & extracting compiled metadata on services and coverages.

First let’s load the package and initiate a client to the `"biology"`
EMODnet WCS server.

``` r
library(emodnet.wcs)
#> Loading ISO 19139 XML schemas...
#> Loading ISO 19115-3 XML schemas...
#> Loading ISO 19139 codelists...
```

``` r
wcs <- emdn_init_wcs_client(service = "biology")
#> ✔ WCS client created succesfully
#> ℹ Service: <https://geo.vliz.be/geoserver/Emodnetbio/wcs>
#> ℹ Service: "2.0.1"
```

### Getting services level and coverage level summary metadata.

To get service level and a subset of coverage level compiled metadata,
we can use
[`emdn_get_wcs_info()`](https://emodnet.github.io/emodnet.wcs/reference/emdn_get_wcs_info.md).

We can supply a
[`<WCSClient>`](https://eblondel.github.io/ows4R/reference/WCSClient.html)
object through the `wcs` argument to get compiled metadata from the
server.

``` r
wcs_info <- emdn_get_wcs_info(wcs = wcs)

wcs_info
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

You can get the same information by supplying a service name to the
`service` argument instead of a `<WCSClient>` object to argument `wcs`.

``` r
emdn_get_wcs_info(service = "biology")
#> ✔ WCS client created succesfully
#> ℹ Service: <https://geo.vliz.be/geoserver/Emodnetbio/wcs>
#> ℹ Service: "2.0.1"
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

The function returns a list of service level metadata which includes a
tibble of summaries of coverage level metadata in the `coverage_details`
element.

Let’s take a closer look at the metadata in `coverage_details`. For
details on these metadata, have a look at the
[`emdn_get_wcs_info()`](https://emodnet.github.io/emodnet.wcs/reference/emdn_get_wcs_info.md)
help page (or use
[`?emdn_get_wcs_info`](https://emodnet.github.io/emodnet.wcs/reference/emdn_get_wcs_info.md)
in R).

| coverage_id                                        | dim_n | dim_names                                                   | extent                      | crs       | wgs84_bbox                  | temporal_extent                           | vertical_extent | subtype               |
|----------------------------------------------------|------:|-------------------------------------------------------------|-----------------------------|-----------|-----------------------------|-------------------------------------------|-----------------|-----------------------|
| Emodnetbio\_\_ratio_large_to_small_19582016_L1_err |     3 | lat(deg):geographic; long(deg):geographic; time(s):temporal | -75.05, 34.95, 20.05, 75.05 | EPSG:4326 | -75.05, 34.95, 20.05, 75.05 | 1958-02-16T01:00:00 - 2016-11-16T01:00:00 | NA              | RectifiedGridCoverage |
| Emodnetbio\_\_aca_spp_19582016_L1                  |     3 | lat(deg):geographic; long(deg):geographic; time(s):temporal | -75.05, 34.95, 20.05, 75.05 | EPSG:4326 | -75.05, 34.95, 20.05, 75.05 | 1958-02-16T01:00:00 - 2016-11-16T01:00:00 | NA              | RectifiedGridCoverage |
| Emodnetbio\_\_cal_fin_19582016_L1_err              |     3 | lat(deg):geographic; long(deg):geographic; time(s):temporal | -75.05, 34.95, 20.05, 75.05 | EPSG:4326 | -75.05, 34.95, 20.05, 75.05 | 1958-02-16T01:00:00 - 2016-11-16T01:00:00 | NA              | RectifiedGridCoverage |
| Emodnetbio\_\_cal_hel_19582016_L1_err              |     3 | lat(deg):geographic; long(deg):geographic; time(s):temporal | -75.05, 34.95, 20.05, 75.05 | EPSG:4326 | -75.05, 34.95, 20.05, 75.05 | 1958-02-16T01:00:00 - 2016-11-16T01:00:00 | NA              | RectifiedGridCoverage |
| Emodnetbio\_\_met_luc_19582016_L1_err              |     3 | lat(deg):geographic; long(deg):geographic; time(s):temporal | -75.05, 34.95, 20.05, 75.05 | EPSG:4326 | -75.05, 34.95, 20.05, 75.05 | 1958-02-16T01:00:00 - 2016-11-16T01:00:00 | NA              | RectifiedGridCoverage |
| Emodnetbio\_\_oit_spp_19582016_L1_err              |     3 | lat(deg):geographic; long(deg):geographic; time(s):temporal | -75.05, 34.95, 20.05, 75.05 | EPSG:4326 | -75.05, 34.95, 20.05, 75.05 | 1958-02-16T01:00:00 - 2016-11-16T01:00:00 | NA              | RectifiedGridCoverage |
| Emodnetbio\_\_tem_lon_19582016_L1_err              |     3 | lat(deg):geographic; long(deg):geographic; time(s):temporal | -75.05, 34.95, 20.05, 75.05 | EPSG:4326 | -75.05, 34.95, 20.05, 75.05 | 1958-02-16T01:00:00 - 2016-11-16T01:00:00 | NA              | RectifiedGridCoverage |
| Emodnetbio\_\_chli_19582016_L1_err                 |     3 | lat(deg):geographic; long(deg):geographic; time(s):temporal | -75.05, 34.95, 20.05, 75.05 | EPSG:4326 | -75.05, 34.95, 20.05, 75.05 | 1958-02-16T01:00:00 - 2016-11-16T01:00:00 | NA              | RectifiedGridCoverage |
| Emodnetbio\_\_tot_lar_19582016_L1_err              |     3 | lat(deg):geographic; long(deg):geographic; time(s):temporal | -75.05, 34.95, 20.05, 75.05 | EPSG:4326 | -75.05, 34.95, 20.05, 75.05 | 1958-02-16T01:00:00 - 2016-11-16T01:00:00 | NA              | RectifiedGridCoverage |
| Emodnetbio\_\_tot_sma_19582016_L1_err              |     3 | lat(deg):geographic; long(deg):geographic; time(s):temporal | -75.05, 34.95, 20.05, 75.05 | EPSG:4326 | -75.05, 34.95, 20.05, 75.05 | 1958-02-16T01:00:00 - 2016-11-16T01:00:00 | NA              | RectifiedGridCoverage |

You can get metadata for all EMODnet WCS services using
[`emdn_get_wcs_info_all()`](https://emodnet.github.io/emodnet.wcs/reference/emdn_get_wcs_info.md).
Note however that this can take a long time to execute.

``` r
emdn_get_wcs_info_all()
```

### Getting coverage level detailed metadata

You can get more detailed coverage metadata about specific coverage
using
[`emdn_get_coverage_info()`](https://emodnet.github.io/emodnet.wcs/reference/emdn_get_wcs_info.md)
and supplying a character vector of `coverage_ids`. Again, you can get
the same information by supplying a service name to the `service`
argument instead of a `<WCSClient>` object to the `wcs` argument.

``` r
cov_info <- emdn_get_coverage_info(
  wcs,
  coverage_ids = "Emodnetbio__aca_spp_19582016_L1"
)
```

The function returns a tibble of detailed coverage level metadata. Let’s
take a closer look.

``` r
cov_info
```

| data_source | service_name                                 | service_url | coverage_id                       | band_description   | band_uom   | constraint                   | nil_value | dim_n | dim_names                                                   | grid_size | resolution        | extent                      | crs       | wgs84_extent                | temporal_extent                           | vertical_extent | subtype               | fn_seq_rule | fn_start_point | fn_axis_order |
|-------------|----------------------------------------------|-------------|-----------------------------------|--------------------|------------|------------------------------|----------:|------:|-------------------------------------------------------------|-----------|-------------------|-----------------------------|-----------|-----------------------------|-------------------------------------------|-----------------|-----------------------|-------------|----------------|---------------|
| emodnet_wcs | https://geo.vliz.be/geoserver/Emodnetbio/wcs | biology     | Emodnetbio\_\_aca_spp_19582016_L1 | relative_abundance | W.m-2.Sr-1 | -3.4028235e+38-3.4028235e+38 |  9.97e+36 |     3 | lat(deg):geographic; long(deg):geographic; time(s):temporal | 951x401   | 0.1 Deg x 0.1 Deg | -75.05, 34.95, 20.05, 75.05 | EPSG:4326 | -75.05, 34.95, 20.05, 75.05 | 1958-02-16T01:00:00 - 2016-11-16T01:00:00 | NA              | RectifiedGridCoverage | Linear      | 0,0            | +2,+1         |

For details on these metadata, have a look at the
[`emdn_get_coverage_info()`](https://emodnet.github.io/emodnet.wcs/reference/emdn_get_wcs_info.md)
help page (or use
[`?emdn_get_coverage_info`](https://emodnet.github.io/emodnet.wcs/reference/emdn_get_wcs_info.md)
in R or Rstudio).

> ##### **Note**
>
> To minimize the number of requests sent to webservices, these
> functions use [`memoise`](https://memoise.r-lib.org/) to cache results
> inside the active R session. To clear the cache, re-start R or run
> `memoise::forget(emdn_get_wcs_info)`/`memoise::forget(emdn_get_coverage_info)`

### Getting individual coverage level metadata

The above functions compile and concatenate metadata into primarily
tabular form for easier review. However the package offers a number of
functions for extracting individual metadata in more usable forms.

#### Getting metadata from a `<WCSClient>` object.

Some metadata can be retrieved directly from a `<WCSClient>` object.

##### Get coverage_ids

You can extract a character vector of available coverage IDs from a
service with function
[`emdn_get_coverage_ids()`](https://emodnet.github.io/emodnet.wcs/reference/emdn_get_coverage_summaries.md)

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

You can also check whether a coverage has a given type of dimension.

``` r
# Check for temporal dimension
emdn_has_dimension(
  wcs,
  coverage_ids = "Emodnetbio__aca_spp_19582016_L1",
  type = "temporal"
)
#> Emodnetbio__aca_spp_19582016_L1 
#>                            TRUE

# Check for vertical dimension
emdn_has_dimension(
  wcs,
  coverage_ids = "Emodnetbio__aca_spp_19582016_L1",
  type = "vertical"
)
#> Emodnetbio__aca_spp_19582016_L1 
#>                           FALSE
```

Or get the coefficients (points in a given dimension) at which data are
available for specific coverages.

``` r
emdn_get_coverage_dim_coefs(
  wcs,
  coverage_ids = "Emodnetbio__aca_spp_19582016_L1",
  type = "temporal"
)
#> $Emodnetbio__aca_spp_19582016_L1
#>   [1] "1958-02-16T01:00:00" "1958-05-16T01:00:00" "1958-08-16T01:00:00"
#>   [4] "1958-11-16T01:00:00" "1959-02-16T01:00:00" "1959-05-16T01:00:00"
#>   [7] "1959-08-16T01:00:00" "1959-11-16T01:00:00" "1960-02-16T01:00:00"
#>  [10] "1960-05-16T01:00:00" "1960-08-16T01:00:00" "1960-11-16T01:00:00"
#>  [13] "1961-02-16T01:00:00" "1961-05-16T01:00:00" "1961-08-16T01:00:00"
#>  [16] "1961-11-16T01:00:00" "1962-02-16T01:00:00" "1962-05-16T01:00:00"
#>  [19] "1962-08-16T01:00:00" "1962-11-16T01:00:00" "1963-02-16T01:00:00"
#>  [22] "1963-05-16T01:00:00" "1963-08-16T01:00:00" "1963-11-16T01:00:00"
#>  [25] "1964-02-16T01:00:00" "1964-05-16T01:00:00" "1964-08-16T01:00:00"
#>  [28] "1964-11-16T01:00:00" "1965-02-16T01:00:00" "1965-05-16T01:00:00"
#>  [31] "1965-08-16T01:00:00" "1965-11-16T01:00:00" "1966-02-16T01:00:00"
#>  [34] "1966-05-16T01:00:00" "1966-08-16T01:00:00" "1966-11-16T01:00:00"
#>  [37] "1967-02-16T01:00:00" "1967-05-16T01:00:00" "1967-08-16T01:00:00"
#>  [40] "1967-11-16T01:00:00" "1968-02-16T01:00:00" "1968-05-16T01:00:00"
#>  [43] "1968-08-16T01:00:00" "1968-11-16T01:00:00" "1969-02-16T01:00:00"
#>  [46] "1969-05-16T01:00:00" "1969-08-16T01:00:00" "1969-11-16T01:00:00"
#>  [49] "1970-02-16T01:00:00" "1970-05-16T01:00:00" "1970-08-16T01:00:00"
#>  [52] "1970-11-16T01:00:00" "1971-02-16T01:00:00" "1971-05-16T01:00:00"
#>  [55] "1971-08-16T01:00:00" "1971-11-16T01:00:00" "1972-02-16T01:00:00"
#>  [58] "1972-05-16T01:00:00" "1972-08-16T01:00:00" "1972-11-16T01:00:00"
#>  [61] "1973-02-16T01:00:00" "1973-05-16T01:00:00" "1973-08-16T01:00:00"
#>  [64] "1973-11-16T01:00:00" "1974-02-16T01:00:00" "1974-05-16T01:00:00"
#>  [67] "1974-08-16T01:00:00" "1974-11-16T01:00:00" "1975-02-16T01:00:00"
#>  [70] "1975-05-16T01:00:00" "1975-08-16T01:00:00" "1975-11-16T01:00:00"
#>  [73] "1976-02-16T01:00:00" "1976-05-16T01:00:00" "1976-08-16T01:00:00"
#>  [76] "1976-11-16T01:00:00" "1977-02-16T01:00:00" "1977-05-16T02:00:00"
#>  [79] "1977-08-16T02:00:00" "1977-11-16T01:00:00" "1978-02-16T01:00:00"
#>  [82] "1978-05-16T02:00:00" "1978-08-16T02:00:00" "1978-11-16T01:00:00"
#>  [85] "1979-02-16T01:00:00" "1979-05-16T02:00:00" "1979-08-16T02:00:00"
#>  [88] "1979-11-16T01:00:00" "1980-02-16T01:00:00" "1980-05-16T02:00:00"
#>  [91] "1980-08-16T02:00:00" "1980-11-16T01:00:00" "1981-02-16T01:00:00"
#>  [94] "1981-05-16T02:00:00" "1981-08-16T02:00:00" "1981-11-16T01:00:00"
#>  [97] "1982-02-16T01:00:00" "1982-05-16T02:00:00" "1982-08-16T02:00:00"
#> [100] "1982-11-16T01:00:00" "1983-02-16T01:00:00" "1983-05-16T02:00:00"
#> [103] "1983-08-16T02:00:00" "1983-11-16T01:00:00" "1984-02-16T01:00:00"
#> [106] "1984-05-16T02:00:00" "1984-08-16T02:00:00" "1984-11-16T01:00:00"
#> [109] "1985-02-16T01:00:00" "1985-05-16T02:00:00" "1985-08-16T02:00:00"
#> [112] "1985-11-16T01:00:00" "1986-02-16T01:00:00" "1986-05-16T02:00:00"
#> [115] "1986-08-16T02:00:00" "1986-11-16T01:00:00" "1987-02-16T01:00:00"
#> [118] "1987-05-16T02:00:00" "1987-08-16T02:00:00" "1987-11-16T01:00:00"
#> [121] "1988-02-16T01:00:00" "1988-05-16T02:00:00" "1988-08-16T02:00:00"
#> [124] "1988-11-16T01:00:00" "1989-02-16T01:00:00" "1989-05-16T02:00:00"
#> [127] "1989-08-16T02:00:00" "1989-11-16T01:00:00" "1990-02-16T01:00:00"
#> [130] "1990-05-16T02:00:00" "1990-08-16T02:00:00" "1990-11-16T01:00:00"
#> [133] "1991-02-16T01:00:00" "1991-05-16T02:00:00" "1991-08-16T02:00:00"
#> [136] "1991-11-16T01:00:00" "1992-02-16T01:00:00" "1992-05-16T02:00:00"
#> [139] "1992-08-16T02:00:00" "1992-11-16T01:00:00" "1993-02-16T01:00:00"
#> [142] "1993-05-16T02:00:00" "1993-08-16T02:00:00" "1993-11-16T01:00:00"
#> [145] "1994-02-16T01:00:00" "1994-05-16T02:00:00" "1994-08-16T02:00:00"
#> [148] "1994-11-16T01:00:00" "1995-02-16T01:00:00" "1995-05-16T02:00:00"
#> [151] "1995-08-16T02:00:00" "1995-11-16T01:00:00" "1996-02-16T01:00:00"
#> [154] "1996-05-16T02:00:00" "1996-08-16T02:00:00" "1996-11-16T01:00:00"
#> [157] "1997-02-16T01:00:00" "1997-05-16T02:00:00" "1997-08-16T02:00:00"
#> [160] "1997-11-16T01:00:00" "1998-02-16T01:00:00" "1998-05-16T02:00:00"
#> [163] "1998-08-16T02:00:00" "1998-11-16T01:00:00" "1999-02-16T01:00:00"
#> [166] "1999-05-16T02:00:00" "1999-08-16T02:00:00" "1999-11-16T01:00:00"
#> [169] "2000-02-16T01:00:00" "2000-05-16T02:00:00" "2000-08-16T02:00:00"
#> [172] "2000-11-16T01:00:00" "2001-02-16T01:00:00" "2001-05-16T02:00:00"
#> [175] "2001-08-16T02:00:00" "2001-11-16T01:00:00" "2002-02-16T01:00:00"
#> [178] "2002-05-16T02:00:00" "2002-08-16T02:00:00" "2002-11-16T01:00:00"
#> [181] "2003-02-16T01:00:00" "2003-05-16T02:00:00" "2003-08-16T02:00:00"
#> [184] "2003-11-16T01:00:00" "2004-02-16T01:00:00" "2004-05-16T02:00:00"
#> [187] "2004-08-16T02:00:00" "2004-11-16T01:00:00" "2005-02-16T01:00:00"
#> [190] "2005-05-16T02:00:00" "2005-08-16T02:00:00" "2005-11-16T01:00:00"
#> [193] "2006-02-16T01:00:00" "2006-05-16T02:00:00" "2006-08-16T02:00:00"
#> [196] "2006-11-16T01:00:00" "2007-02-16T01:00:00" "2007-05-16T02:00:00"
#> [199] "2007-08-16T02:00:00" "2007-11-16T01:00:00" "2008-02-16T01:00:00"
#> [202] "2008-05-16T02:00:00" "2008-08-16T02:00:00" "2008-11-16T01:00:00"
#> [205] "2009-02-16T01:00:00" "2009-05-16T02:00:00" "2009-08-16T02:00:00"
#> [208] "2009-11-16T01:00:00" "2010-02-16T01:00:00" "2010-05-16T02:00:00"
#> [211] "2010-08-16T02:00:00" "2010-11-16T01:00:00" "2011-02-16T01:00:00"
#> [214] "2011-05-16T02:00:00" "2011-08-16T02:00:00" "2011-11-16T01:00:00"
#> [217] "2012-02-16T01:00:00" "2012-05-16T02:00:00" "2012-08-16T02:00:00"
#> [220] "2012-11-16T01:00:00" "2013-02-16T01:00:00" "2013-05-16T02:00:00"
#> [223] "2013-08-16T02:00:00" "2013-11-16T01:00:00" "2014-02-16T01:00:00"
#> [226] "2014-05-16T02:00:00" "2014-08-16T02:00:00" "2014-11-16T01:00:00"
#> [229] "2015-02-16T01:00:00" "2015-05-16T02:00:00" "2015-08-16T02:00:00"
#> [232] "2015-11-16T01:00:00" "2016-02-16T01:00:00" "2016-05-16T02:00:00"
#> [235] "2016-08-16T02:00:00" "2016-11-16T01:00:00"
#> attr(,"type")
#> temporal_coefficents
```

More detailed metadata requires a further call to the server to a return
an object of class
[`<WCSCoverageSummary>`](https://eblondel.github.io/ows4R/reference/WCSCoverageSummary.html).

You can use
[`emdn_get_coverage_summaries()`](https://emodnet.github.io/emodnet.wcs/reference/emdn_get_coverage_summaries.md)
to get `<WCSCoverageSummary>` objects for specific coverages.

``` r
summaries <- emdn_get_coverage_summaries(
  wcs,
  coverage_ids = "Emodnetbio__aca_spp_19582016_L1"
)

summaries
#> [[1]]
#> <WCSCoverageSummary>
#> ....|-- CoverageId: Emodnetbio__aca_spp_19582016_L1
#> ....|-- CoverageSubtype: RectifiedGridCoverage
#> ....|-- WGS84BoundingBox <OWSWGS84BoundingBox>
#> ........|-- LowerCorner: -75.05 34.95
#> ........|-- UpperCorner: 20.05 75.05
#> ....|-- BoundingBox  [crs=http://www.opengis.net/def/crs/EPSG/0/4326] <OWSBoundingBox>
#> ........|-- LowerCorner: -75.05 34.95
#> ........|-- UpperCorner: 20.05 75.05
```

Alternativelly you can request `<WCSCoverageSummary>` objects for all
coverages available from a service.

``` r
emdn_get_coverage_summaries_all(wcs)
```

Both functions return a list of objects of class `<WCSCoverageSummary>`,
one for each coverage requested / available through the service.

**These objects can then be used to extract individual metadata.**

#### Getting metadata from a `<WCSCoverageSummary>` object.

Once you have obtained a `<WCSCoverageSummary>` object for a coverage
you are interested in, you can extract a number of metadata in more
usable forms.

Let’s work with a single `<WCSCoverageSummary>` object returned in the
previous step for coverage `"Emodnetbio__aca_spp_19582016_L1"`.

``` r
summary <- summaries[[1]]
```

##### Get the bounding box

Get the bounding box (geographic extent) of a coverage. Coordinates are
given in the same Coordinate Reference System as the coverage.

``` r
emdn_get_bbox(summary)
#>   xmin   ymin   xmax   ymax 
#> -75.05  34.95  20.05  75.05
```

##### Get the WGS84 bbox

Get the bounding box (geographic extent) of a coverage in World Geodetic
System 1984 (WGS84) Coordinate Reference System (or EPSG:4326).

``` r
emdn_get_WGS84bbox(summary)
#>   xmin   ymin   xmax   ymax 
#> -75.05  34.95  20.05  75.05
```

##### Get the nil value of a coverage

Get the value representing nil values in a coverage.

``` r
emdn_get_band_nil_values(summary)
#> relative_abundance 
#>        9.96921e+36
```

##### Get coverage band descriptions

Get the band descriptions of a coverage.

``` r
emdn_get_band_descriptions(summary)
#> [1] "relative_abundance"
#> attr(,"uom")
#> [1] "W.m-2.Sr-1"
```

##### Get band units of measurement

Get the units of measurement of the data contained in the bands values
of a coverage.

``` r
emdn_get_band_uom(summary)
#> relative_abundance 
#>       "W.m-2.Sr-1"
```

##### Get range of band values

Get the range of values of the data contained in the bands of the
coverage.

``` r
emdn_get_band_constraints(summary)
#> $relative_abundance
#> [1] -3.402823e+38  3.402823e+38
```

##### Get coverage grid size

Get the grid size of a coverage.

``` r
emdn_get_grid_size(summary)
#> ncol nrow 
#>  951  401
```

##### Get coverage resolution

Get the resolution of a coverage.

``` r
emdn_get_resolution(summary)
#>   x   y 
#> 0.1 0.1 
#> attr(,"uom")
#> [1] "Deg" "Deg"
```

##### Get coverage grid function

Get the grid function of a coverage.

``` r
emdn_get_coverage_function(summary)
#> $sequence_rule
#> [1] "Linear"
#> 
#> $start_point
#> [1] 0 0
#> 
#> $axis_order
#> [1] "+2" "+1"
```

##### Get the extent of the temporal dimension

Get the temporal extent of a coverage.

``` r
emdn_get_temporal_extent(summary)
#> [1] "1958-02-16T01:00:00" "2016-11-16T01:00:00"
```

##### Get the extent of the vertical dimension

Get the vertical (elevation) extent of a coverage.

``` r
emdn_get_vertical_extent(summary)
#> [1] NA
```

##### Get information about coverage dimensions in various formats

Get information on dimensions of a coverage in various formats.
Information includes dimension label, type, unit and range (in tibble
format).

``` r
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
emdn_get_dimensions_info(summary, format = "tibble")
```

| dimension | label | uom | type       | range                                     |
|----------:|-------|-----|------------|-------------------------------------------|
|         1 | lat   | deg | geographic |                                           |
|         2 | long  | deg | geographic |                                           |
|         3 | time  | s   | temporal   | 1958-02-16T01:00:00 - 2016-11-16T01:00:00 |

##### Get dimension names

Get coverage dimension names (labels) and units.

``` r
emdn_get_dimensions_names(summary)
#> [1] "Lat (Deg), Long (Deg), time (s)"
```

##### Get number of dimensions

Get number of coverage dimensions.

``` r
emdn_get_dimensions_n(summary)
#> [1] 3
```

##### Get dimensions types

Get dimensions types of a coverage.

``` r
emdn_get_dimension_types(summary)
#> [1] "geographic" "geographic" "temporal"
```
