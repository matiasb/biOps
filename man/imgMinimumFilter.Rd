\name{imgMinimumFilter}
\alias{imgMinimumFilter}
\title{Filters an image}
\description{
	This function filters an image by the Minimum filter, with a block window with a given dimension
}
\usage{imgMinimumFilter (imgdata, dim)}
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
		y <- imgMinimumFilter(x, 5)
	}
}
\keyword{math}
