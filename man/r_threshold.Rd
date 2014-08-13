\name{r_threshold}
\alias{r_threshold}
\title{Threshold an image}
\description{
	This function thresholds an image using a given filter.
}
\usage{r_threshold(imgdata, thr_value)}
\arguments{
	\item{imgdata}{The image}
	\item{thr_value}{Filter value for thresholding}
}
\value{
	return an imagedata object
}
\examples{
	\dontrun{
		x <- readJpeg(system.file("samples", "violet.jpg", package="biOps"))
		y <- r_threshold(x, 80)
	}
}
\note{
	This is the R implementation of imgThreshold.
}
\seealso{
	\code{\link{imgThreshold}}
}
\keyword{math}

