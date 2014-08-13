\name{imgFFTiShift}
\alias{imgFFTiShift}
\title{Inverse of the imgFFTShift}
\description{
	This function returns the inverse shifted matrix, useful in fft transformation.
}
\usage{imgFFTiShift(imgmatrix)}
\arguments{
	\item{imgmatrix}{A matrix (could be an image or a fft matrix)}
}
\value{
	return a matrix
}
\examples{
	\dontrun{
		x <- readJpeg(system.file("samples", "violet.jpg", package="biOps"))
		t <- imgFFTShift(x)
		i <- imgFFTiShift(t)
	}
}
\seealso{
	\code{\link{imgFFT}}
	\code{\link{imgFFTInv}}
	\code{\link{imgFFTShift}}
}
\keyword{math}
