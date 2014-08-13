\name{imgFreiChen}
\alias{imgFreiChen}
\title{Frei-Chen Edge Detection Method}
\description{
	This function enhaces image's edges by convoluting with the Frei-Chen method matrices:
	\tabular{ccccccc}{
	  \tab \bold{H\_r} \tab \tab \tab \tab \bold{H\_c} \tab \cr
	1 \tab 0 \tab -1 \tab || \tab -1 \tab \eqn{-\sqrt{2}}{-sqrt(2)} \tab -1 \cr
	\eqn{\sqrt{2}}{sqrt(2)} \tab 0 \tab \eqn{-\sqrt{2}}{-sqrt(2)} \tab || \tab 0 \tab 0 \tab 0 \cr
	1 \tab 0 \tab -1 \tab || \tab 1 \tab \eqn{\sqrt{2}}{sqrt(2)} \tab 1 \cr
	}
}
\usage{imgFreiChen(imgdata)}
\arguments{
	\item{imgdata}{The image}
}
\value{
	return an imagedata object
}
\examples{
	\dontrun{
		x <- readJpeg(system.file("samples", "violet.jpg", package="biOps"))
		y <- imgFreiChen(x)
	}
}
\keyword{math}
