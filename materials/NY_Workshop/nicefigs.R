# Create nice R figures

savepdf <- function(file, width=16, height=10)
{
  fname <<- paste("Rfigs/",file,".pdf",sep="")
  pdf(fname, width=width/2.54, height=height/2.54, pointsize=10)
  par(mgp=c(2.2,0.45,0), tcl=-0.4, mar=c(3.3,3.6,1.1,1.1))
}
endpdf <- function()
{
  crop::dev.off.crop(fname)
}
