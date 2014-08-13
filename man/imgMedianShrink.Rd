\name{imgMedianShrink}
\alias{imgMedianShrink}
\title{Shrink an image}
\description{
	This function shrinks an image using the median and returns a new image.
}
\usage{imgMedianShrink(imgdata, x_scale, y_scale)}
\arguments{
	\item{imgdata}{The image}
	\item{x_scale}{The horizontal scale factor}
	\item{y_scale}{The vertical scale factor}
}
\value{
	return an imagedata object
}
\examples{
	\dontrun{
		x <- readJpeg(system.file("samples", "violet.jpg", package="biOps"))
		y <- imgMedianShrink(x, 0.5, 0.5)
	}
}
\note{
	The scale factors are expected to be less than 1.
}
\seealso{
	\code{\link{imgAverageShrink}}
	\code{\link{imgNearestNeighborScale}}
	\code{\link{imgBilinearScale}}
	\code{\link{imgCubicScale}}
}
\keyword{math}
