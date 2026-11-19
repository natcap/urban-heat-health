# Execute from the repository root. Source data are never modified.
args <- commandArgs(TRUE)
dir.create('figures',showWarnings=FALSE)
selected <- if(length(args)) args else c('1','2','3','4','5','6','supplement','extended1')
run_r <- function(script,...) {
 status <- system2(file.path(R.home('bin'),'Rscript'),c(script,...))
 if(status!=0) stop('Failed: ',script)
}
for(item in selected) {
 if(item=='1') {
   source('code/plot_figure1.R')
   build_figure1('data/climate','data/boundaries/london_borough.shp','figures')
 } else if(item=='2') run_r('code/plot_figure2.R')
 else if(item=='3') {
   source('code/plot_figure3_temperature.R')
   file.copy(list.files('data/temperature',full.names=TRUE),'figures',overwrite=TRUE)
   build_figure3_borough_reporting('figures','code')
 } else if(item=='4') run_r('code/plot_figure4_citywide.R',
   '--citywide-summary data/cobenefits/citywide_energy_productivity_summary.csv',
   '--seasonal-health-root data/health --output-dir figures --figure-version release_v1')
 else if(item=='5') run_r('code/plot_figure5_borough_cobenefits.R',
   '--borough-summary data/cobenefits/borough_energy_productivity_summary.csv',
   '--borough-vector data/boundaries/london_borough.shp',
   '--seasonal-health-root data/health --output-dir figures --figure-version release_v1')
 else if(item=='6') run_r('code/plot_seasonal_manuscript_figures.R','data/health')
 else if(item=='supplement') run_r('code/plot_seasonal_supplement_figures.R','data/health')
 else if(item=='extended1') run_r('code/plot_extended_data_health.R',
   'data/health/citywide_results.csv figures/extended_data_figure1')
 else stop('Unknown selection: ',item)
}
writeLines(capture.output(sessionInfo()),'figures/session_info.txt')
