\name{imgHorizontalMirroring}
\alias{imgHorizontalMirroring}
\title{Horizontal mirror an image}
\description{
	This function flips an image about the y axis.
}
\usage{imgHorizontalMirroring(imgdata)}
\arguments{
	\item{imgdata}{The image}
}
\value{
	return an imagedata object
}
\examples{
	\dontrun{
		x <- readJpeg(system.file("samples", "violet.jpg", package="biOps"))
		y <- imgHorizontalMirroring(x)
	}
}
\seealso{
	\code{\link{imgVerticalMirroring}}
}
\keyword{math}
