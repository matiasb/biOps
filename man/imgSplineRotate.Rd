\name{imgSplineRotate}
\alias{imgSplineRotate}
\title{Rotate an image}
\description{
	This function rotates an image using b-spline interpolation and returns a new image.
}
\usage{imgSplineRotate(imgdata, angle)}
\arguments{
	\item{imgdata}{The image}
	\item{angle}{The clockwise deg angle to rotate}
}
\value{
	return an imagedata object
}
\examples{
	\dontrun{
		x <- readJpeg(system.file("samples", "violet.jpg", package="biOps"))
		y <- imgSplineRotate(x, 45)
	}
}
\seealso{
	\code{\link{imgRotate}}
	\code{\link{imgNearestNeighborRotate}}
	\code{\link{imgBilinearRotate}}
	\code{\link{imgCubicRotate}}
	\code{\link{imgRotate90Clockwise}}
	\code{\link{imgRotate90CounterClockwise}}
}
\keyword{math}