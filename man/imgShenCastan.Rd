\name{imgShenCastan}
\alias{imgShenCastan}
\title{Shen-Castan Edge Detection Method}
\description{
	This function does edge detection using the Shen-Castan algorithm.
}
\usage{imgShenCastan(imgdata, smooth_factor=0.9, thin_factor=2, adapt_window=7, thresh_ratio=0.8, do_hysteresis=1)}
\arguments{
	\item{imgdata}{The image}
	\item{smooth_factor}{The smooth factor}
	\item{thin_factor}{The thinning factor}
	\item{adapt_window}{The size of the window for adaptive gradient}
	\item{thresh_ratio}{The percentage of pixels to be above high threshold}
	\item{do_hysteresis}{If true, do hysteresis}
}
\value{
	return an imagedata object
}
\examples{
	\dontrun{
		x <- readJpeg(system.file("samples", "violet.jpg", package="biOps"))
		y <- imgShenCastan(x)
	}
}
\keyword{math}
