\name{imgFFTSpectrum}
\alias{imgFFTSpectrum}
\title{Image representation of the fft matrix spectrum}
\description{
	This function returns the respective spectrum of the given complex matrix (ie the result of a fft transformation).
}
\usage{imgFFTSpectrum(fft_matrix)}
\arguments{
	\item{fft_matrix}{The complex matrix of an fft transformation}
}
\value{
	return an imagedata
}
\examples{
	\dontrun{
		x <- readJpeg(system.file("samples", "violet.jpg", package="biOps"))
		t <- imgFFT(x)
		i <- imgFFTSpectrum(t)
	}
}
\seealso{
	\code{\link{imgFFT}}
	\code{\link{imgFFTInv}}
	\code{\link{imgFFTPhase}}
}
\keyword{math}
