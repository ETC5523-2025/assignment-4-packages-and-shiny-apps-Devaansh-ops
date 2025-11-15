#' Bushfire risk summary data
#'
#' A small summary dataset derived from the Black Summer bushfire
#' attribution analysis.
#'
#' @format A tibble with 4 rows and 7 variables:
#' \describe{
#'   \item{index}{Fire-weather index name.}
#'   \item{region}{Geographic region.}
#'   \item{metric}{Description of index.}
#'   \item{baseline_prob}{Baseline climate probability.}
#'   \item{current_prob}{Current climate probability.}
#'   \item{risk_ratio}{Best estimate of risk ratio.}
#'   \item{lower_bound}{Conservative lower bound.}
#' }
#'
#' @usage data(bushfire_risk)
"bushfire_risk"
