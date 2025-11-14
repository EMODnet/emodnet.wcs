# Service and coverage level metadata

Get metadata objects from a `WCSClient` object. `<WCSCoverageSummary>`
in particular can be used to extract further metadata about individual
coverages.

## Usage

``` r
emdn_get_coverage_summaries(wcs, coverage_ids)

emdn_get_coverage_summaries_all(wcs)

emdn_get_coverage_ids(wcs)

emdn_has_dimension(wcs, coverage_ids, type = c("temporal", "vertical"))

emdn_get_coverage_dim_coefs(
  wcs,
  coverage_ids,
  type = c("temporal", "vertical")
)
```

## Arguments

- wcs:

  A `WCSClient` R6 object, created with function
  [`emdn_init_wcs_client`](https://emodnet.github.io/emodnet.wcs/reference/emdn_init_wcs_client.md).

- coverage_ids:

  character vector of coverage IDs.

- type:

  a coverage dimension type. One of `"temporal"` or `"vertical"`.

## Value

- `emdn_get_coverage_summaries`: returns a list of objects of class
  `<WCSCoverageSummary>` for each `coverage_id` provided.

- `emdn_get_coverage_summaries_all`: returns a list of objects of class
  `<WCSCoverageSummary>` for each coverage avalable through the service.

- `emdn_get_coverage_ids` returns a character vector of coverage ids.

- `emdn_get_coverage_dim_coefs` returns a list containing a vector of
  coefficients for each coverage requested.

a list containing a vector of coefficients for each coverage requested.

## Functions

- `emdn_get_coverage_summaries()`: Get summaries for specific coverages.

- `emdn_get_coverage_summaries_all()`: Get summaries for all available
  coverages from a service.

- `emdn_get_coverage_ids()`: Get coverage IDs for all available
  coverages from a service.

- `emdn_has_dimension()`: check whether a coverage has a temporal or
  vertical dimension.

- `emdn_get_coverage_dim_coefs()`: Get temporal or vertical coefficients
  for a coverage.

## Examples

``` r
if (FALSE) { # \dontrun{
wcs <- emdn_init_wcs_client(service = "biology")
cov_ids <- emdn_get_coverage_ids(wcs)
cov_ids
emdn_has_dimension(wcs,
  cov_ids,
  type = "temporal"
)
emdn_has_dimension(wcs,
  cov_ids,
  type = "vertical"
)
emdn_get_coverage_summaries(wcs, cov_ids[1:2])
emdn_get_coverage_summaries_all(wcs)
emdn_get_coverage_dim_coefs(wcs,
  cov_ids[1:2],
  type = "temporal"
)
} # }
```
