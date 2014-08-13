\name{imgFFTInv}
\alias{imgFFTInv}
\title{Fast Fourier Inverse Transformation to an image}
\description{
	This function applies a Fast Fourier Inverse Transformation on a complex matrix and return an imagedata.
}
\usage{imgFFTInv(fft_matrix, shift = TRUE)}
\arguments{
	\item{fft_matrix}{The image}
	\item{shift}{If TRUE, the transformation origin is moved to the top-left before the inverse}
}
\value{
	return an imagedata
}
\examples{
	\dontrun{
		x <- readJpeg(system.file("samples", "violet.jpg", package="biOps"))
		t <- imgFFT(x)
		i <- imgFFTInv(t)
	}
}
\seealso{
	\code{\link{imgFFT}}
	\code{\link{imgFFTShift}}
	\code{\link{imgFFTiShift}}
}
\keyword{math}
