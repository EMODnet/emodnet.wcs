test_that("extract_coverage_resp() emits success message", {
  local_test_context()
  withr::local_options(emodnet.wcs.quiet = FALSE)
  mock_raster <- terra::rast(nrows = 10, ncols = 10)

  expect_snapshot(
    result <- extract_coverage_resp(
      mock_raster,
      type = "",
      coverage_id = "test__coverage"
    )
  )
  expect_s4_class(result, "SpatRaster")
})

test_that("emdn_get_coverage() works", {
  vcr::local_cassette("vessels")

  wcs <- emdn_init_wcs_client(service = "human_activities")
  coverage_id <- "emodnet__vesseldensity_all"

  cov <- emdn_get_coverage(
    wcs,
    coverage_id = coverage_id,
    bbox = c(xmin = 4.2, ymin = 53, xmax = 8.8, ymax = 54)
  )
  expect_s4_class(cov, "SpatRaster")

  expect_snapshot(
    cov <- emdn_get_coverage(
      wcs,
      coverage_id = coverage_id,
      bbox = c(xmin = -120, ymin = -19, xmax = -119, ymax = -18)
    )
  )
})

test_that("emdn_get_coverage() works, crs already set", {
  vcr::local_cassette("vessels-crs")

  wcs <- emdn_init_wcs_client(service = "human_activities")
  coverage_id <- "emodnet__vesseldensity_all"

  cov <- emdn_get_coverage(
    wcs,
    coverage_id = coverage_id,
    bbox = sf::st_bbox(
      c(xmin = 484177.9, ymin = 6957617.3, xmax = 1035747, ymax = 7308616.2),
      crs = 3857
    )
  )
  expect_s4_class(cov, "SpatRaster")
})

test_that("emdn_get_coverage() works -- stack", {
  vcr::local_cassette("biology-stack")
  wcs <- emdn_init_wcs_client(service = "biology")
  coverage_id <- "Emodnetbio__cal_fin_19582016_L1_err"

  cov <- emdn_get_coverage(
    wcs,
    coverage_id = coverage_id,
    bbox = c(
      xmin = 0,
      ymin = 40,
      xmax = 5,
      ymax = 45
    ),
    time = c(
      "1958-02-16T01:00:00",
      "1962-11-16T01:00:00"
    )
  )
  expect_s4_class(cov, "SpatRaster")
  expect_setequal(
    names(cov),
    c(
      "Emodnetbio__cal_fin_19582016_L1_err_1958-02-16T01_00_00_40,0,45,5_relative-abundance",
      "Emodnetbio__cal_fin_19582016_L1_err_1958-02-16T01_00_00_40,0,45,5_relative-error",
      "Emodnetbio__cal_fin_19582016_L1_err_1962-11-16T01_00_00_40,0,45,5_relative-abundance",
      "Emodnetbio__cal_fin_19582016_L1_err_1962-11-16T01_00_00_40,0,45,5_relative-error"
    )
  )

  expect_snapshot(
    emdn_get_coverage(
      wcs,
      coverage_id = coverage_id,
      bbox = c(
        xmin = -10,
        ymin = 0,
        xmax = -5,
        ymax = 1
      ),
      time = c(
        "1958-02-16T01:00:00",
        "1962-11-16T01:00:00"
      )
    )
  )
})

test_that("`nil_values_as_na = TRUE` converts NaN nil values to NA", {
  # https://github.com/EMODnet/emodnet.wcs/issues/121
  vcr::local_cassette("nil-values")

  hab_wcs <- emdn_init_wcs_client(service = "seabed_habitats")
  coverage_id <- "emodnet_open_maplibrary__GB000050_EFH_Whiting_SpawningGrounds"
  test_bbox <- c(xmin = 0, ymin = 55, xmax = 2, ymax = 57)

  # no conversion
  summary <- emdn_get_coverage_summaries(hab_wcs, coverage_id)[[1]]
  expect_equal(emdn_get_band_nil_values(summary), c(GRAY_INDEX = NaN))

  # conversion
  expect_snapshot(
    r <- emdn_get_coverage(
      wcs = hab_wcs,
      coverage_id = coverage_id,
      bbox = test_bbox,
      nil_values_as_na = TRUE
    )
  )
  expect_equal(sum(is.nan(terra::values(r))), 0)
})
