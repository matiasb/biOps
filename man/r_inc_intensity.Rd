\name{r_inc_intensity}
\alias{r_inc_intensity}
\title{Increase intensity}
\description{
	This function increases an image intensity by a given factor.
}
\usage{r_inc_intensity(imgdata, percentage)}
\arguments{
	\item{imgdata}{The image}
	\item{percentage}{A non negative value representing the intensity percentage to be increased. 1 stands for 100\% (eg. 0.5 = 50\%).}
}
\value{
	return an imagedata object
}
\examples{
	\dontrun{
		x <- readJpeg(system.file("samples", "violet.jpg", package="biOps"))
		y <- r_inc_intensity(x, 0.3)
	}
}
\note{
	This is the R implementation of imgIncreaseIntensity.
}
\seealso{
	\code{\link{imgIncreaseIntensity}}
	\code{\link{imgDecreaseIntensity}}
	\code{\link{r_dec_intensity}}
}
\keyword{math}
