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
