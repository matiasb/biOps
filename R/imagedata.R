# Copyright 2007 Walter Alini, Matías Bordese

#
# This file is part of biOps.
#
#     biOps is free software; you can redistribute it and/or modify
#     it under the terms of the GNU General Public License as published by
#     the Free Software Foundation; either version 2 of the License, or
#     (at your option) any later version.
#
#     biOps is distributed in the hope that it will be useful,
#     but WITHOUT ANY WARRANTY; without even the implied warranty of
#     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#     GNU General Public License for more details.
#
#     You should have received a copy of the GNU General Public License
#     along with biOps; if not, write to the Free Software
#     Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
#


##
## imagedata class definition
##

#
#	Title: Imagedata class definition
#

#	Function: imagedata
#	Return an imagedata object from a given bitmap matrix representation
#
#	Parameters:
#		mat - The image matrix data
#		type - rgb | grey
#		ncol, nrow - image dimensions
#		noclipping - clip? (deprecated)
#
#	Returns:
#		An imagedata.
#

# imagedata <- function(mat, type=NULL, ncol=dim(mat)[1], nrow=dim(mat)[2], noclipping=FALSE){
imagedata <- function(mat, type=NULL, ncol=dim(mat)[1], nrow=dim(mat)[2]){
	if (is.null(dim(mat)) && is.null(type)) stop("Type should be specified.")
	if (length(dim(mat)) == 2 && is.null(type)) type <- "grey"
	if (length(dim(mat)) == 3 && is.null(type)) type <- "rgb"
	if (type != "rgb" && type != "grey") stop("Type is incorrect.")
	if (is.null(ncol) || is.null(nrow)) stop("Dimension is uncertain.")
	imgdim <- c(ncol, nrow, if (type == "rgb") 3 else NULL)
# 	if (length(imgdim) == 3 && type == "grey") {
# 		# force to convert grey image
# 		mat <- rgb2grey(mat)
# 	}
# 	if (noclipping == FALSE && ((min(mat) < 0) || (255 < max(mat)))) {
# 		warning("Pixel values were automatically clipped because of range over.")
# 		mat <- clipping(mat)
# 	}
	mat <- array(mat, dim=imgdim)
	attr(mat, "type") <- type
	class(mat) <- c("imagedata", class(mat))
	mat
}

#	Function: print.imagedata
#	Default viewer for an imagedata; show dimensions and type
#
#	Parameters:
#		x - An imagedata
#
print.imagedata <- function(x, ...) {
	x.dim <- dim(x)
	cat("size: ", x.dim[2], "x", x.dim[1], "\n")
	cat("type: ", attr(x, "type"), "\n")
}

#	Function: plot.imagedata
#	Show the image in the screen
#
#	Parameters:
#		x - An imagedata
#
plot.imagedata <- function(x, ...){
	img <- x/255
	colvec <- switch(attr(x, "type"),
		grey=grey(img),
		rgb=rgb(img[,,1], img[,,2], img[,,3]))
	if (is.null(colvec)) stop("image matrix is broken.")
	colors <- unique(colvec)
	colmat <- array(match(colvec, colors), dim=dim(img)[1:2])
	image(x = 0:(dim(colmat)[2]), y=0:(dim(colmat)[1]),
	z = t(colmat[nrow(colmat):1, ]), col=colors,
	xlab="", ylab="", axes=FALSE, asp=1, ...)
}

#	Function: imageType
#	Return the image type
#
#	Parameters:
#		x - An imagedata
#
#	Returns:
#		 grey|rgb
#
imageType <- function(x){
	attr(x, "type")
}

#	Function: imgRedBand
#	Return the red band of the image
#
#	Parameters:
#		x - An imagedata
#
#	Returns:
#		 A one band image, corresponding to the red band of the given image
#
imgRedBand <- function(x){
	if (attr(x, "type") == "grey")
		stop("Images must have rgb type")
	mat <- x[,,1]
	attr(mat, "type") <- "grey"
	class(mat) <- c("imagedata", class(mat))
	mat
}

#	Function: imgGreenBand
#	Return the green band of the image
#
#	Parameters:
#		x - An imagedata
#
#	Returns:
#		 A one band image, corresponding to the green band of the given image
#
imgGreenBand <- function(x){
	if (attr(x, "type") == "grey")
		stop("Images must have rgb type")
	mat <- x[,,2]
	attr(mat, "type") <- "grey"
	class(mat) <- c("imagedata", class(mat))
	mat
}

#	Function: imgBlueBand
#	Return the blue band of the image
#
#	Parameters:
#		x - An imagedata
#
#	Returns:
#		 A one band image, corresponding to the blue band of the given image
#
imgBlueBand <- function(x){
	if (attr(x, "type") == "grey")
		stop("Images must have rgb type")
	mat <- x[,,3]
	attr(mat, "type") <- "grey"
	class(mat) <- c("imagedata", class(mat))
	mat
}

#	Function: imgNormalize
#	Normalizes image so that the minimum value is 0 and the maximum value is 255
#
#	Parameters:
#		x - An imagedata
#
#	Returns:
#		 The normalized image
#
imgNormalize <- function(x){
	minimum <- min(x)
	(x - minimum)*(255/(max(x)-minimum))
}

#	Function: imgRGB2Grey
#	Convert color image to grey image
#
#	Parameters:
#		x - An imagedata
#		coefs - The color coeficients to take from (red, green, blue)
#
#	Returns:
#		 The grey version of the image
#
imgRGB2Grey <- function(x, coefs=c(0.30, 0.59, 0.11)){
	if (is.null(dim(x))) stop("image must have rgb type")
	if (length(dim(x))<3) stop("image must have rgb type")
	imagedata(coefs[1] * x[,,1] + coefs[2] * x[,,2] + coefs[3] * x[,,3], type="grey")
}

#	Function: imgGetRGBFromBands
#	Create an RGB image from the given R, G, B bands
#
#	Parameters:
#		R - The red band
#		G - The green band
#		B - The blue band
#
#	Returns:
#		 The RGB image from the combined bands
#
imgGetRGBFromBands <- function(R, G, B){
	if (attr(R, "type") != "grey" || attr(G, "type") != "grey" || attr(B, "type") != "grey")
		stop("Images must have grey type")
	if (dim(R) != dim(G) || dim(R) != dim(B) || dim(B) != dim(G))
		stop("Images must have the same dimensions")
	dims <- dim(R)
	img <- array(cbind(R,G,B), dim=c(dims[1], dims[2], 3))
	imagedata(img, type='rgb')
}

#	Function: imgHistogram
#	Plot the image pixel values histogram
#
#	Parameters:
#		main - The plot title
#		col - The columns color
#		... - The hist possible parameters
#
#	Returns:
#		 The histogram object
#
imgHistogram <- function(x, main='Image Histogram', col='Midnight Blue', ...){
	hist(x, col=col, main=main, ...)
}
