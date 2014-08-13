\name{imagedata}
\alias{imagedata}
\title{Generate an imagedata}
\description{
	This function makes an imagedata object from a matrix. This data
	structure is primary data structure to represent image in biOps package.
}
\usage{imagedata(mat, type=NULL, ncol=dim(mat)[1], nrow=dim(mat)[2])}
\arguments{
	\item{mat}{array, matrix or vector}
	\item{type}{"rgb" or "grey"}
	\item{ncol}{width of image}
	\item{nrow}{height of image}
}
\details{
	For grey scale image, matrix should be given in the form of 2
	dimensional matrix. First dimension is row, and second dimension is
	column.

	For rgb image, matrix should be given in the form of 3 dimensional
	array (row, column, channel). mat[,,1], mat[,,2], mat[,,3] are
	red plane, green plane and blue plane, respectively.

	You can omit 'type' specification if you give a proper array or
	matrix.
}
\value{
	return an imagedata object
}
\examples{
	p <- q <- seq(-1, 1, length=20)
	r <- 1 - outer(p^2, q^2, "+") / 2
	plot(imagedata(r))
}
\seealso{
	\code{\link{plot.imagedata}}
	\code{\link{print.imagedata}}
}
\keyword{misc}
