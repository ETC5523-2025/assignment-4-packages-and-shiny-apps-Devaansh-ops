#' Launch the Bushfire Shiny App
#'
#' Opens the interactive bushfire risk exploration app.
#'
#' @return Runs the Shiny app in your default browser.
#' @export
run_bushfire_app <- function() {
  app_dir <- system.file("shiny-app", package = "blacksummer")
  if (app_dir == "") {
    stop("Shiny app not found. Make sure inst/shiny-app/ exists.", call. = FALSE)
  }
  shiny::runApp(app_dir, display.mode = "normal")
}
