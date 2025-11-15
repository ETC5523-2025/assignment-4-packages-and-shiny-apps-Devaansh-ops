library(tibble)
library(usethis)

bushfire_risk <- tibble::tribble(
  ~index,      ~region,           ~metric,                         ~baseline_prob, ~current_prob, ~risk_ratio, ~lower_bound,
  "FWI7x-SM",  "SE Australia",    "Extreme fire weather days",            0.05,          0.15,        3.0,        1.3,
  "MSR-SM",    "SE Australia",    "Multi-day severe fire weather",        0.04,          0.16,        4.0,        2.0,
  "TempExt",   "SE Australia",    "Very hot summer seasons",             0.10,          0.30,        3.0,        1.3,
  "RainDef",   "SE Australia",    "Dry seasons favouring fires",         0.12,          0.24,        2.0,        1.3
)

usethis::use_data(bushfire_risk, overwrite = TRUE)
