\name{imgDecreaseContrast}
\alias{imgDecreaseContrast}
\title{Decrease contrast}
\description{
	This function decreases an image contrast, leaving each pixel value between given values.
}
\usage{imgDecreaseContrast(imgdata, min_desired, max_desired)}
\arguments{
	\item{imgdata}{The image}
	\item{min_desired}{The min value}
	\item{max_desired}{The max value}
}
\value{
	return an imagedata object
}
\examples{
	\dontrun{
		x <- readJpeg(system.file("samples", "violet.jpg", package="biOps"))
		y <- imgDecreaseContrast(x, 60, 200)
	}
}
\seealso{
	\code{\link{imgIncreaseContrast}}
	\code{\link{r_dec_contrast}}
	\code{\link{r_inc_contrast}}
}
\keyword{math}
