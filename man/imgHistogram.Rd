\name{imgHistogram}
\alias{imgHistogram}
\title{Return the image histogram}
\description{
	This function returns the image pixel values histogram.
}
\usage{imgHistogram(x, main='Image Histogram', col='Midnight Blue', ...)}
\arguments{
	\item{x}{The image}
	\item{main}{The histogram title}
	\item{col}{The histogram bars color}
	\item{...}{Same options of hist function}
}
\value{
	histogram object
}
\examples{
	x <- readJpeg(system.file("samples", "violet.jpg", package="biOps"))
	h <- imgHistogram(x)
}
\seealso{
	\code{\link{hist}}
}
\keyword{misc}


