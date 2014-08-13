\name{imgGamma}
\alias{imgGamma}
\title{Gamma correct an image}
\description{
	This function applies gamma operation to a given image. Each pixel value is taken to the inverse of gamma\_value-th exponent.
}
\usage{imgGamma(imgdata, gamma_value)}
\arguments{
	\item{imgdata}{The image}
	\item{gamma_value}{A non negative value representing operation gamma value}
}
\value{
	return an imagedata object
}
\examples{
	\dontrun{
		x <- readJpeg(system.file("samples", "violet.jpg", package="biOps"))
		y <- imgGamma(x, 1.3)
	}
}
\seealso{
	\code{\link{r_gamma}}
}
\keyword{math}
