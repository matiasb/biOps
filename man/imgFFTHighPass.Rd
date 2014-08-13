\name{imgFFTHighPass}
\alias{imgFFTHighPass}
\title{Apply a high pass filter on a fft matrix}
\description{
	This function returns the high passed filter on a fft matrix (this matrix should be shifted).
}
\usage{imgFFTHighPass(fft_matrix, r)}
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
		i <- imgFFTHighPass(t, 25)
	}
}
\seealso{
	\code{\link{imgFFT}}
	\code{\link{imgFFTInv}}
	\code{\link{imgFFTLowPass}}
	\code{\link{imgFFTBandPass}}
	\code{\link{imgFFTBandStop}}
}
\keyword{math}
