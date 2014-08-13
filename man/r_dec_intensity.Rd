\name{r_dec_intensity}
\alias{r_dec_intensity}
\title{Decrease intensity}
\description{
	This function decreases an image intensity by a given factor.
}
\usage{r_dec_intensity(imgdata, percentage)}
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
		y <- r_dec_intensity(x, 0.3)
	}
}
\note{
	This is the R implementation of imgDecreaseIntensity.
}
\seealso{
	\code{\link{imgDecreaseIntensity}}
	\code{\link{imgIncreaseIntensity}}
	\code{\link{r_inc_intensity}}
}
\keyword{math}
