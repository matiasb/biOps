\name{imgThreshold}
\alias{imgThreshold}
\title{Threshold an image}
\description{
	This function thresholds an image using a given filter.
}
\usage{imgThreshold(imgdata, thr_value)}
\arguments{
	\item{imgdata}{The image}
	\item{thr_value}{Filter value for thresholding}
}
\value{
	return an imagedata object
}
\examples{
	x <- readJpeg(system.file("samples", "violet.jpg", package="biOps"))
	y <- imgThreshold(x, 80)
}
\seealso{
	\code{\link{r_threshold}}
}
\keyword{math}
