\name{r_negative}
\alias{r_negative}
\title{Negate an image}
\description{
	This function negates an image.
}
\usage{r_negative(imgdata)}
\arguments{
	\item{imgdata}{The image}
}
\value{
	return an imagedata object
}
\examples{
	\dontrun{
		x <- readJpeg(system.file("samples", "violet.jpg", package="biOps"))
		y <- r_negative(x)
	}
}
\note{
	This is the R implementation of imgNegative.
}
\seealso{
	\code{\link{imgNegative}}
	\code{\link{r_negative_lut}}
}
\keyword{logic}
