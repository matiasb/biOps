\name{imgStdBinaryOpening}
\alias{imgStdBinaryOpening}
\title{Fixed mask binary opening}
\description{
	This function applies a Binary Opening with a 0-squared mask, with given dimension
}
\usage{imgStdBinaryOpening(imgdata, dim)}
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
		y <- imgStdBinaryOpening(x, 4)
	}
}
\note{
	This function accepts binary images only and will treat gray scale ones as binary images.
}
\seealso{
	\code{\link{imgStdBinaryErosion}}
	\code{\link{imgStdBinaryDilation}}
	\code{\link{imgBinaryOpening}}
}
\keyword{math}
