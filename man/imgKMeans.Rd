\name{imgKMeans}
\alias{imgKMeans}
\title{Image clustering}
\description{
	This function performs an unsupervised classification through the k-means algorithm.
	It is an straightforward implementation.
}
\usage{imgKMeans (imgdata, k, maxit=10)}
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
		y <- imgKMeans(x, 4)
	}
}
\seealso{
	\code{\link{imgEKMeans}}
	\code{\link{imgKDKMeans}}
	\code{\link{imgIsoData}}
}
\keyword{math}
