\name{imgDecreaseIntensity}
\alias{imgDecreaseIntensity}
\title{Decrease intensity}
\description{
	This function decreases an image intensity by a given factor.
}
\usage{imgDecreaseIntensity(imgdata, percentage)}
\arguments{
	\item{imgdata}{The image}
	\item{percentage}{A non negative value representing the intensity percentage to be decreased. 1 stands for 100\% (eg. 0.5 = 50\%).}
}
\value{
	return an imagedata object
}
\examples{
	\dontrun{
		x <- readJpeg(system.file("samples", "violet.jpg", package="biOps"))
		y <- imgDecreaseIntensity(x, 0.3)
	}
}
\seealso{
	\code{\link{imgIncreaseIntensity}}
	\code{\link{r_dec_intensity}}
	\code{\link{r_inc_intensity}}
}
\keyword{math}
