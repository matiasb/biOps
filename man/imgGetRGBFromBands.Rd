\name{imgGetRGBFromBands}
\alias{imgGetRGBFromBands}
\title{Return an RGB image}
\description{
	This function returns the RGB image compositing the given bands.
}
\usage{imgGetRGBFromBands(R, G, B)}
\arguments{
	\item{R}{A one-band image for the Red band}
	\item{G}{A one-band image for the Green band}
	\item{B}{A one-band image for the Blue band}
}
\value{
	RGB imagedata
}
\examples{
	\dontrun{x <- readJpeg(system.file("samples", "violet.jpg", package="biOps"))
		r <- imgRedBand(x)
		g <- imgGreenBand(x)
		b <- imgBlueBand(x)
		rgb <- imgGetRGBFromBands(r, g, b)
	}
}
\keyword{misc}


