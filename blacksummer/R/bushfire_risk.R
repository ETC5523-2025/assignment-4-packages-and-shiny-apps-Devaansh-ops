#' Bushfire Risk Dataset
#'
#' A tidy dataset summarising model-derived bushfire-weather probabilities
#' used in the Black Summer attribution study.
#'
#' @format A tibble with 4 rows and 7 variables:
#' \describe{
#'   \item{index}{Fire-weather index code.}
#'   \item{region}{Region represented.}
#'   \item{metric}{Description of what the index measures.}
#'   \item{baseline_prob}{Pre-industrial probability.}
#'   \item{current_prob}{Current-climate probability.}
#'   \item{risk_ratio}{Likelihood today vs. historical.}
#'   \item{lower_bound}{Conservative lower-bound estimate.}
#' }
#'
#' @usage bushfire_risk
#' @docType data
#' @keywords datasets
#' @name bushfire_risk
"bushfire_risk"


