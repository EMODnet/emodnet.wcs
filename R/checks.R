check_service_name <- function(service) {
  checkmate::assert_choice(service, emdn_wcs()$service_name)
}

check_wcs <- function(wcs) {
  checkmate::assertR6(
    wcs,
    classes = c("WCSClient", "OWSClient", "OGCAbstractObject", "R6")
  )
}

check_wcs_version <- function(wcs) {
  if (
    get_service_name(wcs$getUrl()) == "human_activities" &&
      wcs$getVersion() != "2.0.1"
  ) {
    cli::cli_warn(c(
      "!" = "Service version {.val {wcs$getVersion()}}
            can result in unexpected  behaviour on the
            {.val human activities} server.
            We strongly recommend reconnecting using {.var service_version}
            {.val 2.0.1}."
    ))
  } else {
    supported_versions <- wcs$getCapabilities()$getServiceIdentification()$getServiceTypeVersion()

    version <- wcs$getVersion()

    if (!checkmate::test_choice(version, supported_versions)) {
      cli::cli_warn(c(
        "!" = "Service version {.val {version}} not  supported by server
                            and can result in unexpected behaviour.",
        "We strongly recommend reconnecting using one of the
                            supported versions: ",
        "{.val {supported_versions}}"
      ))
    }
  }
}

has_internet <- function() {
  curl::has_internet()
}

# Checks if there is internet connection and HTTP status of the service
check_service <- function(service_url) {
  message <- c(
    "WCS client creation failed.",
    i = "Service: {.val {service_url}}"
  )

  is_monitor_up <- !is.null(curl::nslookup(
    "monitor.emodnet.eu",
    error = FALSE
  ))
  if (rlang::is_interactive() && is_monitor_up) {
    message <- c(
      message,
      i = "Browse the EMODnet OGC monitor for more info on
         the status of the services by visiting
         {.url https://monitor.emodnet.eu/resources?lang=en&resource_type=OGC:WCS}"
    )
  }

  request <- service_url |>
    httr2::request() |>
    httr2::req_url_query(request = "GetCapabilities") |>
    httr2::req_perform()

  if (httr2::resp_status(request) != 200) {
    message <- c(
      message,
      "HTTP Status: {httr2::resp_status(request)} ({httr2::resp_status_desc(request)})."
    )
    # Something else is wrong
  } else {
    message <- c(
      message,
      "You could raise an issue in {.url {packageDescription('emodnet.wcs')$BugReports}}"
    )
  }

  cli::cli_abort(message)
}

check_coverages <- function(wcs, coverages) {
  checkmate::assert_character(coverages)
  test_coverages <- coverages %in% emdn_get_coverage_ids(wcs)

  if (!all(test_coverages)) {
    bad_coverages <- coverages[!test_coverages]
    cli::cli_abort(
      "{.val {bad_coverages}} not valid coverage{?s}
      for service {.url {wcs$getUrl()}}"
    )
  }
}

check_cov_contains_bbox <- function(summary, bbox, crs) {
  if (is.null(bbox)) {
    return()
  }

  cov_bbox <- emdn_get_WGS84bbox(summary) |>
    sf::st_as_sfc(crs = "WGS84")

  if (is.null(crs)) {
    message <- sprintf(
      "The coverage crs is %s. You can supply the crs of your bbox through {.arg crs}.",
      sf::st_crs(cov_bbox)[["input"]]
    )
    cli_alert_info(message)
  }

  # crs is NULL if it's the same as the coverage crs
  user_supplied_crs <- crs
  crs <- crs %||% sf::st_crs(cov_bbox)

  user_bbox <- sf::st_as_sfc(sf::st_bbox(bbox))
  sf::st_crs(user_bbox) <- crs
  user_bbox <- sf::st_as_sfc(sf::st_bbox(user_bbox)) |>
    sf::st_transform(crs = sf::st_crs(cov_bbox)) # cov_bbox can be the same

  if (!s2_intersects(user_bbox, cov_bbox)) {
    message <-
      "{.var bbox} boundaries lie outside coverage extent.
      No overlapping data to download."
    if (is.null(user_supplied_crs)) {
      message <- c(
        message,
        i = sprintf(
          "The coverage crs is %s. You can supply the crs of your bbox through {.arg crs}.",
          sf::st_crs(cov_bbox)[["input"]]
        )
      )
    }
    cli::cli_abort(message)
  }
}

s2_intersects <- function(bbox1, bbox2) {
  current <- sf::sf_use_s2()
  suppressMessages(sf::sf_use_s2(TRUE))
  on.exit(suppressMessages(sf::sf_use_s2(current)))
  isTRUE(as.logical(sf::st_intersects(bbox1, bbox2)))
}

# ---- validations ----
validate_namespace <- function(coverage_id) {
  gsub(":", "__", coverage_id, fixed = TRUE)
}

validate_bbox <- function(bbox) {
  if (is.null(bbox)) {
    return(bbox)
  }
  checkmate::assert_numeric(
    bbox,
    len = 4L,
    any.missing = FALSE,
    names = "named"
  )
  checkmate::assert_subset(
    names(bbox),
    choices = c(
      "xmin",
      "xmax",
      "ymin",
      "ymax"
    )
  )

  checkmate::assert_true(bbox["ymin"] < bbox["ymax"])
  checkmate::assert_true(bbox["xmin"] < bbox["xmax"])
}

validate_rangesubset <- function(summary, rangesubset) {
  cov_range_descriptions <- emdn_get_band_descriptions(summary)
  purrr::walk(
    rangesubset,
    checkmate::assert_choice,
    choices = cov_range_descriptions,
    .var.name = "rangesubset"
  )
}

validate_dimension_subset <- function(
  wcs,
  coverage_id,
  subset,
  type = c(
    "temporal",
    "vertical"
  )
) {
  type <- match.arg(type)
  coefs <- emdn_get_coverage_dim_coefs(
    wcs,
    coverage_id,
    type
  )[[1L]]

  switch(
    type,
    temporal = {
      purrr::walk(
        subset,
        checkmate::assert_choice,
        choices = coefs,
        .var.name = "time"
      )
    },
    vertical = {
      purrr::walk(
        subset,
        checkmate::assert_choice,
        choices = coefs,
        .var.name = "elevation"
      )
    }
  )
}

# ---- error-handling ----
error_wrap <- function(expr) {
  out <- tryCatch(expr, error = function(e) NA)

  if (is.null(out)) {
    cli_alert_warning(
      c(
        "Output of {.code {cli::col_cyan(rlang::enexpr(expr))}} ",
        "is {.emph {cli::col_br_magenta('NULL')}}.",
        " Returning {.emph {cli::col_br_magenta('NA')}}"
      )
    )
    return(NA)
  }
  if (is.na(out)) {
    cli_alert_warning(
      c(
        "Error in {.code {cli::col_cyan(rlang::enexpr(expr))}}",
        " Returning {.emph {cli::col_br_magenta('NA')}}"
      )
    )
  }

  out
}
