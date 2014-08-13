\name{plot.imagedata}
\alias{plot.imagedata}
\title{Plotting an imagedata object}
\description{
	This function outputs an imagedata object as an image.
}
\usage{plot.imagedata(x, ...)}
\arguments{
	\item{x}{The image}
	\item{...}{Plotting options}
}
\examples{
	\dontrun{
		x <- readJpeg(system.file("samples", "violet.jpg", package="biOps"))
		plot(x)
	}
}
\seealso{
	\code{\link{imagedata}}
}
\keyword{misc}
