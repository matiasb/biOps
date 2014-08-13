\name{imgStdNDilationErosion}
\alias{imgStdNDilationErosion}
\title{Fixed mask NDilationErosion}
\description{
	This function applies dilation n times and then erosion n times, with a 0-squared matrix with a given dimension.
}
\usage{imgStdNDilationErosion(imgdata, n, dim=3)}
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
		y <- imgStdNDilationErosion(x, 4, 5)
	}
}
\note{
	This function accepts binary images only and will treat gray scale ones as binary images.
}
\seealso{
	\code{\link{imgNDilationErosion}}
}
\keyword{math}
