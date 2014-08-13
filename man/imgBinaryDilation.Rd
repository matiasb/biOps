\name{imgBinaryDilation}
\alias{imgBinaryDilation}
\title{Dilation of a binary image}
\description{
	This function makes a dilation of a binary image with a given mask.
	This is, it applies the mask in every image pixel: when reached a black point,
	it turns every image's mask black point into black.
}
\usage{imgBinaryDilation(imgdata, mask)}
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
		y <- imgBinaryDilation(x, mask)
	}
}
\note{
	This function accepts binary images only and will treat gray scale ones as binary images.
}
\keyword{math}
