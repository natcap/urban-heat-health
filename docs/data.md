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
- **Annual mortality:** Office for National Statistics,
  [Mortality statistics - underlying cause, sex and age](https://www.nomisweb.co.uk/datasets/mortsa)
  through Nomis. The analysis uses deaths registered in calendar year 2021,
  under the Open Government Licence, and allocates borough totals by population.
- **Seasonal mortality weights:** ONS,
  [Deaths by month of occurrence, age group, cause and sex, England, 2014 to 2023](https://www.ons.gov.uk/peoplepopulationandcommunity/birthsdeathsandmarriages/deaths/adhocs/2155deathsbymonthofoccurrenceagegroupcauseandsexengland2014to2023).
  England-level cause-specific monthly occurrence fractions seasonally weight
  the annual borough totals; these are not observed borough-month death counts.
- **Vulnerability:** GLA and Bloomberg Associates,
  [Climate Risk Mapping](https://data.london.gov.uk/dataset/climate-risk-mapping-2oxg6),
  Open Government Licence v3. The four-dimension SVI is applied consistently
  across figures.
- **Tree canopy:** GLA,
  [Tree Canopy Cover 2024](https://data.london.gov.uk/dataset/tree-canopy-cover-2024-2w4m3).
  The release is based mainly on 2022 data and lists All Rights Reserved; this
  package contains derived neighbourhood canopy percentages, not the source tiles.
- **LSOA boundaries:** archived GLA
  [Statistical GIS Boundary Files for London](https://data.london.gov.uk/dataset/statistical-gis-boundary-files-for-london-20od9),
  Open Government Licence v2.
  Contains National Statistics data © Crown copyright and database right [2015].
  Contains Ordnance Survey data © Crown copyright and database right [2015].
- **Underlying land cover:** Morton et al. (2024), UKCEH LCM2023 10 m GB,
  [DOI: 10.5285/7727ce7d-531e-4d77-b756-5cc59ff016bd](https://doi.org/10.5285/7727ce7d-531e-4d77-b756-5cc59ff016bd).
  Data owned by UK Centre for Ecology & Hydrology; © Database Right/Copyright UKCEH.
- **Climate:** [CHELSA V2.1](https://www.chelsa-climate.org/datasets) July 2021
  and [WorldClim CMIP6](https://www.worldclim.org/data/cmip6/cmip6climate.html)
  future climate summaries.
- **Station weather:** the exact
  [MIDAS Open v202407](https://catalogue.ceda.ac.uk/uuid/c50776e4903942cdb329589da70b83fe/)
  release supplies the station sequence used in summer-temperature reconstruction.
- **Buildings and electricity:** [Colouring Britain](https://colouringbritain.org/data-extracts.html)
  building data, [DESNZ regional and local electricity statistics](https://www.gov.uk/government/statistics/regional-and-local-authority-electricity-consumption-statistics)
  and the [Electric Insights temperature-demand analysis](https://reports.electricinsights.co.uk/?noamp=mobile&p=462)
  support conditional electricity-saving estimates. The exact project building
  snapshot is not redistributed.

Raw land-cover/scenario rasters, building records and station observations are
not part of this figure-level package. The code licence does not grant rights
to redistribute third-party inputs or their restricted derivatives.
