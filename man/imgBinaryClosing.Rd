\name{imgBinaryClosing}
\alias{imgBinaryClosing}
\title{Applies a "closing" to an image}
\description{
	This function applies an Dilation inmediatly followed by a Erosion to the given image
}
\usage{imgBinaryClosing(imgdata, mask)}
\arguments{
	\item{imgdata}{The image}
	\item{mask}{Mask to apply operation}
}
\value{
	return an imagedata object
}
\examples{
	\dontrun{
		x <- readJpeg(system.file("samples", "violet.jpg", package="biOps"))
		mat <- matrix (0, 3, 3)
		mask <- imagedata (mat, "grey", 3, 3)
		y <- imgBinaryClosing(x, mask)
	}
}
\note{
	This function accepts binary images only and will treat gray scale ones as binary images.
}
\seealso{
	\code{\link{imgBinaryErosion}}
	\code{\link{imgBinaryDilation}}
}
\keyword{math}
