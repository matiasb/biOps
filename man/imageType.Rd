\name{imageType}
\alias{imageType}
\title{Get information on color type of imagedata}
\description{
	This function returns color type ("rgb" or "grey") of a given imagedata.
}
\usage{imageType(x)}
\arguments{
	\item{x}{The image}
}
\value{
	"rgb" or "grey"
}
\examples{
	\dontrun{
		x <- readJpeg(system.file("samples", "violet.jpg", package="biOps"))
		cat("Image Type", imageType(x))
	}
}
\keyword{misc}