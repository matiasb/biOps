\name{imgHomogeneityEdgeDetection}
\alias{imgHomogeneityEdgeDetection}
\title{Enhaces image edges}
\description{
	This funtions enhaces image's edge by the homogeneity method. It uses a 3x3 matrix to determine the current pixel value (by getting the maximum value between the distances of the pixel and its neighbors)
}
\usage{imgHomogeneityEdgeDetection(imgdata, bias)}
\arguments{
	\item{imgdata}{The image}
	\item{bias}{Value to be added to each pixel after method is applied (used to correct some expected behaviour). This argument is optional (default = 32)}
}
\value{
	return an imagedata object
}
\examples{
	\dontrun{
		x <- readJpeg(system.file("samples", "violet.jpg", package="biOps"))
		y <- imgHomogeneityEdgeDetection(x, bias=64)
	}
}
\seealso{
	\code{\link{imgHomogeneityEdgeDetection}}
}
\keyword{math}
