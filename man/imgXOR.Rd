\name{imgXOR}
\alias{imgXOR}
\title{Xor two images}
\description{
	This function does a logic XOR between two images and returns a new image.
}
\usage{imgXOR(imgdata1, imgdata2)}
\arguments{
	\item{imgdata1}{The first image}
	\item{imgdata2}{The second image}
}
\value{
	return an imagedata object
}
\examples{
	\dontrun{
		x <- readJpeg(system.file("samples", "violet.jpg", package="biOps"))
		y <- imgXOR(x, x)
	}
}
\seealso{
	\code{\link{imgOR}}
	\code{\link{imgAND}}
}
\keyword{logic}