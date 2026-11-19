p <- read.csv('docs/environment.csv',stringsAsFactors=FALSE)
missing <- p$package[!vapply(p$package,requireNamespace,logical(1),quietly=TRUE)]
if(length(missing)) stop('Missing packages: ',paste(missing,collapse=', '))
actual <- vapply(p$package,function(x) as.character(packageVersion(x)),character(1))
different <- actual!=p$version
if(any(different)) warning('Versions differ from tested environment: ',paste(p$package[different],collapse=', '))
cat(R.version.string,'\nAll required packages available.\n')
