\name{imgSobel}
\alias{imgSobel}
\title{Sobel Edge Detection Method}
\description{
	This function enhaces image's edges by convoluting with the Sobel method matrices:
	\tabular{ccccccc}{
	  \tab \bold{H\_r} \tab \tab \tab \tab \bold{H\_c} \tab \cr
	1 \tab 0 \tab -1 \tab || \tab -1 \tab -2 \tab -1 \cr
	2 \tab 0 \tab -2 \tab || \tab 0 \tab 0 \tab 0 \cr
	1 \tab 0 \tab -1 \tab || \tab 1 \tab 2 \tab 1 \cr
	}
}
\usage{imgSobel(imgdata)}
\arguments{
	\item{imgdata}{The image}
}
\value{
	return an imagedata object
}
\examples{
	x <- readJpeg(system.file("samples", "violet.jpg", package="biOps"))
	y <- imgSobel(x)
}
\keyword{math}
