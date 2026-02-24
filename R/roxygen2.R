# nocov start
rlang::on_load({
  vctrs::s3_register(
    "roxygen2::roxy_tag_parse",
    "roxy_tag_examplesVCR",
    roxy_tag_parse.roxy_tag_examplesVCR
  )
  vctrs::s3_register(
    "roxygen2::roxy_tag_rd",
    "roxy_tag_examplesVCR",
    roxy_tag_rd.roxy_tag_examplesVCR
  )
})

roxy_tag_rd.roxy_tag_examplesVCR <- function(x, base_path, env) {
  roxygen2::rd_section("examples", x$val)
}

roxy_tag_parse.roxy_tag_examplesVCR <- function(x, ...) {
  lines <- unlist(strsplit(x$raw, "\r?\n"))

  cassette_name <- trimws(lines[1])

  x$raw <- paste(
    c(
      sprintf(
        "\\dontshow{vcr::insert_example_cassette('%s', package = 'emodnet.wcs')}",
        cassette_name
      ),
      lines[-1],
      "\\dontshow{vcr::eject_cassette()}"
    ),
    collapse = "\n"
  )
  x$value <- ""
  rlang::check_installed("roxygen2")
  roxygen2::tag_examples(x)
}

#' Append value if needed
#'
#' @param x Existing DESCRIPTION field value
#' @param y Value to append
#'
#' @return A character string
#' @noRd
#'
#' @examples
#' paste_desc(NA, 1)
#' paste_desc(1, 1)
#' paste_desc(2, 1)
paste_desc <- function(x, y) {
  if (is.na(x)) {
    return(y)
  }

  # ensure this is idempotent
  toString(unique(c(x, y)))
}
# nocov end
