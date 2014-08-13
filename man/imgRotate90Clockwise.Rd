\name{imgRotate90Clockwise}
\alias{imgRotate90Clockwise}
\title{Rotate an image}
\description{
	This function rotates the image 90 degrees clockwise.
}
\usage{imgRotate90Clockwise(imgdata)}
\arguments{
	\item{imgdata}{The image}
}
\value{
	return an imagedata object
}
\examples{
	\dontrun{
		x <- readJpeg(system.file("samples", "violet.jpg", package="biOps"))
		y <- imgRotate90Clockwise(x)
	}
}
\seealso{
	\code{\link{imgRotate90CounterClockwise}}
}
\keyword{math}
