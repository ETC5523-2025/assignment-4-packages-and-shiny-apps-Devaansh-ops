blacksummer: Exploring Australia’s Black Summer Bushfire Risk
================

<!-- badges -->

<p align="left">

<a href="LICENSE"><img src="https://img.shields.io/badge/license-MIT-blue.svg" alt="License: MIT"/></a>
<a href="https://www.r-project.org/"><img src="https://img.shields.io/badge/R-%3E%3D4.1.0-1f425f.svg" alt="R version"/></a>

</p>

# 🔥 **blacksummer**

### *A lightweight R package for exploring Black Summer bushfire risk and climate attribution.*

The **blacksummer** R package provides:

- ✔️ A clean bushfire risk dataset

- ✔️ An interactive Shiny app for exploration

- ✔️ A detailed vignette explaining climate attribution science

- ✔️ A pkgdown website for full documentation

This package is based on the analysis of the catastrophic

**2019–2020 Black Summer bushfires** in Australia.

------------------------------------------------------------------------

# ⭐ Why use `blacksummer`?

Wildfire and climate attribution data are often difficult to explore
without

specialised software. **blacksummer** makes it simple:

- 🟧 *Compact dataset* summarising extreme fire-weather indicators

- 🟦 *Interactive interface* to explore climate risk changes

- 🟩 *Clear visualisations* for probability shifts and risk ratios

- 🟨 *Designed for teaching & communication* (ETC5523)

The package helps bridge **climate science**, **data analysis**, and

**public communication** into one accessible tool.

------------------------------------------------------------------------

# 📦 Installation

Install the development version from GitHub:

``` r
# Install from GitHub
remotes::install_github("etc5523-2025/assignment-4-packages-and-shiny-apps-Devaansh-ops")
```

------------------------------------------------------------------------

# 📊 Included Dataset

The package ships with `bushfire_risk`, a tibble containing:

- **baseline_prob**: Historical probability

- **current_prob**: Present-day (1°C warming) probability

- **risk_ratio**: Estimated risk increase

- **lower_bound**: Conservative minimum estimate

Load it with:

``` r
library(blacksummer)
data(bushfire_risk)
bushfire_risk
```

------------------------------------------------------------------------

# 🖥️ Launch the Interactive Shiny App

Explore risk indicators interactively:

``` r
library(blacksummer)
run_bushfire_app()
```

This app allows you to:

- Compare baseline vs modern probability
- Visualise risk ratios
- Inspect summary values
- Understand the science behind attribution

------------------------------------------------------------------------

# 📘 Vignettes & Documentation

A full narrative vignette (“Burning Point: Climate, Data, and
Responsibility”) explains the scientific context behind the bushfire
risk indicators.

Visit the full documentation site:

👉 <a
href="https://etc5523-2025.github.io/assignment-4-packages-and-shiny-apps-Devaansh-ops/"
class="uri"><strong>https://etc5523-2025.github.io/assignment-4-packages-and-shiny-apps-Devaansh-ops/</strong></a>

------------------------------------------------------------------------

# 📁 Package Structure

    blacksummer/
    ├── R/
    │   ├── run_bushfire_app.R
    │   └── bushfire_risk-data.R
    ├── inst/
    │   └── shiny-app/app.R
    ├── data/
    │   └── bushfire_risk.rda
    ├── vignettes/
    │   └── burning-point.qmd

------------------------------------------------------------------------

# 🧑‍💻 Author

**Devaansh Gupta**

Monash University

ETC5523 — Communicating with Data

------------------------------------------------------------------------

# 🔖 License

This project is released under the MIT License.  
See the `LICENSE` file for details.
