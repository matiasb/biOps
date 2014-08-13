\name{imgSaltPepperNoise}
\alias{imgSaltPepperNoise}
\title{Add salt and pepper noise}
\description{
	This function adds salt and pepper noise to an image.
}
\usage{imgSaltPepperNoise(imgdata, percent)}
\arguments{
	\item{imgdata}{The image}
	\item{percent}{The percent of noise to add}
}
\value{
	return an imagedata object
}
\examples{
	\dontrun{
		x <- readJpeg(system.file("samples", "violet.jpg", package="biOps"))
		y <- imgSaltPepperNoise(x, 30)
	}
}
\seealso{
	\code{\link{imgGaussianNoise}}
}
\keyword{math}
