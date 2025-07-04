cli_alert_success <- function(text, .envir = parent.frame()) {
  if (!getOption("emodnet.wcs.quiet", FALSE)) {
    cli::cli_alert_success(text, .envir = .envir)
  }
}

cli_alert_info <- function(text, .envir = parent.frame()) {
  if (!getOption("emodnet.wcs.quiet", FALSE)) {
    cli::cli_alert_info(text, .envir = .envir)
  }
}

cli_alert_danger <- function(text, .envir = parent.frame()) {
  if (!getOption("emodnet.wcs.quiet", FALSE)) {
    cli::cli_alert_danger(text, .envir = .envir)
  }
}

cli_alert_warning <- function(text, .envir = parent.frame()) {
  if (!getOption("emodnet.wcs.quiet", FALSE)) {
    cli::cli_alert_warning(text, .envir = .envir)
  }
}

cli_rule <- function(..., .envir = parent.frame()) {
  if (!getOption("emodnet.wcs.quiet", FALSE)) {
    cli::cli_rule(..., .envir = .envir)
  }
}
