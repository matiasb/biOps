\name{imgTranslate}
\alias{imgTranslate}
\title{Translate an image block}
\description{
	This function translates an image block and returns a new image.
}
\usage{imgTranslate(imgdata, x_start, y_start, x_end, y_end, t_width, t_height)}
\arguments{
	\item{imgdata}{The image}
	\item{x_start}{Upper left x coordinate of source block}
	\item{y_start}{Upper left y coordinate of source block}
	\item{x_end}{Upper left x coordinate of destination block}
	\item{y_end}{Upper left y coordinate of destination block}
	\item{t_width}{Width of the block to move}
	\item{t_height}{Height of the block to move}
}
\value{
	return an imagedata object
}
\examples{
	\dontrun{
		x <- readJpeg(system.file("samples", "violet.jpg", package="biOps"))
		y <- imgTranslate(x, 100, 100, 200, 200, 50, 50)
	}
}
\keyword{math}
