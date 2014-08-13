\name{imgHighPassFilter}
\alias{imgHighPassFilter}
\title{Sharpens an image}
\description{
	This function sharpens an image by convoluting with the following matrix:
	\tabular{ccc}{
	-1/9 \tab -1/9 \tab  -1/9 \cr
	-1/9 \tab 8/9 \tab  -1/9 \cr
	-1/9 \tab -1/9 \tab  -1/9 \cr
	}
}
\usage{imgHighPassFilter (imgdata)}
\arguments{
	\item{imgdata}{The image}
}
\value{
	return an imagedata object
}
\examples{
	\dontrun{
		x <- readJpeg(system.file("samples", "violet.jpg", package="biOps"))
		y <- imgHighPassFilter(x)
	}
}
\keyword{math}
