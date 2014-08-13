\name{imgFFTConvolve}
\alias{imgFFTConvolve}
\title{Apply a convolution filter on an imagedata through fft transformation}
\description{
	This function returns the imagedata that results from the convolution, using fft transformation that let you convolve with bigger masks.
}
\usage{imgFFTConvolve(imgdata, mask)}
\arguments{
	\item{imgdata}{The image}
	\item{mask}{The convolution mask}
}
\value{
	return an imagedata
}
\examples{
	\dontrun{
		x <- readJpeg(system.file("samples", "violet.jpg", package="biOps"))
		data <- c(-1,-1,-1,-1,9,-1,-1,-1,-1)
		m <- matrix(data, 3, 3, byrow = TRUE)
		i <- imgFFTConvolve(x, m)
	}
}
\seealso{
	\code{\link{imgFFT}}
	\code{\link{imgFFTInv}}
}
\keyword{math}
