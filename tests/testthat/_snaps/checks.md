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
      validate_rangesubset(summary, "erroneous_rangetype")
    Condition
      Error in `map()`:
      i In index: 1.
      Caused by error in `call_with_cleanup()`:
      ! Assertion on 'rangesubset' failed: Must be element of set {'relative_abundance'}, but is 'erroneous_rangetype'.

