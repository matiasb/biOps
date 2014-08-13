\name{imgDivide}
\alias{imgDivide}
\title{Divide two images}
\description{
	This function divides two images and returns a new image.
}
\usage{imgDivide(imgdata1, imgdata2)}
\arguments{
	\item{imgdata1}{The first image}
	\item{imgdata2}{The second image}
}
\value{
	return an imagedata object
}
\examples{
	\dontrun{
		x <- readJpeg(system.file("samples", "violet.jpg", package="biOps"))
		y <- imgDivide(x, x)
	}
}
\note{
	To divide an image by a constant c you can just do: >>> imgdata / c.
}
\keyword{math}