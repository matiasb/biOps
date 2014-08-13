\name{imgGrayScaleOpening}
\alias{imgGrayScaleOpening}
\title{Applies an ``opening'' to an image}
\description{
	This function applies an erosion inmediatly followed by a dilation to the given image
}
\usage{imgGrayScaleOpening(imgdata, mask)}
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
		mat <- matrix (125, 3, 3)
		mask <- imagedata (mat, "grey", 3, 3)
		y <- imgGrayScaleOpening(x, mask)
	}
}
\note{
	This function accepts gray scale images and will fail with color ones.
}
\seealso{
	\code{\link{imgGrayScaleErosion}}
	\code{\link{imgGrayScaleDilation}}
	\code{\link{imgBinaryErosion}}
	\code{\link{imgBinaryDilation}}
}
\keyword{math}
