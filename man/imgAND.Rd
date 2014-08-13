\name{imgAND}
\alias{imgAND}
\title{And two images}
\description{
	This function does a logic AND between two images and returns a new image.
}
\usage{imgAND(imgdata1, imgdata2)}
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
		y <- imgAND(x, x)
	}
}
\seealso{
	\code{\link{imgOR}}
	\code{\link{imgXOR}}
}
\keyword{logic}