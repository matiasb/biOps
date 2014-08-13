\name{imgGaussianNoise}
\alias{imgGaussianNoise}
\title{Add gaussian noise}
\description{
	This function adds gaussian noise to an image.
}
\usage{imgGaussianNoise(imgdata, mean, variance)}
\arguments{
	\item{imgdata}{The image}
	\item{mean}{The gaussian mean}
	\item{variance}{The gaussian variance}
}
\value{
	return an imagedata object
}
\examples{
		x <- readJpeg(system.file("samples", "violet.jpg", package="biOps"))
		y <- imgGaussianNoise(x, 0, 120)
}
\seealso{
	\code{\link{imgSaltPepperNoise}}
}
\keyword{math}
