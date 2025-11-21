# emdn_get_coverage() works

    Code
      cov <- emdn_get_coverage(wcs, coverage_id = coverage_id, bbox = c(xmin = -120,
        ymin = -19, xmax = -119, ymax = -18))
    Output
      <GMLEnvelope>
      ....|-- lowerCorner: -13358338.8951928 -2154935.91508589 "2017-01-01T00:00:00"
      ....|-- upperCorner: -13247019.4043996 -2037548.5447506 "2023-12-01T00:00:00"

