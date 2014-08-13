\name{imgGrayScaleErosion}
\alias{imgGrayScaleErosion}
\title{Erosion of a gray scale image}
\description{
	This function makes a dilation of a gray scale image with a given mask. This is, it applies the mask in every image pixel and sets
	current point to the minimum of the sums of the corresponding pair of pixel values in the mask and image.
}
\usage{imgGrayScaleErosion(imgdata, mask)}
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
		y <- imgGrayScaleErosion(x, mask)
	}
}
\note{
	This function accepts gray scale images and will fail with color ones.
}
\keyword{math}
