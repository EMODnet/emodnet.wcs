test_that("Default connection works", {
  vcr::local_cassette("biology")

  wcs <- emdn_init_wcs_client("biology")
  expect_s3_class(
    wcs,
    c("WCSClient", "OWSClient", "OGCAbstractObject", "R6")
  )
  expect_identical(wcs$getUrl(), "https://geo.vliz.be/geoserver/Emodnetbio/wcs")
})

test_that("Error when wrong service", {
  skip_if_offline()
  expect_snapshot(emdn_init_wcs_client("blop"), error = TRUE)
})


test_that("Error when wrong service version", {
  skip_if_offline()
  expect_snapshot(
    emdn_init_wcs_client(
      service = "human_activities",
      service_version = "2.2.2"
    ),
    error = TRUE
  )
})

test_that("Warning when unsupported service version", {
  skip_if_offline()
  withr::local_options(emodnet.wcs.quiet = FALSE)

  expect_snapshot(emdn_init_wcs_client(
    service = "human_activities",
    service_version = "1.1.1"
  ))
})

test_that("No internet handled", {
  testthat::local_mocked_bindings(has_internet = function() FALSE)
  expect_snapshot(emdn_init_wcs_client("biology"), error = TRUE)
})

test_that("Error behavior", {
  skip_if_offline()
  local_mocked_bindings(create_client = function(...) stop("bla"))
  expect_snapshot(emdn_init_wcs_client("biology"), error = TRUE)
})


test_that("Services down handled", {
  skip_if_offline()
  rlang::local_interactive()
  service_url <- "https://geo.vliz.be/geoserver/Emodnetbio/wcs"
  expect_snapshot(check_service(service_url), error = TRUE)
})
