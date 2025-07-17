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
  expect_identical(
    validate_bbox(c(
      xmin = -180.0,
      ymin = -90.000000000036,
      xmax = 180.000000000072,
      ymax = 90.0
    )),
    structure(
      c(
        -180.0,
        -90.000000000036,
        180.000000000072,
        90.0
      ),
      .Dim = c(2L, 2L),
      .Dimnames = list(
        c("x", "y"),
        c("min", "max")
      )
    )
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
    ),
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
  wcs <- create_biology_wcs()
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
  summary <- create_biology_summary()[[1L]]
  withr::local_options(emodnet.wcs.quiet = FALSE)
  with_mock_dir("biology-description", {
    coverage_id <- "Emodnetbio__ratio_large_to_small_19582016_L1_err"

    expect_invisible(validate_rangesubset(summary, "relative_abundance"))

    expect_snapshot(
      error = TRUE,
      validate_rangesubset(summary, "erroneous_rangetype")
    )
  })
})
