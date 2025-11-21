#' Download data (coverage)
#'
#' Get a coverage from an EMODnet WCS Service
#'
#' @inheritParams emdn_get_coverage_info
#' @param coverage_id character string. Coverage ID. Inspect your
#' `wcs` object for available coverages.
#' @param bbox a named numeric vector of length 4, with names `xmin`, `ymin`,
#' `xmax` and `ymax`, specifying the bounding box
#' (extent) of the raster to be returned. Can also be an object that
#' can be coerced to a `bbox` object with [sf::st_bbox()].
#' @param crs the CRS of the supplied bounding box
#' (EPSG prefixed code, or URI/URN).
#' Defaults to `"EPSG:4326"`. It will be ignored when the CRS is already
#' defined for argument `bbox`.
#' @param time for coverages that include a temporal dimension,
#' a vector of temporal coefficients specifying the
#' time points for which coverage data should be returned.
#' If `NULL` (default), the last time point is returned.
#' To get a list of all available temporal coefficients,
#' see [`emdn_get_coverage_dim_coefs`]. For a single time point, a
#' `SpatRaster` is returned. For more than one time points, `SpatRaster` stack
#' is returned.
#' @param elevation for coverages that include a vertical dimension,
#' a vector of vertical coefficients specifying the
#' elevation for which coverage data should be returned.
#' If `NULL` (default), the last elevation is returned.
#' To get a list of all available vertical coefficients,
#' see [`emdn_get_coverage_dim_coefs`]. For a single elevation, a
#' `SpatRaster` is returned. For more than one elevation, `SpatRaster` stack
#' is returned.
#' @param format the format of the file the coverage should be written out to.
#' @param rangesubset character vector of band descriptions to subset.
#' @param filename the file name to write to.
#' @param nil_values_as_na logical. Should raster nil values be converted to `NA`?
#'
#' @return an object of class [`terra::SpatRaster`]. The function also
#' writes the coverage to a local file.
#' @export
#'
#' @examples
#' \dontrun{
#' wcs <- emdn_init_wcs_client(service = "biology")
#' coverage_id <- "Emodnetbio__cal_fin_19582016_L1_err"
#' # Subset using a bounding box
#' emdn_get_coverage(wcs,
#'   coverage_id = coverage_id,
#'   bbox = c(
#'     xmin = 0, ymin = 40,
#'     xmax = 5, ymax = 45
#'   )
#' )
#' # Subset using a bounding box and specific timepoints
#' emdn_get_coverage(wcs,
#'   coverage_id = coverage_id,
#'   bbox = c(
#'     xmin = 0, ymin = 40,
#'     xmax = 5, ymax = 45
#'   ),
#'   time = c(
#'     "1963-11-16T00:00:00.000Z",
#'     "1964-02-16T00:00:00.000Z"
#'   )
#' )
#' # Subset using a bounding box and a specific band
#' emdn_get_coverage(wcs,
#'   coverage_id = coverage_id,
#'   bbox = c(
#'     xmin = 0, ymin = 40,
#'     xmax = 5, ymax = 45
#'   ),
#'   rangesubset = "Relative abundance"
#' )
#' }
emdn_get_coverage <- function(
  wcs = NULL,
  service = NULL,
  coverage_id, # nolint: function_argument_linter
  service_version = c(
    "2.0.1",
    "2.1.0",
    "2.0.0",
    "1.1.1",
    "1.1.0"
  ),
  logger = c("NONE", "INFO", "DEBUG"),
  bbox = NULL,
  crs = "EPSG:4326",
  time = NULL,
  elevation = NULL,
  format = NULL,
  rangesubset = NULL,
  filename = NULL,
  nil_values_as_na = FALSE
) {
  check_one_present(wcs, service)
  wcs <- wcs %||% emdn_init_wcs_client(service, service_version, logger)

  check_wcs(wcs)
  check_wcs_version(wcs)

  checkmate::assert_character(coverage_id, len = 1L)
  check_coverages(wcs, coverage_id)

  validate_bbox(bbox)
  coverage_crs <- emdn_get_coverage_info(wcs, coverage_ids = coverage_id)[[
    "crs"
  ]]

  if (crs != coverage_crs) {
    user_bbox <- sf::st_as_sfc(sf::st_bbox(bbox))
    if (is.na(sf::st_crs(user_bbox))) {
      sf::st_crs(user_bbox) <- crs
    }
    bbox <- user_bbox |>
      sf::st_transform(crs = coverage_crs) |>
      sf::st_bbox()
  }

  # validate request arguments
  summary <- emdn_get_coverage_summaries(wcs, coverage_id)[[1L]]
  if (!is.null(rangesubset)) {
    validate_rangesubset(summary, rangesubset)
    rangesubset_encoded <- utils::URLencode(rangesubset) |>
      paste(collapse = ",")
  } else {
    rangesubset_encoded <- NULL
    rangesubset <- emdn_get_band_descriptions(summary)
  }

  if (!is.null(time)) {
    validate_dimension_subset(
      wcs,
      coverage_id,
      subset = time,
      type = "temporal"
    )
  }
  if (!is.null(elevation)) {
    validate_dimension_subset(
      wcs,
      coverage_id,
      subset = elevation,
      type = "vertical"
    )
  }

  cli_rule(left = "Downloading coverage {.val {coverage_id}}")
  coverage_id <- validate_namespace(coverage_id)

  if (!is.null(bbox)) {
    ows_bbox <- ows4R::OWSUtils$toBBOX(
      xmin = bbox["xmin"],
      xmax = bbox["xmax"],
      ymin = bbox["ymin"],
      ymax = bbox["ymax"]
    )
  }

  if (length(time) > 1L || length(elevation) > 1L) {
    cov_raster <- try(
      suppressWarnings(summary$getCoverageStack(
        bbox = ows_bbox,
        crs = crs,
        time = time,
        format = format,
        rangesubset = rangesubset_encoded,
        filename = filename
      )),
      silent = TRUE
    )
    if (inherits(cov_raster, "try-error")) {
      # better to extract filename, so it exists
      filename <- trimws(sub(".* SpatRaster: ", "", as.character(cov_raster)))
      no_data <- any(grepl(
        "Empty intersection after subsetting",
        readLines(filename)
      ))
      if (no_data) {
        cli::cli_warn("Can't find any data in the {.arg bbox}.")
        return(NULL)
      } else {
        # error we don't know about
        cli::cli_abort(cov_raster)
      }
    }

    cli_alert_success(
      "\n Coverage {.val {coverage_id}} downloaded succesfully as a
        {.pkg terra} {.cls SpatRaster} Stack"
    )
  } else {
    # https://github.com/eblondel/ows4R/issues/151
    cov_raster <- try(
      suppressWarnings(summary$getCoverage(
        bbox = ows_bbox,
        crs = crs,
        time = time,
        elevation = elevation,
        format = format,
        rangesubset = rangesubset_encoded,
        filename = filename
      )),
      silent = TRUE
    )

    if (inherits(cov_raster, "try-error")) {
      filename <- trimws(sub(".* SpatRaster: ", "", as.character(cov_raster)))
      no_data <- any(grepl(
        "Empty intersection after subsetting",
        readLines(filename)
      ))
      if (no_data) {
        cli::cli_warn("Can't find any data in the {.arg bbox}.")
        return(NULL)
      } else {
        # error we don't know about
        cli::cli_abort(cov_raster)
      }
    }

    cli_alert_success(
      "\n Coverage {.val {coverage_id}} downloaded succesfully as a
        {.pkg terra} {.cls SpatRaster}"
    )
  }

  if (nil_values_as_na) {
    # convert nil_values to NA
    cov_raster <- conv_nil_to_na(
      cov_raster,
      summary,
      rangesubset
    )
  }

  cov_raster
}

