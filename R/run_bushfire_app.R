#' Run the Black Summer Interactive Shiny App
#'
#' @return Opens the bushfire risk explorer Shiny app.
#' @export
run_bushfire_app <- function() {
  app_dir <- system.file("shiny-app", package = "blacksummer")
  shiny::runApp(app_dir, display.mode = "normal")
}
