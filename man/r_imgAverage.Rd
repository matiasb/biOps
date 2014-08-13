\name{r_imgAverage}
\alias{r_imgAverage}
\title{Average images}
\description{
	This function calculates the average of the given images and returns a new image.
}
\usage{r_imgAverage(imgdata_list)}
\arguments{
	\item{imgdata_list}{An image list}
}
\value{
	return an imagedata object
}
\examples{
	\dontrun{
		x <- readJpeg(system.file("samples", "violet.jpg", package="biOps"))
		y <- r_imgAverage(list(x, x))
	}
}
\note{
	This is the R implementation of imgAverage.
}
\seealso{\code{\link{imgAverage}}}
\keyword{math}