\name{imgGreenBand}
\alias{imgGreenBand}
\title{Return the image green band}
\description{
	This function returns the green band of the imagedata.
}
\usage{imgGreenBand(x)}
\arguments{
	\item{x}{The image}
}
\value{
	grey imagedata
}
\examples{
	\dontrun{
		x <- readJpeg(system.file("samples", "violet.jpg", package="biOps"))
		plot(imgGreenBand(x))
	}
}
\keyword{misc}


