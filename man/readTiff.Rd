\name{readTiff}
\alias{readTiff}
\title{Read tiff file}
\description{
	This function reads a tiff image file and return an imagedata object.
}
\usage{readTiff(filename)}
\arguments{
	\item{filename}{filename of TIFF image}
}
\value{
	return an imagedata object
}
\examples{
	\dontrun{
		x <- readTiff(system.file("samples", "violet.tif", package="biOps"))
		plot(x)
	}
}
\seealso{\code{\link{imagedata}}}
\keyword{IO}


