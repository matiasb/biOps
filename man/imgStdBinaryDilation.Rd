\name{imgStdBinaryDilation}
\alias{imgStdBinaryDilation}
\title{Fixed mask binary dilation}
\description{
	This function makes a dilation of a binary image with a 0-squared mask, with given dimension.
}
\usage{imgStdBinaryDilation(imgdata, dim)}
\arguments{
	\item{imgdata}{The image}
	\item{dim}{mask's dimension (default = 3)}
}
\value{
	return an imagedata object
}
\examples{
	\dontrun{
		x <- readJpeg(system.file("samples", "violet.jpg", package="biOps"))
		y <- imgStdBinaryDilation(x, 4)
	}
}
\note{
	This function accepts binary images only and will treat gray scale ones as binary images.
}
\seealso{
	\code{\link{imgStdBinaryDilation}}
}
\keyword{math}
