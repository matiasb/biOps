\name{imgIncreaseIntensity}
\alias{imgIncreaseIntensity}
\title{Increase intensity}
\description{
	This function increases an image intensity by a given factor.
}
\usage{imgIncreaseIntensity(imgdata, percentage)}
\arguments{
	\item{imgdata}{The image}
	\item{percentage}{A non negative value representing the intensity percentage to be increased. 1 stands for 100\% (eg. 0.5 = 50\%)}
}
\value{
	return an imagedata object
}
\examples{
	\dontrun{
		x <- readJpeg(system.file("samples", "violet.jpg", package="biOps"))
		y <- imgIncreaseIntensity(x, 0.3)
	}
}
\seealso{
	\code{\link{imgDecreaseIntensity}}
	\code{\link{r_inc_intensity}}
	\code{\link{r_dec_intensity}}
}
\keyword{math}
