\name{r_imgMaximum}
\alias{r_imgMaximum}
\title{Images maximum}
\description{
	This function calculates the maximum of the given images and returns a new image.
}
\usage{r_imgMaximum(imgdata_list)}
\arguments{
	\item{imgdata_list}{An image list}
}
\value{
	return an imagedata object
}
\examples{
	\dontrun{
		x <- readJpeg(system.file("samples", "violet.jpg", package="biOps"))
		y <- r_imgMaximum(list(x, x))
	}
}
\note{
	This is the R implementation of imgAverage.
}
\seealso{\code{\link{imgMaximum}}}
\keyword{math}