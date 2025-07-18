.emdn_get_wcs_info <- function(
  wcs = NULL,
  service = NULL,
  service_version = c(
    "2.0.1",
    "2.1.0",
    "2.0.0",
    "1.1.1",
    "1.1.0"
  ),
  logger = c("NONE", "INFO", "DEBUG")
) {
  if (is.null(wcs) && is.null(service)) {
    cli::cli_abort(c(
      x = "Please provide a valid {.var service}
        name or {.cls WCSClient} object to {.var wcs}.
        Both cannot be {.val NULL}"
    ))
  }

  if (is.null(wcs)) {
    wcs <- emdn_init_wcs_client(service, service_version, logger)
  }

  check_wcs(wcs)
  check_wcs_version(wcs)

  capabilities <- wcs$getCapabilities()
  service_id <- capabilities$getServiceIdentification()
  summaries <- capabilities$getCoverageSummaries()

  list(
    data_source = "emodnet_wcs",
    service_name = get_service_name(capabilities$getUrl()),
    service_url = capabilities$getUrl(),
    service_title = service_id$getTitle(),
    service_abstract = service_id$getAbstract(),
    service_access_constraits = service_id$getAccessConstraints(),
    service_fees = service_id$getFees(),
    service_type = service_id$getServiceType(),
    coverage_details = tibble::tibble(
      coverage_id = purrr::map_chr(
        summaries,
        ~ error_wrap(.x$getId())
      ),
      dim_n = purrr::map_int(
        summaries,
        ~ error_wrap(length(.x$getDimensions()))
      ),
      dim_names = purrr::map_chr(
        summaries,
        ~ error_wrap(emdn_get_dimensions_info(.x, format = "character"))
      ),
      extent = purrr::map_chr(
        summaries,
        ~ error_wrap(emdn_get_bbox(.x) |> conc_bbox())
      ),
      crs = purrr::map_chr(
        summaries,
        ~ error_wrap(extr_bbox_crs(.x)$input)
      ),
      wgs84_bbox = purrr::map_chr(
        summaries,
        ~ error_wrap(emdn_get_WGS84bbox(.x) |> conc_bbox())
      ),
      temporal_extent = purrr::map_chr(
        summaries,
        ~ error_wrap(
          emdn_get_temporal_extent(.x) |>
            paste(collapse = " - ")
        )
      ),
      vertical_extent = purrr::map_chr(
        summaries,
        ~ error_wrap(
          emdn_get_vertical_extent(.x) |>
            paste(collapse = " - ")
        )
      ),
      subtype = purrr::map_chr(
        summaries,
        ~ error_wrap(.x$CoverageSubtype)
      )
    )
  )
}

