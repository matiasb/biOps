\name{imgSharpen}
\alias{imgSharpen}
\title{Sharpens an image with selected mask}
\description{
	This function sharpens an image by convoluting with one of the following matrices:
	\tabular{ccccccccccc}{
	\tab \bold{1} \tab  \tab \tab  \tab \bold{2} \tab  \tab \tab  \tab \bold{3} \tab 1 \cr
	0  \tab -1 \tab 0 \tab || \tab -1 \tab -1 \tab -1 \tab || \tab 1 \tab -2 \tab 1 \cr
	-1 \tab 5 \tab -1 \tab || \tab -1 \tab 9 \tab -1 \tab || \tab -2 \tab 5 \tab -2 \cr
	0  \tab -1 \tab 0 \tab || \tab -1 \tab -1 \tab -1 \tab || \tab 1 \tab -2 \tab 1
	}
}
\usage{imgSharpen (imgdata, mask)}
\arguments{
	\item{imgdata}{The image}
	\item{mask}{The matrix to be used in the convolution. Must be one of 1, 2, 3 (default=1)}
}
\value{
	return an imagedata object
}
\examples{
	\dontrun{
		x <- readJpeg(system.file("samples", "violet.jpg", package="biOps"))
		y <- imgSharpen(x, 2)
	}
}
\keyword{math}
