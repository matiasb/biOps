\name{imgDiffer}
\alias{imgDiffer}
\title{Substract two images}
\description{
	This function substracts two images and returns a new image, imgdata1 - imgdata2.
}
\usage{imgDiffer(imgdata1, imgdata2)}
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
		y <- imgDiffer(x, x)
	}
}
\note{
	To substract a constant c to an image you can just do: >>> imgdata - c.
}
\keyword{math}