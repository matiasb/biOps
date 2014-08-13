\name{imgIncreaseContrast}
\alias{imgIncreaseContrast}
\title{Increase contrast}
\description{
	This function increases an image contrast, augmenting pixel values differences between given limits (in a linear fashion).
}
\usage{imgIncreaseContrast(imgdata, min_limit, max_limit)}
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
		y <- imgIncreaseContrast(x, 60, 200)
	}
}
\seealso{
	\code{\link{imgDecreaseContrast}}
	\code{\link{r_inc_contrast}}
	\code{\link{r_dec_contrast}}
}
\keyword{math}
