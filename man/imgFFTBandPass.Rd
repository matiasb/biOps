\name{imgFFTBandPass}
\alias{imgFFTBandPass}
\title{Apply a band pass filter on a fft matrix}
\description{
	This function returns the band passed filter on a fft matrix (this matrix should be shifted).
}
\usage{imgFFTBandPass(fft_matrix, r1, r2)}
\arguments{
	\item{fft_matrix}{The complex matrix of an fft transformation}
	\item{r1}{The inner radius of the frequency filter}
	\item{r2}{The outer radius of the frequency filter}
}
\value{
	return an imagedata
}
\examples{
	\dontrun{
		x <- readJpeg(system.file("samples", "violet.jpg", package="biOps"))
		t <- imgFFT(x, FALSE)
		i <- imgFFTBandPass(t, 25, 70)
	}
}
\seealso{
	\code{\link{imgFFT}}
	\code{\link{imgFFTInv}}
	\code{\link{imgFFTLowPass}}
	\code{\link{imgFFTHighPass}}
	\code{\link{imgFFTBandStop}}
}
\keyword{math}
