fs::dir_ls(testthat::test_path(), type = "file", glob = "*.tif") |>
  fs::file_delete()
