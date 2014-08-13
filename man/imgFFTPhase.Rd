\name{imgFFTPhase}
\alias{imgFFTPhase}
\title{Image representation of the fft matrix phase}
\description{
	This function returns the respective phase of the given complex matrix (ie the result of a fft transformation).
}
\usage{imgFFTPhase(fft_matrix)}
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
		i <- imgFFTPhase(t)
	}
}
\seealso{
	\code{\link{imgFFT}}
	\code{\link{imgFFTInv}}
	\code{\link{imgFFTSpectrum}}
}
\keyword{math}
