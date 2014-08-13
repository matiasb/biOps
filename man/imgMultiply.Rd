\name{imgMultiply}
\alias{imgMultiply}
\title{Multiply two images}
\description{
	This function multiplies two images and returns a new image.
}
\usage{imgMultiply(imgdata1, imgdata2)}
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
		y <- imgMultiply(x, x)
	}
}
\note{
	To multiply an image by a constant c you can just do: >>> imgdata * c.
}
\keyword{math}