\name{imgPadding}
\alias{imgPadding}
\title{Pad an image to the given dimensions}
\description{
	This function returns an imagedata padded to the given dimensions, leaving the input imagedata in the center of the result.
}
\usage{imgPadding(imgdata, n, m = n)}
\arguments{
	\item{imgdata}{The image}
	\item{n}{The new width}
	\item{m}{The new height}
}
\value{
	return an imagedata
}
\examples{
	\dontrun{
		x <- readJpeg(system.file("samples", "violet.jpg", package="biOps"))
		t <- imgPadding(x, 350)
	}
}
\keyword{math}
