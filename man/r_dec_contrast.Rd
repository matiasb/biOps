\name{r_dec_contrast}
\alias{r_dec_contrast}
\title{Decrease contrast}
\description{
	This function decreases an image contrast, leaving each pixel value between given values.
}
\usage{r_dec_contrast(imgdata, min_desired, max_desired)}
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
		y <- r_dec_contrast(x, 60, 200)
	}
}
\note{
	This is the R implementation of imgDecreaseContrast.
}
\seealso{
	\code{\link{imgDecreaseContrast}}
	\code{\link{imgIncreaseContrast}}
	\code{\link{r_inc_contrast}}
}
\keyword{math}
