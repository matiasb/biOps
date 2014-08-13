\name{imgStdBinaryErosion}
\alias{imgStdBinaryErosion}
\title{Fixed mask binary erosion}
\description{
	This function makes an erosion of a binary image with a 0-squared mask, with given dimension.
}
\usage{imgStdBinaryErosion(imgdata, dim)}
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
		y <- imgStdBinaryErosion(x, 4)
	}
}
\note{
	This function accepts binary images only and will treat gray scale ones as binary images.
}
\seealso{
	\code{\link{imgStdBinaryErosion}}
}
\keyword{math}
