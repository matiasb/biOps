\name{imgFFT}
\alias{imgFFT}
\title{Fast Fourier Transformation of an image}
\description{
	This function applies a Fast Fourier Transformation on an imagedata.
}
\usage{imgFFT(imgdata, shift = TRUE)}
\arguments{
	\item{imgdata}{The image}
	\item{shift}{If TRUE (default), the transformation origin is centered}
}
\value{
	return a complex matrix
}
\examples{
	\dontrun{
		x <- readJpeg(system.file("samples", "violet.jpg", package="biOps"))
		t <- imgFFT(x)
	}
}
\seealso{
	\code{\link{imgFFTInv}}
	\code{\link{imgFFTShift}}
	\code{\link{imgFFTiShift}}
}
\keyword{math}
