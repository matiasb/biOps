\name{imgMarrHildreth}
\alias{imgMarrHildreth}
\title{Marr-Hildreth Edge Detection Method}
\description{
	This function does edge detection using the Marr-Hildreth algorithm.
}
\usage{imgMarrHildreth(imgdata, sigma)}
\arguments{
	\item{imgdata}{The image}
	\item{sigma}{The standard deviation of Gaussian for convolution}
}
\value{
	return an imagedata object
}
\examples{
	\dontrun{
		x <- readJpeg(system.file("samples", "violet.jpg", package="biOps"))
		y <- imgMarrHildreth(x, 2)
	}
}
\keyword{math}
