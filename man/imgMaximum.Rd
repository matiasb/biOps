\name{imgMaximum}
\alias{imgMaximum}
\title{Calculates image maximum}
\description{
	This function calculates the maximum of the given images and returns a new image.
}
\usage{imgMaximum(imgdata_list)}
\arguments{
	\item{imgdata_list}{An image list}
}
\value{
	return an imagedata object
}
\examples{
	\dontrun{
		x <- readJpeg(system.file("samples", "violet.jpg", package="biOps"))
		y <- imgMaximum(list(x, x))
	}
}
\keyword{math}
