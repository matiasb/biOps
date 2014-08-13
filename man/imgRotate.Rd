\name{imgRotate}
\alias{imgRotate}
\title{Rotate an image}
\description{
	This function rotates an image using the given interpolation and returns a new image.
}
\usage{imgRotate(imgdata, angle, interpolation)}
\arguments{
	\item{imgdata}{The image}
	\item{angle}{The clockwise deg angle to rotate}
	\item{interpolation}{The interpolation method: nearestneighbor | bilinear | cubic | spline}
}
\value{
	return an imagedata object
}
\examples{
	\dontrun{
		x <- readJpeg(system.file("samples", "violet.jpg", package="biOps"))
		y <- imgRotate(x, 45, 'spline')
	}
}
\seealso{
	\code{\link{imgNearestNeighborRotate}}
	\code{\link{imgBilinearRotate}}
	\code{\link{imgCubicRotate}}
	\code{\link{imgSplineRotate}}
	\code{\link{imgRotate90Clockwise}}
	\code{\link{imgRotate90CounterClockwise}}
}
\keyword{math}