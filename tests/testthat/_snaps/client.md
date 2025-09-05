# Error when wrong service

    Code
      emdn_init_wcs_client("blop")
    Condition
      Error in `check_service_name()`:
      ! Assertion on 'service' failed: Must be element of set {'bathymetry','biology','human_activities','seabed_habitats'}, but is 'blop'.

# Error when wrong service version

    Code
      emdn_init_wcs_client(service = "human_activities", service_version = "2.2.2")
    Condition
      Error in `match.arg()`:
      ! 'arg' should be one of "2.0.1", "2.1.0", "2.0.0", "1.1.1", "1.1.0"

# Warning when unsupported service version

    Code
      emdn_init_wcs_client(service = "human_activities", service_version = "1.1.1")
    Message
      v WCS client created succesfully
      i Service: <https://ows.emodnet-humanactivities.eu/wcs>
      i Service: "1.1.1"
    Condition
      Warning:
      ! Service version "1.1.1" can result in unexpected behaviour on the "human activities" server. We strongly recommend reconnecting using `service_version` "2.0.1".
    Output
      <WCSClient>
      ....|-- url: https://ows.emodnet-humanactivities.eu/wcs
      ....|-- version: 1.1.1
      ....|-- capabilities <WCSCapabilities>

# No internet handled

    Code
      emdn_init_wcs_client("biology")
    Condition
      Error in `emdn_init_wcs_client()`:
      ! There is no internet connection.

# Services down handled

    Code
      check_service(service_url)
    Condition
      Error in `check_service()`:
      ! WCS client creation failed.
      i Service: "https://geo.vliz.be/geoserver/Emodnetbio/wcs"
      i Browse the EMODnet OGC monitor for more info on the status of the services by visiting <https://monitor.emodnet.eu/resources?lang=en&resource_type=OGC:WCS>
      You could raise an issue in <https://github.com/EMODnet/emodnet.wcs/issues>

