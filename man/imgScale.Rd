\name{imgScale}
\alias{imgScale}
\title{Scale an image}
\description{
	This function scales an image using the given interpolation and returns a new image.
}
\usage{imgScale(imgdata, x_scale, y_scale, interpolation)}
\arguments{
	\item{imgdata}{The image}
	\item{x_scale}{The horizontal scale factor}
	\item{y_scale}{The vertical scale factor}
	\item{interpolation}{The interpolation method: nearestneighbor | bilinear | cubic | spline}
}
\value{
	return an imagedata object
}
\examples{
	\dontrun{
		x <- readJpeg(system.file("samples", "violet.jpg", package="biOps"))
		y <- imgScale(x, 1.5, 1.5, 'bilinear')
	}
}
\note{
	The scale factors are expected to be greater than 1.
	To reduce an image use the minification functions instead.
}
\seealso{
	\code{\link{imgNearestNeighborScale}}
	\code{\link{imgBilinearScale}}
	\code{\link{imgCubicScale}}
	\code{\link{imgSplineScale}}
	\code{\link{imgMedianShrink}}
	\code{\link{imgAverageShrink}}
}
\keyword{math}
