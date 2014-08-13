\name{imgFFTShift}
\alias{imgFFTShift}
\title{Shift a matrix and leave top-left value in the center}
\description{
	This function returns the shifted matrix, useful in fft transformation.
}
\usage{imgFFTShift(imgmatrix)}
\arguments{
	\item{imgmatrix}{A matrix (could be an image or a fft matrix)}
}
\value{
	return a matrix
}
\examples{
	\dontrun{
		x <- readJpeg(system.file("samples", "violet.jpg", package="biOps"))
		t <- imgFFT(x, FALSE)
		i <- imgFFTShift(t)
	}
}
\seealso{
	\code{\link{imgFFT}}
	\code{\link{imgFFTInv}}
	\code{\link{imgFFTiShift}}
}
\keyword{math}
