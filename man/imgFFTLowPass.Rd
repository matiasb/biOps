\name{imgFFTLowPass}
\alias{imgFFTLowPass}
\title{Apply a low pass filter on a fft matrix}
\description{
	This function returns the low passed filter on a fft matrix (this matrix should be shifted).
}
\usage{imgFFTLowPass(fft_matrix, r)}
\arguments{
	\item{fft_matrix}{The complex matrix of an fft transformation}
	\item{r}{The radius of the frequency filter}
}
\value{
	return an imagedata
}
\examples{
	\dontrun{
		x <- readJpeg(system.file("samples", "violet.jpg", package="biOps"))
		t <- imgFFT(x, FALSE)
		i <- imgFFTLowPass(t, 25)
	}
}
\seealso{
	\code{\link{imgFFT}}
	\code{\link{imgFFTInv}}
	\code{\link{imgFFTHighPass}}
	\code{\link{imgFFTBandPass}}
	\code{\link{imgFFTBandStop}}
}
\keyword{math}
