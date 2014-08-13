\name{imgBoost}
\alias{imgBoost}
\title{High Boosts an image}
\description{
	This function high boosts an image by convoluting with the following matrix:
	\tabular{ccc}{
	-1/9 \tab  -1/9  \tab  -1/9 \cr
	-1/9  \tab (9p-1)/9  \tab  -1/9 \cr
	-1/9 \tab  -1/9  \tab  -1/9
	}
	It increases intensity by a given proportion (p) and substracting a lowpass filter
}
\usage{imgBoost(imgdata, proportion)}
\arguments{
	\item{imgdata}{The image}
	\item{proportion}{Proportion of intensity to be increased (optional: default = 1 -HighPassFilter-)}
}
\value{
	return an imagedata object
}
\examples{
	\dontrun{
		x <- readJpeg(system.file("samples", "violet.jpg", package="biOps"))
		y <- imgBoost(x, 1.2)
	}
}
\note{
	When proportion=1, it's the same as \code{\link{imgHighPassFilter}}
}
\keyword{math}