#' Get EMODnet WCS service and available coverage information.
#'
#' @param wcs A `WCSClient` R6 object, created with function [`emdn_init_wcs_client`].
#' @inheritParams emdn_init_wcs_client
#' @importFrom rlang .data `%||%`
#' @return `emdn_get_wcs_info` & `emdn_get_wcs_info` return a list of service
#' level metadata, including a tibble containing coverage level metadata for each
#' coverage available from the service. `emdn_get_coverage_info` returns a list
#' containing a tibble of more detailed metadata for each coverage specified.
#'
#' ## `emdn_get_wcs_info` / `emdn_get_wcs_info_all`
#'
#' `emdn_get_wcs_info` and `emdn_get_wcs_info_all` return a list with the
#' following metadata:
#' - **`data_source`:** the EMODnet source of data.
#' - **`service_name`:** the EMODnet WCS service name.
#' - **`service_url`:** the EMODnet WCS service URL.
#' - **`service_title`:** the EMODnet WCS service title.
#' - **`service_abstract`:** the EMODnet WCS service abstract.
#' - **`service_access_constraits`:** any access constraints associated with the EMODnet WCS service.
#' - **`service_fees`:** any access fees associated with the EMODnet WCS service.
#' - **`service_type`:** the EMODnet WCS service type.
#' - **`coverage_details`:** a tibble of details of each coverage available through EMODnet WCS service:
#'   - **`coverage_id`:** the coverage ID.
#'   - **`dim_n`:** the number of coverage dimensions
#'   - **`dim_names`:** the coverage dimension names, units (in brackets) and types.
#'   - **`extent`:** the coverage extent (`xmin`, `ymin`, `xmax` and `ymax`).
#'   - **`crs`:** the coverage CRS (Coordinate Reference System).
#'   - **`wgs84_bbox`:** the coverage extent (`xmin`, `ymin`, `xmax` and `ymax`)
#'   in WGS84 (EPSG:4326) CRS coordinates.
#'   - **`temporal_extent`:** the coverage temporal extent (`min` - `max`), `NA` if coverage
#'   contains no temporal dimension.
#'   - **`vertical_extent`:** the coverage vertical extent (`min` - `max`), `NA` if coverage
#'   contains no vertical dimension.
#'   - **`subtype`:** the coverage subtype.
#'
#' ## `emdn_get_coverage_info`
#'
#' `emdn_get_coverage_info` returns a tibble with a row for each coverage
#' specified and columns with the following details:
#' - **`data_source`:** the EMODnet source of data.
#' - **`service_name`:** the EMODnet WCS service name.
#' - **`service_url`:** the EMODnet WCS service URL.
#' - **`coverage_ids`:** the coverage ID.
#' - **`band_description`:** the description of the data contained each band of the coverage.
#' - **`band_uom`:** the unit of measurement of the data contained each band of the coverage.
#' If all bands share the same unit of measurement, the single shared uom is shown.
#' - **`constraint`:** the range of values of the data contained in each band of the coverage.
#' If all bands share the same constraint, the single shared constraint range is shown.
#' - **`nil_value`:** the nil values of the data contained each band of the coverage.
#' If all bands share the same nil value, the single shared nil value is shown.
#' - **`grid_size`:** the spatial size of the coverage grid (ncol x nrow).
#' - **`resolution`:** the spatial resolution (pixel size) of the coverage grid
#' in the CRS units of measurement (size in the `x` dimension x size in the `y` dimension).
#' - **`dim_n`:** the number of coverage dimensions
#' - **`dim_names`:** the coverage dimension names, units (in brackets) and types.
#' - **`extent`:** the coverage extent (`xmin`, `ymin`, `xmax` and `ymax`).
#' - **`crs`:** the coverage CRS (Coordinate Reference System).
#' - **`wgs84_bbox`:** the coverage extent (`xmin`, `ymin`, `xmax` and `ymax`)
#'   in WGS84 (EPSG:4326) CRS coordinates.
#' - **`temporal_extent`:** the coverage temporal extent (`min` - `max`), `NA` if coverage
#'   contains no temporal dimension.
#' - **`vertical_extent`:** the coverage vertical extent (`min` - `max`), `NA` if coverage
#'   contains no vertical dimension.
#' - **`subtype`:** the coverage subtype.
#' - **`fn_seq_rule`:** the function describing the sequence rule which specifies
#' the relationship between the axes of data and coordinate system axes.
#' - **`fn_start_point`:** the location of the origin of the data in the coordinate system.
#' - **`fn_axis_order`:** the axis order and
#'   direction of mapping of values onto the grid, beginning at the starting point. For
#'   example, `"+2 +1"` indicates the value range is ordered from the bottom
#'   left to the top right of the grid envelope - lowest to highest in the x-axis
#'   direction first (`+2`), then lowest to highest in the y-axis direction (`+1`)
#'   from the `starting_point`.
#'
#' For additional details on WCS metadata, see the GDAL wiki section on
#' [WCS Basics and GDAL](https://trac.osgeo.org/gdal/wiki/WCS%2Binteroperability)
#'
#' @export
#' @describeIn emdn_get_wcs_info Get info on all coverages from am EMODnet WCS service.
#' @examples
#' \dontrun{
#' # Get information from a wcs object.
#' wcs <- emdn_init_wcs_client(service = "seabed_habitats")
#' emdn_get_wcs_info(wcs)
#' # Get information using a service name.
#' emdn_get_wcs_info(service = "biology")
#' # Get detailed info for specific coverages from wcs object
#' coverage_ids <- c(
#'   "emodnet_open_maplibrary__mediseh_cora",
#'   "emodnet_open_maplibrary__mediseh_posidonia"
#' )
#' emdn_get_coverage_info(
#'   wcs = wcs,
#'   coverage_ids = coverage_ids
#' )
#' }
emdn_get_wcs_info <- memoise::memoise(.emdn_get_wcs_info)


.emdn_get_wcs_info_all <- function(logger = c("NONE", "INFO", "DEBUG")) {
  purrr::map(
    emdn_wcs()$service_name,
    ~ suppressMessages(emdn_get_wcs_info(
      service = .x,
      logger = logger
    ))
  ) |>
    stats::setNames(emdn_wcs()$service_name)
}

#' @describeIn emdn_get_wcs_info Get metadata on all services and all available
#' coverages from each service.
#' @export
emdn_get_wcs_info_all <- memoise::memoise(.emdn_get_wcs_info_all)