# Convert coverage nil values to NA
conv_nil_to_na <- function(cov_raster, summary, rangesubset) {
  nil_values <- emdn_get_band_nil_values(summary)[rangesubset]
  uniq_nil_val <- unique(nil_values)

  # For efficiency, replace nil_values across entire coverage if all bands have
  # the same nil_values. Return early.
  if (length(uniq_nil_val) == 1L) {
    if (is.numeric(uniq_nil_val)) {
      terra::values(cov_raster)[
        terra::values(cov_raster) >= uniq_nil_val
      ] <- NA

      cli_alert_success(
        "nil values {.val {uniq_nil_val}} converted to {.field NA} on all bands."
      )
    } else {
      cli::cli_warn(
        "!" = "Cannot convert non numeric nil value {.val {uniq_nil_val}} to NA"
      )
    }
    return(cov_raster)
  }

  # If nil_values differ between bands, replace nil_values individually.
  n_bands <- terra::nlyr(cov_raster)
  nil_values <- rep(nil_values, times = n_bands / length(nil_values))

  for (band_idx in seq_len(n_bands)) {
    nil_value <- nil_values[[band_idx]]
    band_name <- names(nil_values)[band_idx]

    if (is.numeric(nil_value)) {
      cov_raster[[band_idx]][cov_raster[[band_idx]] >= nil_value] <- NA

      cli_alert_success(
        "nil values {.val {nil_value}} converted to
        {.field NA} on band {.val {band_name}}"
      )
    } else {
      cli::cli_warn(
        "!" = "Cannot convert non numeric nil value {.val {nil_value}} to NA
          on band {.val {band_name}}"
      )
    }
  }

  cov_raster
}
