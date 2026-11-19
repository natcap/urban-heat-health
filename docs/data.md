# Data guide

The [input manifest](input_manifest.json) lists required files, sizes and
SHA-256 checksums. Keep the indicated folder structure under `data/`.

| Inputs | Figures | Description |
|---|---|---|
| `climate/`, `boundaries/` | 1, 5 | Borough climate summaries and London boundaries |
| `equity/figure2_lsoa.csv` | 2 | July 2021 temperature, baseline canopy cover and four-dimension SVI |
| `temperature/` | 3 | Temperature summaries for the specified climate settings |
| `cobenefits/` | 4–5 | Citywide and borough energy/work-capacity summaries |
| `health/` | 4–7, health supplements | Seasonal mortality results and saved GAM predictions |
| `derived/` | 6–7 | Neighbourhood vulnerability geometry and 2021 population |

## Reading the results

- Figure 1 compares future monthly mean daily maximum temperature with CHELSA
  July 2021; the comparison uses different climate products and reference periods.
- Figure 2 has 4,831 finite temperature observations and 4,835 canopy-cover
  observations. Missing temperatures are not imputed. Both panels use the same
  SVI quintile assignments across all 4,835 neighbourhoods.
- Figures 6–7 express health benefits per million fixed-2021 residents per
  modelled summer. Figure 6 includes the GAM intercept; Figure 7 applies fixed
  Green30 benefit thresholds to both scenarios.
- Health intervals reflect exposure–response coefficient uncertainty, not total
  model uncertainty. Neighbourhood associations are descriptive, not causal.

## Sources and attribution

- **Population:** WorldPop UK 2021, R2025A v1, Bondarenko et al. (2025),
  [DOI: 10.5258/SOTON/WP00839](https://doi.org/10.5258/SOTON/WP00839), CC BY 4.0.
  Reprojected while preserving counts, then aggregated to neighbourhoods.
- **Mortality:** Office for National Statistics through Nomis, 2021 registered
  deaths, Open Government Licence; population-allocated and seasonally weighted.
- **Vulnerability and canopy:** Greater London Authority datasets; the SVI uses
  GLA/Bloomberg Associates Climate Risk Mapping 2024 variables, with the
  four-dimension score applied consistently across figures.
- **LSOA boundaries:** archived GLA London statistical GIS boundaries.
  Contains National Statistics data © Crown copyright and database right [2015].
  Contains Ordnance Survey data © Crown copyright and database right [2015].
- **Underlying land cover:** Morton et al. (2024), UKCEH LCM2023 10 m GB,
  [DOI: 10.5285/7727ce7d-531e-4d77-b756-5cc59ff016bd](https://doi.org/10.5285/7727ce7d-531e-4d77-b756-5cc59ff016bd).
  Data owned by UK Centre for Ecology & Hydrology; © Database Right/Copyright UKCEH.
- **Climate:** CHELSA July 2021 and WorldClim future climate summaries.

Raw land-cover/scenario rasters, building records and station observations are
not part of this figure-level package. The code licence does not grant rights
to redistribute third-party inputs or their restricted derivatives.
