test_that("service urls & names crossreference correctly", {
  expect_identical(
    get_service_url("bathymetry"),
    "https://ows.emodnet-bathymetry.eu/wcs"
  )
  expect_identical(
    get_service_name("https://ows.emodnet-bathymetry.eu/wcs"),
    "bathymetry"
  )
})


test_that("extent & crs processed correctly", {
  summary <- create_biology_summary()[[1L]]
  with_mock_dir("bio-info", {
    bbox <- emdn_get_bbox(summary)
    expect_identical(conc_bbox(bbox), "-75.05, 34.95, 20.05, 75.05")
    expect_identical(extr_bbox_crs(summary)$input, "EPSG:4326")
  })
})


test_that("dimensions processed correctly", {
  with_mock_dir("biology-description2", {
    wcs <- emdn_init_wcs_client(service = "biology")
    summaries <- emdn_get_coverage_summaries_all(wcs)
    summary <- summaries[[1L]]
    expect_identical(
      emdn_get_grid_size(summary),
      c(ncol = 951.0, nrow = 401.0)
    )
    expect_identical(
      emdn_get_resolution(summary),
      structure(
        c(
          x = 0.1,
          y = 0.1
        ),
        uom = c("Deg", "Deg")
      )
    )
    expect_identical(
      emdn_get_dimensions_info(summary),
      structure(
        "lat(deg):geographic; long(deg):geographic; time(s):temporal",
        class = c("glue", "character")
      )
    )
    expect_identical(emdn_get_dimensions_n(summary), 3L)
    expect_identical(
      emdn_get_temporal_extent(summary),
      c("1958-02-16T01:00:00", "2016-11-16T01:00:00")
    )
    expect_identical(
      emdn_get_dimension_types(summary),
      c("geographic", "geographic", "temporal")
    )
    expect_identical(
      emdn_get_dimensions_names(summary),
      "Lat (Deg), Long (Deg), time (s)"
    )
    expect_identical(emdn_get_vertical_extent(summary), NA)
    expect_length(emdn_get_dimensions_info(summary, format = "list"), 3L)
    expect_snapshot(emdn_get_dimensions_info(summary, format = "tibble"))
    expect_snapshot(
      emdn_get_coverage_dim_coefs(
        wcs,
        coverage_ids = "Emodnetbio__aca_spp_19582016_L1"
      )
    )
  })
})

test_that("rangeType processed correctly", {
  summary <- create_biology_summary()[[1L]]
  with_mock_dir("biology-description3", {
    expect_equal(
      emdn_get_band_nil_values(summary),
      c(relative_abundance = 9.96920996838687e+36),
      tolerance = 1e-10
    )
    expect_identical(
      emdn_get_band_descriptions(summary),
      structure("relative_abundance", uom = "W.m-2.Sr-1")
    )
    expect_identical(
      emdn_get_band_uom(summary),
      c(relative_abundance = "W.m-2.Sr-1")
    )
    expect_identical(
      emdn_get_band_constraints(summary),
      list(
        relative_abundance = c(
          -3.4028235e+38,
          3.4028235e+38
        )
      )
    )
    expect_identical(
      emdn_get_coverage_function(summary),
      list(
        sequence_rule = "Linear",
        start_point = c(0.0, 0.0),
        axis_order = c("+2", "+1")
      )
    )
  })
})
