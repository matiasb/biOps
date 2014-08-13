\name{r_inc_contrast}
\alias{r_inc_contrast}
\title{Increase contrast}
\description{
	This function increases an image contrast, augmenting pixel values differences between given limits (in a linear fashion).
}
\usage{r_inc_contrast(imgdata, min_limit, max_limit)}
\arguments{
	\item{imgdata}{The image}
	\item{min_limit}{The minimum limit to apply lineal modification}
	\item{max_limit}{The maximum limit to apply lineal modification}
}
\value{
	return an imagedata object
}
\examples{
	\dontrun{
		x <- readJpeg(system.file("samples", "violet.jpg", package="biOps"))
		y <- r_inc_contrast(x, 60, 200)
	}
}
\note{
	This is the R implementation of imgIncreaseContrast.
}
\seealso{
	\code{\link{imgIncreaseContrast}}
	\code{\link{imgDecreaseContrast}}
	\code{\link{r_dec_contrast}}
}
\keyword{math}
