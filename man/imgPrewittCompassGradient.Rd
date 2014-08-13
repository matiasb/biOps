\name{imgPrewittCompassGradient}
\alias{imgPrewittCompassGradient}
\title{Prewitt Compass Gradient Edge Detection Method}
\description{
	This function enhaces image's edges by convoluting with the Prewitt method. Base matrix is:
	\tabular{ccc}{
	1 \tab 1 \tab -1 \cr
	1 \tab -2 \tab -1 \cr
	1 \tab 1 \tab -1
	}
}
\usage{imgPrewittCompassGradient(imgdata)}
\arguments{
	\item{imgdata}{The image}
}
\value{
	return an imagedata object
}
\examples{
	\dontrun{
		x <- readJpeg(system.file("samples", "violet.jpg", package="biOps"))
		y <- imgPrewittCompassGradient(x)
	}
}
\keyword{math}
