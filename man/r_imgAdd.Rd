\name{r_imgAdd}
\alias{r_imgAdd}
\title{Add two images}
\description{
	This function adds two images and returns a new image.
}
\usage{r_imgAdd(imgdata1, imgdata2)}
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
		y <- r_imgAdd(x, x)
	}
}
\note{
	This is the R implementation of imgAdd.
}
\seealso{\code{\link{imgAdd}}}
\keyword{math}