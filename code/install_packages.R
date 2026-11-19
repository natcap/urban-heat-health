# Optional installer. For exact versions consult docs/environment.csv.
# Installation requires network access and may require GDAL/GEOS/PROJ libraries.
p <- read.csv('docs/environment.csv',stringsAsFactors=FALSE)$package
missing <- p[!vapply(p,requireNamespace,logical(1),quietly=TRUE)]
if(length(missing)) install.packages(missing,repos='https://cloud.r-project.org')
