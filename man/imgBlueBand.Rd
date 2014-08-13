\name{imgBlueBand}
\alias{imgBlueBand}
\title{Return the image blue band}
\description{
	This function returns the blue band of the imagedata.
}
\usage{imgBlueBand(x)}
\arguments{
	\item{x}{The image}
}
\value{
	grey imagedata
}
\examples{
	\dontrun{
		x <- readJpeg(system.file("samples", "violet.jpg", package="biOps"))
		plot(imgBlueBand(x))
	}
}
\keyword{misc}


