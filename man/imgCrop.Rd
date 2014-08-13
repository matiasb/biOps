\name{imgCrop}
\alias{imgCrop}
\title{Crops an image}
\description{
	This function crops image.
}
\usage{imgCrop(imgdata, x_start, y_start, c_width, c_height)}
\arguments{
	\item{imgdata}{The image}
	\item{x_start}{Upper left x coordinate of source block}
	\item{y_start}{Upper left y coordinate of source block}
	\item{c_width}{Width of the block to crop}
	\item{c_height}{Height of the block to crop}
}
\value{
	return an imagedata object
}
\examples{
	\dontrun{
		x <- readJpeg(system.file("samples", "violet.jpg", package="biOps"))
		y <- imgCrop(x, 100, 50, 100, 50)
	}
}
\keyword{math}
