\name{imgPrewitt}
\alias{imgPrewitt}
\title{Prewitt Edge Detection Method}
\description{
	This function enhaces image's edges by convoluting with the Prewitt method matrices:
	\tabular{ccccccc}{
	  \tab \bold{H\_r} \tab \tab \tab \tab \bold{H\_c} \tab \cr
	1 \tab 0 \tab -1 \tab || \tab -1 \tab -1 \tab -1 \cr
	1 \tab 0 \tab -1 \tab || \tab 0 \tab 0 \tab 0 \cr
	1 \tab 0 \tab -1 \tab || \tab 1 \tab 1 \tab 1 \cr
	}
}
\usage{imgPrewitt(imgdata)}
\arguments{
	\item{imgdata}{The image}
}
\value{
	return an imagedata object
}
\examples{
	\dontrun{
		x <- readJpeg(system.file("samples", "violet.jpg", package="biOps"))
		y <- imgPrewitt(x)
	}
}
\keyword{math}
