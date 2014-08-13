\name{imgAverage}
\alias{imgAverage}
\title{Average images}
\description{
	This function calculates the average of the given images and returns a new image.
}
\usage{imgAverage(imgdata_list)}
\arguments{
	\item{imgdata_list}{An image list}
}
\value{
	return an imagedata object
}
\examples{
	\dontrun{
		x <- readJpeg(system.file("samples", "violet.jpg", package="biOps"))
		y <- imgAverage(list(x, x))
	}
}
\keyword{math}
