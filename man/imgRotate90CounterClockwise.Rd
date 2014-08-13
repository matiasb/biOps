\name{imgRotate90CounterClockwise}
\alias{imgRotate90CounterClockwise}
\title{Rotate an image}
\description{
	This function rotates the image 90 degrees counter-clockwise.
}
\usage{imgRotate90CounterClockwise(imgdata)}
\arguments{
	\item{imgdata}{The image}
}
\value{
	return an imagedata object
}
\examples{
	\dontrun{
		x <- readJpeg(system.file("samples", "violet.jpg", package="biOps"))
		y <- imgRotate90CounterClockwise(x)
	}
}
\seealso{
	\code{\link{imgRotate90Clockwise}}
}
\keyword{math}
