# extract_coverage_resp() emits success message

    Code
      result <- extract_coverage_resp(mock_raster, type = "", coverage_id = "test__coverage")
    Message
      v Coverage "test__coverage" downloaded succesfully as a
      terra <SpatRaster> .

# emdn_get_coverage() works

    Code
      cov <- emdn_get_coverage(wcs, coverage_id = coverage_id, bbox = c(xmin = -120,
        ymin = -19, xmax = -119, ymax = -18))
    Output
      <GMLEnvelope>
      ....|-- lowerCorner: -13358338.8951928 -2154935.91508589 "2017-01-01T00:00:00"
      ....|-- upperCorner: -13247019.4043996 -2037548.5447506 "2023-12-01T00:00:00"
    Condition
      Warning:
      Can't find any data in the `bbox`.

# emdn_get_coverage() works -- stack

    Code
      emdn_get_coverage(wcs, coverage_id = coverage_id, bbox = c(xmin = -10, ymin = 0,
        xmax = -5, ymax = 1), time = c("1958-02-16T01:00:00", "1962-11-16T01:00:00"))
    Output
      <GMLEnvelope>
      ....|-- lowerCorner: 0 -10 "1958-02-16T01:00:00"
      ....|-- upperCorner: 1 -5 "2016-11-16T01:00:00"<GMLEnvelope>
      ....|-- lowerCorner: 0 -10 "1958-02-16T01:00:00"
      ....|-- upperCorner: 1 -5 "2016-11-16T01:00:00"
    Condition
      Warning:
      Can't find any data in the `bbox`.
    Output
      NULL

# `nil_values_as_na = TRUE` converts NaN nil values to NA

    Code
      r <- emdn_get_coverage(wcs = hab_wcs, coverage_id = coverage_id, bbox = test_bbox,
        nil_values_as_na = TRUE)
    Message
      ! Error in `NaN` Returning NA
      -- Downloading coverage "emodnet_open_maplibrary__GB000050_EFH_Whiting_SpawningG
    Output
      <GMLEnvelope>
      ....|-- lowerCorner: 0 7361866.11305119
      ....|-- upperCorner: 222638.981586547 7760118.67290245
    Message
      v Coverage "emodnet_open_maplibrary__GB000050_EFH_Whiting_SpawningGrounds" downloaded succesfully as a
      terra <SpatRaster> .
      v nil values "NaN" converted to NA on emodnet_open_maplibrary__GB000050_EFH_Whiting_SpawningGrounds_0,7361866.11305119,222638.981586547,7760118.67290245_gray-index band.

