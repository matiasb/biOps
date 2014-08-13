\name{r_look_up_table}
\alias{r_look_up_table}
\title{Transforms an image by a given look-up table}
\description{
	This function applies a transformation to an image using a given look-up table.
}
\usage{r_look_up_table(imgdata, table)}
\arguments{
	\item{imgdata}{The image}
	\item{table}{Look up table which determines the image operation to be applied}
}
\value{
	return an imagedata object
}
\examples{
	\dontrun{
		x <- readJpeg(system.file("samples", "violet.jpg", package="biOps"))
		lut <- seq(255, 0, by=-1)
		y <- r_threshold(x, lut)
	}
}
\keyword{math}

