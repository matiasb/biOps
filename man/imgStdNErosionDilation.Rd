\name{imgStdNErosionDilation}
\alias{imgStdNErosionDilation}
\title{Fixed mask NErosionDilation}
\description{
	This function applies erosion n times and then dilation n times, with a 0-squared matrix with a given dimension.
}
\usage{imgStdNErosionDilation(imgdata, n, dim=3)}
\arguments{
	\item{imgdata}{The image}
	\item{n}{Times to apply each operation}
	\item{dim}{mask's dimension (default = 3)}
}
\value{
	return an imagedata object
}
\examples{
	\dontrun{
		x <- readJpeg(system.file("samples", "violet.jpg", package="biOps"))
		y <- imgStdNErosionDilation(x, 4, 5)
	}
}
\note{
	This function accepts binary images only and will treat gray scale ones as binary images.
}
\seealso{
	\code{\link{imgNErosionDilation}}
}
\keyword{math}
