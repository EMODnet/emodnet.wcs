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
  } else {
    ows_bbox <- NULL
  }

  if (length(time) > 1L || length(elevation) > 1L) {
    cov_try <- try(
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
    cov_raster <- extract_coverage_resp(cov_try, type = "Stack", coverage_id)
  } else {
    # https://github.com/eblondel/ows4R/issues/151
    cov_try <- try(
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
    cov_raster <- extract_coverage_resp(cov_try, type = "", coverage_id)
  }

  no_data <- is.null(cov_raster)
  if (no_data) {
    return(cov_raster)
  }

  if (nil_values_as_na) {
    # convert nil_values to NA
    cov_raster <- conv_nil_to_na(
      cov_raster,
      summary,
      rangesubset
    )
  }

  one_band_only <- (length(rangesubset) == 1)
  if (one_band_only) {
    names(cov_raster) <- paste(
      names(cov_raster),
      kebabcase(rangesubset),
      sep = "_"
    )
    return(cov_raster)
  }
  layer_numbers <- unique(sub(".*_([0-9]+)$", "\\1", names(cov_raster)))
  if (length(layer_numbers) != length(rangesubset)) {
    cli::cli_abort(
      "Can't identify received ranges. Please open an issue."
    )
  }

  cov_raster <- purrr::reduce(
    layer_numbers,
    \(cov_raster, number, bands = rangesubset) {
      pattern <- sprintf("_%s$", number)
      bands <- kebabcase(bands)
      names(cov_raster) <- gsub(
        pattern,
        sprintf("_%s", bands[as.numeric(number)]),
        names(cov_raster)
      )
      cov_raster
    },
    .init = cov_raster
  )
}

# Convert coverage nil values to NA
conv_nil_to_na <- function(cov_raster, summary, rangesubset) {
  purrr::reduce(
    emdn_get_band_descriptions(summary),
    \(cov_raster, x) {
      conv_band_nil_value(
        x,
        cov_raster,
        summary = summary,
        rangesubset = rangesubset
      )
    },
    .init = cov_raster
  )
}

conv_band_nil_value <- function(field, cov_raster, summary, rangesubset) {
  nil_val <- emdn_get_band_nil_values(summary, field)[rangesubset]

  band_idx <- which(emdn_get_band_descriptions(summary) == field)

  if (is.nan(nil_val)) {
    terra::values(cov_raster[[band_idx]])[is.nan(terra::values(cov_raster[[
      band_idx
    ]]))] <- NA
    cli_alert_success(
      "nil values {.val NaN} converted to {.field NA} on {.field} band."
    )
    return(cov_raster)
  }

  if (is.numeric(nil_val)) {
    terra::values(cov_raster[[band_idx]])[
      terra::values(cov_raster[[band_idx]]) >= nil_val
    ] <- NA
    cli_alert_success(
      "nil values {.val {uniq_nil_val}} converted to {.field NA} on {.field} band."
    )
    return(cov_raster)
  }

  cli::cli_warn(
    "!" = "Cannot convert non numeric nil value {.val {nil_val}} to NA."
  )
  return(cov_raster)
}

extract_coverage_resp <- function(cov_try, type, coverage_id) {
  if (inherits(cov_try, "try-error")) {
    cli::cli_abort(cov_try)
  }

  if (inherits(cov_try, "SpatRaster")) {
    cli_alert_success(
      "Coverage {.val {coverage_id}} downloaded succesfully as a
        {.pkg terra} {.cls SpatRaster} {type}."
    )
    return(cov_try)
  }

  if (is.null(cov_try)) {
    cli::cli_warn("Can't find any data in the {.arg bbox}.")
    return(NULL)
  }

  # at this stage why wouldn't it be an exception though
  is_exception <- inherits(cov_try, "OWSException")

  if (is_exception) {
    no_data <- (cov_try$getText() == "Empty intersection after subsetting")
    if (no_data) {
      cli::cli_warn("Can't find any data in the {.arg bbox}.")
      NULL
    } else {
      # error we don't know about
      cli::cli_abort(cov_try$getText())
    }
  }
}

kebabcase <- function(x) {
  tolower(gsub("[^a-zA-Z0-9]+", "-", x))
}
