\name{imgOR}
\alias{imgOR}
\title{Or two images}
\description{
	This function does a logic OR between two images and returns a new image.
}
\usage{imgOR(imgdata1, imgdata2)}
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
		y <- imgOR(x, x)
	}
}
\seealso{
	\code{\link{imgAND}}
	\code{\link{imgXOR}}
}
\keyword{logic}