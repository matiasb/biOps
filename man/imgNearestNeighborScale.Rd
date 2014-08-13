\name{imgNearestNeighborScale}
\alias{imgNearestNeighborScale}
\title{Scale an image}
\description{
	This function scales an image using nearest neighbor interpolation and returns a new image.
}
\usage{imgNearestNeighborScale(imgdata, x_scale, y_scale)}
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
		y <- imgNearestNeighborScale(x, 1.5, 1.5)
	}
}
\note{
	The scale factors are expected to be greater than 1.
	To reduce an image use the minification functions instead.
}
\seealso{
	\code{\link{imgScale}}
	\code{\link{imgBilinearScale}}
	\code{\link{imgCubicScale}}
	\code{\link{imgSplineScale}}
	\code{\link{imgMedianShrink}}
	\code{\link{imgAverageShrink}}
}
\keyword{math}