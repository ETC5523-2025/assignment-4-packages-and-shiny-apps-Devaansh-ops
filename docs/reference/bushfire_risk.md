# Bushfire Risk Dataset

A tidy dataset summarising the model-derived bushfire-weather
probabilities used in the Black Summer attribution study (van Oldenborgh
et al., 2021).

## Usage

``` r
bushfire_risk
```

## Format

A tibble with 4 rows and 7 variables:

- index:

  Fire-weather index code (character).

- region:

  Geographic region represented (character).

- metric:

  Description of what the index measures (character).

- baseline_prob:

  Probability of an extreme event in the pre-industrial climate.

- current_prob:

  Probability of an extreme event in today's ~1°C warming climate.

- risk_ratio:

  How many times more likely the event is today vs historical climate.

- lower_bound:

  Conservative ‘safe estimate’ of the risk ratio.

## Source

van Oldenborgh et al. (2021)

## Details

Each row represents one fire-weather index and contains the baseline and
current probabilities for extreme conditions, along with the risk ratio
and a conservative lower bound used by climate scientists.
