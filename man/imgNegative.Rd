\name{imgNegative}
\alias{imgNegative}
\title{Negate an image}
\description{
	This function negates an image.
}
\usage{imgNegative(imgdata)}
\arguments{
	\item{imgdata}{The image}
}
\value{
	return an imagedata object
}
\examples{
	\dontrun{
		x <- readJpeg(system.file("samples", "violet.jpg", package="biOps"))
		y <- imgNegative(x)
	}
}
\seealso{
	\code{\link{r_negative}}
	\code{\link{r_negative_lut}}
}
\keyword{logic}
