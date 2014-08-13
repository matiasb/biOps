\name{imgNDilationErosion}
\alias{imgNDilationErosion}
\title{Dilation/Erosion multiple apply}
\description{
	This function applies n dilations followed by n erosions to the given image. Smoothes of irregularities of N pixels in size
}
\usage{imgNDilationErosion(imgdata, mask, n)}
\arguments{
	\item{imgdata}{The image}
	\item{mask}{Mask to apply operation}
	\item{n}{Times to apply each operation}
}
\value{
	return an imagedata object
}
\examples{
	\dontrun{
		x <- readJpeg(system.file("samples", "violet.jpg", package="biOps"))
		mat <- matrix (0, dim, dim)
		mask <- imagedata (mat, "grey", dim, dim)
		y <- imgNDilationErosion(x, mask, 5)
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
