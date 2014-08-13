\name{imgStdBlur}
\alias{imgStdBlur}
\title{Blurs an image}
\description{
	This function blurs an image by convoluting with a average square matrix
}
\usage{imgStdBlur(imgdata, dim)}
\arguments{
	\item{imgdata}{The image}
	\item{dim}{Square matrix dimension (optional, default = 5)}
}
\value{
	return an imagedata object
}
\examples{
	\dontrun{
		x <- readJpeg(system.file("samples", "violet.jpg", package="biOps"))
		y <- imgStdBlur(x, 3)
	}
}
\seealso{\code{\link{imgBlur}}}
\keyword{math}
