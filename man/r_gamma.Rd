\name{r_gamma}
\alias{r_gamma}
\title{Gamma correct an image}
\description{
	This function applies gamma operation to a given image. Each pixel value is taken to the inverse of gamma\_value-th exponent
}
\usage{r_gamma(imgdata, gamma_value)}
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
		y <- r_gamma(x, 1.3)
	}
}
\note{
	This is the R implementation of imgGamma.
}
\seealso{
	\code{\link{imgGamma}}
}
\keyword{math}
