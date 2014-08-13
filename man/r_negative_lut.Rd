\name{r_negative_lut}
\alias{r_negative_lut}
\title{Negate an image}
\description{
	This function negates an image.
}
\usage{r_negative_lut(imgdata)}
\arguments{
	\item{imgdata}{The image}
}
\value{
	return an imagedata object
}
\examples{
	\dontrun{
		x <- readJpeg(system.file("samples", "violet.jpg", package="biOps"))
		y <- r_negative_lut(x)
	}
}
\note{
	This is the R implementation of imgNegative using look up tables.
}
\seealso{
	\code{\link{imgNegative}}
	\code{\link{r_negative}}
}
\keyword{logic}
