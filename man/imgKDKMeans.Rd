\name{imgKDKMeans}
\alias{imgKDKMeans}
\title{Image clustering}
\description{
	This function performs an unsupervised classification through the k-means algorithm.
	This implementation uses kd-trees for nearest neighbor queries. It is useful for
	big values of k.
}
\usage{imgKDKMeans (imgdata, k, maxit=10)}
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
		y <- imgKDKMeans(x, 4)
	}
}
\seealso{
	\code{\link{imgKMeans}}
	\code{\link{imgEKMeans}}
	\code{\link{imgIsoData}}
}
\keyword{math}
