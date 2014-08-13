\name{imgConvolve}
\alias{imgConvolve}
\title{Performs an image convolution}
\description{
	This function performs an image convolution with given mask
}
\usage{imgConvolve(imgdata, mask, bias)}
\arguments{
	\item{imgdata}{The image}
	\item{mask}{Kernel's convolution matrix}
	\item{bias}{Value to be added to each pixel after method is applied (used to correct some expected behaviour). This argument is optional (default = 32)}
}
\value{
	return an imagedata object
}
\examples{
	\dontrun{
		x <- readJpeg(system.file("samples", "violet.jpg", package="biOps"))
		m <- matrix(c(1,2,1,2,4,2,1,2,1)/16, 3, 3, byrow = TRUE)
		y <- imgConvolve(x, m, 64)
	}
}

\keyword{math}
