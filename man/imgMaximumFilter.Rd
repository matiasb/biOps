\name{imgMaximumFilter}
\alias{imgMaximumFilter}
\title{Filters an image}
\description{
	This function filters an image by the Maximum filter, with a block window with a given dimension
}
\usage{imgMaximumFilter (imgdata, dim)}
\arguments{
	\item{imgdata}{The image}
	\item{dim}{Block's dimension (default=3)}
}
\value{
	return an imagedata object
}
\examples{
	\dontrun{
		x <- readJpeg(system.file("samples", "violet.jpg", package="biOps"))
		y <- imgMaximumFilter(x, 5)
	}
}
\keyword{math}
