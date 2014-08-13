\name{imgRobinson5Level}
\alias{imgRobinson5Level}
\title{Robinson 5-level Edge Detection Method}
\description{
	This function enhaces image's edges by convoluting with the Robinson 5-level method. Base matrix is:
	\tabular{ccc}{
	1 \tab 0 \tab -1 \cr
	2 \tab 0 \tab -2 \cr
	1 \tab 0 \tab -1
	}
}
\usage{imgRobinson5Level(imgdata)}
\arguments{
	\item{imgdata}{The image}
}
\value{
	return an imagedata object
}
\examples{
	\dontrun{
		x <- readJpeg(system.file("samples", "violet.jpg", package="biOps"))
		y <- imgRobinson5Level(x)
	}
}
\keyword{math}
