\name{readJpeg}
\alias{readJpeg}
\title{Read jpeg file}
\description{
	This function reads a jpeg image file and return an imagedata object.
}
\usage{readJpeg(filename)}
\arguments{
	\item{filename}{filename of JPEG image}
}
\value{
	return an imagedata object
}
\examples{
	\dontrun{
		x <- readJpeg(system.file("samples", "violet.jpg", package="biOps"))
		plot(x)
	}
}
\seealso{\code{\link{imagedata}}}
\keyword{IO}
