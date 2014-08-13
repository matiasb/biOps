\name{imgVerticalMirroring}
\alias{imgVerticalMirroring}
\title{Vertical mirror an image}
\description{
	This function flips an image about the x axis.
}
\usage{imgVerticalMirroring(imgdata)}
\arguments{
	\item{imgdata}{The image}
}
\value{
	return an imagedata object
}
\examples{
	\dontrun{
		x <- readJpeg(system.file("samples", "violet.jpg", package="biOps"))
		y <- imgVerticalMirroring(x)
	}
}
\seealso{
	\code{\link{imgHorizontalMirroring}}
}
\keyword{math}
