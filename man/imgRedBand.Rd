\name{imgRedBand}
\alias{imgRedBand}
\title{Return the image red band}
\description{
	This function returns the red band of the imagedata.
}
\usage{imgRedBand(x)}
\arguments{
	\item{x}{The image}
}
\value{
	grey imagedata
}
\examples{
	\dontrun{
		x <- readJpeg(system.file("samples", "violet.jpg", package="biOps"))
		plot(imgRedBand(x))
	}
}
\keyword{misc}


