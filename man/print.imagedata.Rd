\name{print.imagedata}
\alias{print.imagedata}
\title{Print information on a given imagedata object}
\description{
	This function outputs information on a given imagedata object.
}
\usage{print.imagedata(x, ...)}
\arguments{
  \item{x}{The image}
  \item{...}{Ignored}
}
\examples{
	\dontrun{
		x <- readJpeg(system.file("samples", "violet.jpg", package="biOps"))
		print(x)
	}
}
\seealso{
	\code{\link{imagedata}}
}
\keyword{misc}
