\name{writeJpeg}
\alias{writeJpeg}
\title{Write jpeg file}
\description{
	This function writes an imagedata object into a jpeg image file.
}
\usage{writeJpeg(filename, imgdata)}
\arguments{
	\item{filename}{filename of JPEG image}
	\item{imgdata}{imagedata to write}
}
\examples{
	\dontrun{
		x <- readJpeg(system.file("samples", "violet.jpg", package="biOps"))
		writeJpeg("new_image.jpg", x)
	}
}
\seealso{\code{\link{readJpeg}}}
\keyword{IO}
