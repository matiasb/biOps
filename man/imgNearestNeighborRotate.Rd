\name{imgNearestNeighborRotate}
\alias{imgNearestNeighborRotate}
\title{Rotate an image}
\description{
	This function rotates an image using nearest neighbor interpolation and returns a new image.
}
\usage{imgNearestNeighborRotate(imgdata, angle)}
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
		y <- imgNearestNeighborRotate(x, 45)
	}
}
\seealso{
	\code{\link{imgRotate}}
	\code{\link{imgBilinearRotate}}
	\code{\link{imgCubicRotate}}
	\code{\link{imgSplineRotate}}
	\code{\link{imgRotate90Clockwise}}
	\code{\link{imgRotate90CounterClockwise}}
}
\keyword{math}