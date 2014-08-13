\name{imgCubicRotate}
\alias{imgCubicRotate}
\title{Rotate an image}
\description{
	This function rotates an image using cubic interpolation and returns a new image.
}
\usage{imgCubicRotate(imgdata, angle)}
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
		y <- imgCubicRotate(x, 45)
	}
}
\seealso{
	\code{\link{imgRotate}}
	\code{\link{imgNearestNeighborRotate}}
	\code{\link{imgBilinearRotate}}
	\code{\link{imgSplineRotate}}
	\code{\link{imgRotate90Clockwise}}
	\code{\link{imgRotate90CounterClockwise}}
}
\keyword{math}