test_that("validate_namespace works", {
  expect_identical(
    validate_namespace("emodnet:2018_st_All_avg_POSTER"),
    "emodnet__2018_st_All_avg_POSTER"
  )

  expect_identical(
    validate_namespace("emodnet__2018_st_All_avg_POSTER"),
    "emodnet__2018_st_All_avg_POSTER"
  )
})

test_that("validate_bbox works", {
  expect_true(
    validate_bbox(c(
      xmin = -180.0,
      ymin = -90.000000000036,
      xmax = 180.000000000072,
      ymax = 90.0
    ))
  )

  expect_snapshot(
    error = TRUE,
    validate_bbox(
      c(
        xmin = -90.000000000036,
        ymin = -180.0,
        xmax = -180.000000000072,
        ymax = 90.0
      )
    )
  )

  expect_snapshot(
    error = TRUE,
    validate_bbox(
      c(
        xmin = -90.000000000036,
        ymin = -180.0,
        ymax = 90.0
      )
    )
  )

  expect_snapshot(
    error = TRUE,
    validate_bbox(
      c(
        xmin = -180.0,
        ymin = -90.000000000036,
        xmax = 180.000000000072,
        ymax = "90"
      )
    )
  )

  expect_snapshot(error = TRUE, validate_bbox(NA))

  expect_null(validate_bbox(NULL))
})

test_that("check bbox works", {
  expect_identical(error_wrap(stop(., call. = FALSE)), NA)
  expect_identical(error_wrap(NULL), NA)
  expect_identical(error_wrap("success"), "success")
})


test_that("error wrap works", {
  expect_identical(error_wrap(stop(., call. = FALSE)), NA)
  expect_identical(error_wrap(NULL), NA)
  expect_identical(error_wrap("success"), "success")
})


test_that("check coverages works", {
  vcr::local_cassette("biology")

  wcs <- emdn_init_wcs_client("biology")
  coverage_ids <- c(
    "Emodnetbio__ratio_large_to_small_19582016_L1_err",
    "Emodnetbio__aca_spp_19582016_L1",
    "Emodnetbio__cal_fin_19582016_L1_err",
    "Emodnetbio__cal_hel_19582016_L1_err"
  )

  expect_invisible(check_coverages(wcs, coverage_ids))
  expect_snapshot(error = TRUE, check_coverages(wcs, "erroneous_id"))
})

test_that("validate rangesubset works", {
  withr::local_options(emodnet.wcs.quiet = FALSE)
  vcr::local_cassette("biology-description")

  summary <- emdn_init_wcs_client("biology") |>
    emdn_get_coverage_summaries(
      coverage_ids = "Emodnetbio__ratio_large_to_small_19582016_L1_err"
    )

  expect_invisible(validate_rangesubset(summary[[1]], "Relative abundance"))

  expect_snapshot(
    error = TRUE,
    validate_rangesubset(summary[[1]], "erroneous_rangetype")
  )
})

test_that("check_cov_contains_bbox() works", {
  withr::local_options(emodnet.wcs.quiet = FALSE)
  vcr::local_cassette("cov-checks")

  wcs <- emdn_init_wcs_client(service = "biology")
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
  expect_s4_class(cov, "SpatRaster")

  expect_snapshot(
    error = TRUE,
    {
      cov <- emdn_get_coverage(
        wcs,
        coverage_id = coverage_id,
        bbox = c(
          xmin = -80.0,
          ymin = 76.0,
          xmax = -79.0,
          ymax = 77.0
        )
      )
    }
  )
})


test_that("check_cov_contains_bbox() works -- user supplied bbox with crs", {
  # https://github.com/EMODnet/emodnet.wcs/issues/95
  withr::local_options(emodnet.wcs.quiet = FALSE)
  vcr::local_cassette("cov-checks2")

  wcs <- emdn_init_wcs_client(service = "human_activities")
  coverage_id <- "Emodnetbio__cal_fin_19582016_L1_err"

  cov <- emdn_get_coverage(
    wcs,
    # pseudomercator (EPSG 3857) in this case:
    crs = "EPSG:3857",
    bbox = c(
      xmin = 484177.9,
      ymin = 6957617.3,
      xmax = 1035747,
      ymax = 7308616.2
    ),
    coverage_id = "emodnet__vesseldensity_all",
    nil_values_as_na = FALSE
  )
  expect_s4_class(cov, "SpatRaster")
})
