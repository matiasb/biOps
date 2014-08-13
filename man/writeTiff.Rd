\name{writeTiff}
\alias{writeTiff}
\title{Write tiff file}
\description{
	This function writes an imagedata object into a tiff image file.
}
\usage{writeTiff(filename, imgdata)}
\arguments{
	\item{filename}{filename of TIFF image}
	\item{imgdata}{imagedata to write}
}
\examples{
	\dontrun{
		x <- readTiff(system.file("samples", "violet.tif", package="biOps"))
		writeTiff("new_image.tif", x)
	}
}
\seealso{\code{\link{readTiff}}}
\keyword{IO}
