\name{imgNormalize}
\alias{imgNormalize}
\title{Normalization for vector and matrix}
\description{
	This function normalizes image so that the minimum value is 0 and
	the maximum value is 1.
}
\usage{imgNormalize(x)}
\arguments{
	\item{x}{The image}
}
\value{
	Data of the same type as 'x', in which minimum value is 0 and maximum
	value is 255.
}
\examples{
	\dontrun{
		data(logo)
		plot(imgNormalize(logo))
	}
}
\keyword{misc}


