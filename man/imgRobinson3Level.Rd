\name{imgRobinson3Level}
\alias{imgRobinson3Level}
\title{Robinson 3-level Edge Detection Method}
\description{
	This function enhaces image's edges by convoluting with the Robinson 3-level method. Base matrix is:
	\tabular{ccc}{
	1 \tab 0 \tab -1 \cr
	1 \tab 0 \tab -1 \cr
	1 \tab 0 \tab -1
	}
}
\usage{imgRobinson3Level(imgdata)}
\arguments{
	\item{imgdata}{The image}
}
\value{
	return an imagedata object
}
\examples{
	\dontrun{
		x <- readJpeg(system.file("samples", "violet.jpg", package="biOps"))
		y <- imgRobinson3Level(x)
	}
}
\keyword{math}
