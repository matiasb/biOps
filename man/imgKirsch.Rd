\name{imgKirsch}
\alias{imgKirsch}
\title{Kirsch Edge Detection Method}
\description{
	This function enhaces image's edges by convoluting with the Kirsch method. Base matrix is:
	\tabular{ccc}{
	5 \tab -3 \tab -3 \cr
	5 \tab 0 \tab -3 \cr
	5 \tab -3 \tab -3
	}
}
\usage{imgKirsch(imgdata)}
\arguments{
	\item{imgdata}{The image}
}
\value{
	return an imagedata object
}
\examples{
	\dontrun{
		x <- readJpeg(system.file("samples", "violet.jpg", package="biOps"))
		y <- imgKirsch(x)
	}
}
\keyword{math}
