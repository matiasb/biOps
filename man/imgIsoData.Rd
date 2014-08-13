\name{imgIsoData}
\alias{imgIsoData}
\title{Image clustering}
\description{
	This function performs an unsupervised classification through the k-means algorithm.
	It is an enhanced implementation, that avoid some comparisons based on kept information
	about distances and centroids of previous iterations.
}
\usage{imgIsoData (imgdata, k, min_dist=1, min_elems=1, split_sd=0.1, iter_start=5, max_merge=2, max_iter=10)}
\arguments{
	\item{imgdata}{The image}
	\item{k}{Number of clusters}
	\item{min_dist}{Minimum distance between cluster centroids}
	\item{min_elems}{Minimum elements per cluster}
	\item{split_sd}{Standard deviation threshold for splitting operation}
	\item{iter_start}{Maximum number of forgy iterations}
	\item{max_merge}{Maximum of merge operations per iteration}
	\item{max_iter}{Maximum number of iterations}
}
\value{
	return an imagedata object, the result of the classification
}
\examples{
	\dontrun{
		x <- readJpeg(system.file("samples", "violet.jpg", package="biOps"))
		y <- imgIsoData(x, 4)
	}
}
\seealso{
	\code{\link{imgKMeans}}
	\code{\link{imgEKMeans}}
	\code{\link{imgKDKMeans}}
}
\keyword{math}
