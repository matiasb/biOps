\name{imgCanny}
\alias{imgCanny}
\title{Canny Edge Detection Method}
\description{
	This function does edge detection using the Canny algorithm.
}
\usage{imgCanny(imgdata, sigma, low=0, high=-1)}
\arguments{
	\item{imgdata}{The image}
	\item{sigma}{The standard deviation used for the gaussian smoothing convolution}
	\item{low}{The lower threshold for hysteresis}
	\item{high}{The higher threshold for hysteresis}
}
\value{
	return an imagedata object
}
\note{
	If not specified, the low and high parameters are estimated based in a histogram of the image.
}
\examples{
	\dontrun{
		x <- readJpeg(system.file("samples", "violet.jpg", package="biOps"))
		y <- imgCanny(x, 0.7)
	}
}
\keyword{math}
