\name{imgAdd}
\alias{imgAdd}
\title{Add two images}
\description{
	This function adds two images and returns a new image.
}
\usage{imgAdd(imgdata1, imgdata2)}
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
		y <- imgAdd(x, x)
	}
}
\note{
	To add a constant c to an image you can just do: >>> imgdata + c.
}
\keyword{math}