# validate_bbox works

    Code
      validate_bbox(c(xmin = -90.000000000036, ymin = -180, xmax = -180.000000000072,
        ymax = 90))
    Condition
      Error in `validate_bbox()`:
      ! Assertion on 'bbox["xmin"] < bbox["xmax"]' failed: Must be TRUE.

---

    Code
      validate_bbox(c(xmin = -90.000000000036, ymin = -180, ymax = 90))
    Condition
      Error in `validate_bbox()`:
      ! Assertion on 'bbox' failed: Must have length 4, but has length 3.

---

    Code
      validate_bbox(c(xmin = -180, ymin = -90.000000000036, xmax = 180.000000000072,
        ymax = "90"))
    Condition
      Error in `validate_bbox()`:
      ! Assertion on 'bbox' failed: Must be of type 'numeric', not 'character'.

---

    Code
      validate_bbox(NA)
    Condition
      Error in `validate_bbox()`:
      ! Assertion on 'bbox' failed: Must have length 4, but has length 1.

# check coverages works

    Code
      check_coverages(wcs, "erroneous_id")
    Condition
      Error in `check_coverages()`:
      ! "erroneous_id" not valid coverage for service <https://geo.vliz.be/geoserver/Emodnetbio/wcs>

# validate rangesubset works

    Code
      validate_rangesubset(summary[[1]], "erroneous_rangetype")
    Condition
      Error in `map()`:
      i In index: 1.
      Caused by error in `call_with_cleanup()`:
      ! Assertion on 'rangesubset' failed: Must be element of set {'Relative abundance','Relative error'}, but is 'erroneous_rangetype'.

# check_service() works

    Code
      check_service(get_service_url("biology"))
    Condition
      Error in `httr2::req_perform()`:
      ! HTTP 403 Forbidden.

# check_wcs_version() works

    Code
      emdn_init_wcs_client("human_activities", "1.1.0")
    Condition
      Warning:
      ! Service version "1.1.0" can result in unexpected behaviour on the "human activities" server. We strongly recommend reconnecting using `service_version` "2.0.1".
    Output
      <WCSClient>
      ....|-- url: https://ows.emodnet-humanactivities.eu/wcs
      ....|-- version: 1.1.0
      ....|-- capabilities <WCSCapabilities>

---

    Code
      emdn_init_wcs_client("biology", "2.1.0")
    Condition
      Warning:
      ! Service version "2.1.0" not supported by server and can result in unexpected behaviour.
      We strongly recommend reconnecting using one of the supported versions:
      "2.0.1", "1.1.1", and "1.1.0"
    Output
      <WCSClient>
      ....|-- url: https://geo.vliz.be/geoserver/Emodnetbio/wcs
      ....|-- version: 2.1.0
      ....|-- capabilities <WCSCapabilities>

