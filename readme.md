# Urban heat, health and equity

Code and figure-level data for **Urban greening strategies shape heat-related
health benefits and equity**. The study compares how tree-planting strategies
affect cooling, electricity savings, work capacity and health across London.

An earlier version of the study is available as a
[Research Square preprint](https://doi.org/10.21203/rs.3.rs-10008371/v1).

## Repository contents

| Folder | Contents |
|---|---|
| `code/` | Figure scripts and shared functions, all in one folder |
| `data/` | Required summary tables and spatial inputs |
| `figures/` | The 13 selected final PNG figures included in this release |
| `docs/` | Data descriptions, figure index and tested software versions |

See the [figure index](docs/figure_index.csv) for each figure’s filename,
reproduction command and brief scientific description. This first package
includes Main Figs. 1–7, Extended Data Figs. 1–3 and Supplementary Figs. 12,
14 and 15.

## Reproduce the figures

Use R and Python 3. Required inputs and their sources are described in the
[data guide](docs/data.md); file checksums are in the [input manifest](docs/input_manifest.json).
Reproduction requires these inputs, not code alone.

From the repository root:

```sh
Rscript code/install_packages.R
Rscript code/check_environment.R
python3 code/verify.py
Rscript code/run.R
python3 code/verify.py --figures
```

## Tested software

| Component | Tested version | Use in this repository |
|---|---:|---|
| R | 4.6.0 | Figure generation and statistical summaries |
| Python | 3.13.13 | Input, checksum and output verification |
| GDAL | 3.8.5 | Spatial data support through R packages |
| GEOS | 3.13.0 | Spatial geometry support through `sf` |
| PROJ | 9.5.1 | Coordinate reference systems and transformations |
| InVEST | 3.20.2 | Upstream Urban Cooling Model production; not required to redraw the packaged figures |

The InVEST 3.20.2 production environment used Python 3.12.14. Figure-package
testing was performed on arm64 macOS 27.2.1. Exact R package versions are listed
in [`docs/environment.csv`](docs/environment.csv). These are tested versions,
not asserted minimum requirements.

The installer adds missing R packages from CRAN. Compare your environment with
the [tested versions](docs/environment.csv); the installer does not pin versions.
Spatial packages may require GDAL, GEOS and PROJ system libraries.

To generate one figure, use its command in the figure index—for example,
`Rscript code/run.R 2`. Target `6` generates Figures 6–7 and Supplementary
Figure 15; `supplement` generates the scenario overlays and Supplementary
Figure 14. For a full rerun, move the existing `figures/` folder aside first.

## Scope and interpretation

This package redraws figures from final model summaries and saved GAM
predictions. It does not rerun InVEST or refit the health models. Input data are
not modified. PNG rendering can vary across software and fonts.

Population and mortality are held at 2021 levels. Health benefits are reported
per modelled June–August summer; energy savings refer to a conditional 30-day
warm period; work-capacity changes are percentage points in the summer daily
mean. These quantities should not be interpreted as annual estimates.

Code is provided under [GPL v3](license). Third-party data retain their own
licences and attribution requirements; see the [data guide](docs/data.md).
