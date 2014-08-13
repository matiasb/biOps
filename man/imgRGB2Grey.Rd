\name{imgRGB2Grey}
\alias{imgRGB2Grey}
\title{Convert color imagedata to grey imagedata}
\description{
	This function convert color imagedata to grey imagedata.
}
\usage{imgRGB2Grey(x, coefs=c(0.30, 0.59, 0.11))}
\arguments{
	\item{x}{The image}
	\item{coefs}{The coefficients for red, green and blue bands}
}
\value{
	grey imagedata
}
\examples{
	\dontrun{
		x <- readJpeg(system.file("samples", "violet.jpg", package="biOps"))
		plot(imgRGB2Grey(x))
	}
}
\keyword{misc}


