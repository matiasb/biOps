\name{r_imgDiffer}
\alias{r_imgDiffer}
\title{Substract two images}
\description{
	This function substracts two images and returns a new image, imgdata1 - imgdata2.
}
\usage{r_imgDiffer(imgdata1, imgdata2)}
\arguments{
	\item{imgdata1}{The first image}
	\item{imgdata2}{The second image}
}
\value{
	return an imagedata object
}
\examples{
	\dontrun{
		x <- readJpeg(system.file("samples", "violet.jpg", package="biOps"))
		y <- r_imgDiffer(x, x)
	}
}
\note{
	This is the R implementation of imgDiffer.
}
\seealso{\code{\link{imgDiffer}}}
\keyword{math}