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


#
#	Title: Mirroring Operations
#


#	Function: imgHorizontalMirroring
#	Flips an image about the y axis
#
#	Parameters:
#		imgdata - The image data.
#
#	Returns:
#		The horizontal mirrored image.
#
imgHorizontalMirroring <- function(imgdata){
	.imgMirroring(imgdata, 'y')
}


#	Function: imgVerticalMirroring
#	Flips an image about the x axis
#
#	Parameters:
#		imgdata - The image data.
#
#	Returns:
#		The vertical mirrored image.
#
imgVerticalMirroring <- function(imgdata){
	.imgMirroring(imgdata, 'x')
}

#	Function: .imgMirroring
#	Flips an image
#
#	Parameters:
#		imgdata - The image data.
#		axis - The axis about mirroring the image: x | y
#
#	Returns:
#		The mirrored image.
#
.imgMirroring <- function(imgdata, axis='x'){
	method <- switch(axis, x='verticalMirroring', y='horizontalMirroring')
	if (is.null(method)) stop('Axis should be x or y')
	imgmatrix <- array(imgdata) # get linear array image representations
	depth <- if (attr(imgdata, "type") == "grey") 1 else dim(imgdata)[3] # get images depth
	width <- dim(imgdata)[2]
	height <- dim(imgdata)[1]

	# call the C function for image operation
	res <- .C(method, image=as.integer(imgmatrix),
			width=as.integer(width), height=as.integer(height), depth=as.integer(depth),
			ret=integer(width * height * depth), PACKAGE="biOps")

	imgtype <- if (depth == 1) "grey" else "rgb" # type of the result
	imgdim <- c(height, width, if (depth == 3) depth else NULL) # dim of the result
	img <- array(res$ret, dim=imgdim) # build the matrix from linear result
	imagedata(img, type=imgtype) # build the imagedata
}