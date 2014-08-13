\name{imgCubicScale}
\alias{imgCubicScale}
\title{Scale an image}
\description{
	This function scales an image using cubic interpolation and returns a new image.
}
\usage{imgCubicScale(imgdata, x_scale, y_scale)}
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
		y <- imgCubicScale(x, 1.5, 1.5)
	}
}
\note{
	The scale factors are expected to be greater than 1.
	To reduce an image use the minification functions instead.
}
\seealso{
	\code{\link{imgScale}}
	\code{\link{imgNearestNeighborScale}}
	\code{\link{imgBilinearScale}}
	\code{\link{imgSplineScale}}
	\code{\link{imgMedianShrink}}
	\code{\link{imgAverageShrink}}
}
\keyword{math}