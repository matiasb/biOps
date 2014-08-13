\name{imgBlur}
\alias{imgBlur}
\title{Blurs an image}
\description{
	This function blurs an image by convoluting with the following matrix:
	\tabular{ccc}{
	1/16 \tab  1/8  \tab  1/16 \cr
	1/8  \tab  1/4  \tab  1/8 \cr
	1/16 \tab  1/8  \tab  1/16
	}
}
\usage{imgBlur(imgdata)}
\arguments{
	\item{imgdata}{The image}
}
\value{
	return an imagedata object
}
\examples{
	\dontrun{
		x <- readJpeg(system.file("samples", "violet.jpg", package="biOps"))
		y <- imgStdBlur(x)
	}
}
\seealso{\code{\link{imgStdBlur}}}
\keyword{math}

