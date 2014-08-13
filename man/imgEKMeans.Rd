\name{imgEKMeans}
\alias{imgEKMeans}
\title{Image clustering}
\description{
	This function performs an unsupervised classification through the k-means algorithm.
	It is an enhanced implementation, that avoid some comparisons based on kept information
	about distances and centroids of previous iterations.
}
\usage{imgEKMeans (imgdata, k, maxit=10)}
\arguments{
	\item{imgdata}{The image}
	\item{k}{Number of clusters}
	\item{maxit}{Max number of iterations}
}
\value{
	return an imagedata object, the result of the classification
}
\examples{
	\dontrun{
		x <- readJpeg(system.file("samples", "violet.jpg", package="biOps"))
		y <- imgEKMeans(x, 4)
	}
}
\seealso{
	\code{\link{imgKMeans}}
	\code{\link{imgKDKMeans}}
	\code{\link{imgIsoData}}
}
\keyword{math}