.emdn_get_coverage_info <- function(
  wcs = NULL,
  service = NULL,
  coverage_ids, # nolint: function_argument_linter
  service_version = c(
    "2.0.1",
    "2.1.0",
    "2.0.0",
    "1.1.1",
    "1.1.0"
  ),
  logger = c("NONE", "INFO", "DEBUG")
) {
  if (is.null(wcs) && is.null(service)) {
    cli::cli_abort(c(
      x = "Please provide a valid {.var service}
        name or {.cls WCSClient} object to {.var wcs}.
        Both cannot be {.val NULL}"
    ))
  }

  if (is.null(wcs)) {
    wcs <- emdn_init_wcs_client(service, service_version, logger)
  }

  check_wcs(wcs)
  check_wcs_version(wcs)
  check_coverages(wcs, coverage_ids)

  capabilities <- wcs$getCapabilities()

  summaries <- purrr::map(
    validate_namespace(coverage_ids),
    capabilities$findCoverageSummaryById
  ) |>
    unlist(recursive = FALSE)

  tibble::tibble(
    data_source = "emodnet_wcs",
    service_name = wcs$getUrl(),
    service_url = get_service_name(wcs$getUrl()),
    coverage_id = purrr::map_chr(
      summaries,
      ~ error_wrap(.x$getId())
    ),
    band_description = purrr::map_chr(
      summaries,
      ~ error_wrap(
        emdn_get_band_descriptions(.x) |>
          paste(collapse = ", ")
      )
    ),
    band_uom = purrr::map_chr(
      summaries,
      ~ error_wrap(
        emdn_get_band_uom(.x) |>
          conc_band_uom()
      )
    ),
    constraint = purrr::map_chr(
      summaries,
      ~ error_wrap(
        emdn_get_band_constraints(.x) |>
          conc_constraint()
      )
    ),
    nil_value = purrr::map_dbl(
      summaries,
      ~ error_wrap(
        emdn_get_band_nil_values(.x) |>
          conc_nil_value()
      )
    ),
    dim_n = purrr::map_int(
      summaries,
      ~ error_wrap(length(.x$getDimensions()))
    ),
    dim_names = purrr::map_chr(
      summaries,
      ~ error_wrap(
        emdn_get_dimensions_info(.x, format = "character")
      )
    ),
    grid_size = purrr::map_chr(
      summaries,
      ~ error_wrap(
        emdn_get_grid_size(.x) |>
          paste(collapse = "x")
      )
    ),
    resolution = purrr::map_chr(
      summaries,
      ~ error_wrap(
        emdn_get_resolution(.x) |>
          conc_resolution()
      )
    ),
    extent = purrr::map_chr(
      summaries,
      ~ error_wrap(emdn_get_bbox(.x) |> conc_bbox())
    ),
    crs = purrr::map_chr(
      summaries,
      ~ error_wrap(extr_bbox_crs(.x)$input)
    ),
    wgs84_extent = purrr::map_chr(
      summaries,
      ~ error_wrap(emdn_get_WGS84bbox(.x) |> conc_bbox())
    ),
    temporal_extent = purrr::map_chr(
      summaries,
      ~ error_wrap(
        emdn_get_temporal_extent(.x) |>
          paste(collapse = " - ")
      )
    ),
    vertical_extent = purrr::map_chr(
      summaries,
      ~ error_wrap(
        emdn_get_vertical_extent(.x) |>
          paste(collapse = " - ")
      )
    ),
    subtype = purrr::map_chr(
      summaries,
      ~ error_wrap(.x$CoverageSubtype)
    ),
    fn_seq_rule = purrr::map_chr(
      summaries,
      ~ error_wrap(
        emdn_get_coverage_function(.x)$sequence_rule
      )
    ),
    fn_start_point = purrr::map_chr(
      summaries,
      ~ error_wrap(
        emdn_get_coverage_function(.x)$start_point |>
          paste(collapse = ",")
      )
    ),
    fn_axis_order = purrr::map_chr(
      summaries,
      ~ error_wrap(
        emdn_get_coverage_function(.x)$axis_order |>
          paste(collapse = ",")
      )
    )
  )
}

#' @describeIn emdn_get_wcs_info Get metadata for specific coverages. Requires a
#' `WCSClient` R6 object as input.
#' @param coverage_ids character vector of coverage IDs.
#' @inheritParams emdn_get_wcs_info
#' @importFrom memoise memoise
#' @details To minimize the number of requests sent to webservices,
#' these functions use [`memoise`](https://memoise.r-lib.org/) to cache results
#' inside the active R session.
#' To clear the cache, re-start R or run `memoise::forget(emdn_get_wcs_info)`/`memoise::forget(emdn_get_coverage_info)`
#'
#' @export
emdn_get_coverage_info <- memoise::memoise(.emdn_get_coverage_info)
