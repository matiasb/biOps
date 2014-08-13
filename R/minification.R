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
#	Title: Minification Operations
#

.check_shrink_factors <- function(x_shrink, y_shrink){
	if (x_shrink <= 0 || y_shrink <= 0)
		stop("Shrink factors must be positive")
	if(x_shrink > 1 || y_shrink > 1)
		stop("Shrink factors must be less than 1")
}

#	Function: imgMedianShrink
#	Reduce an image using median
#
#	Parameters:
#		imgdata - The image data.
#		x_scale - Horizontal axis scale factor.
#		y_scale - Vertical axis scale factor.
#
#	Returns:
#		The reduced image.
#
imgMedianShrink <- function(imgdata, x_scale, y_scale){
	.imgShrink(imgdata, x_scale, y_scale, 'median')
}

#	Function: imgAverageShrink
#	Reduce an image using average
#
#	Parameters:
#		imgdata - The image data.
#		x_scale - Horizontal axis scale factor.
#		y_scale - Vertical axis scale factor.
#
#	Returns:
#		The reduced image.
#
imgAverageShrink <- function(imgdata, x_scale, y_scale){
	.imgShrink(imgdata, x_scale, y_scale, 'average')
}

#	Function: imgShrink
#	Reduce an image
#
#	Parameters:
#		imgdata - The image data.
#		x_scale - Horizontal axis scale factor.
#		y_scale - Vertical axis scale factor.
#		reduction - The method for reduction: average | median.
#
#	Returns:
#		The reduced image.
#
.imgShrink <- function(imgdata, x_scale, y_scale, reduction='average'){
	method <- switch(reduction, average='averageShrink', median='medianShrink')
	if (is.null(method)) stop('Unsupported reduction method')
	.check_shrink_factors(x_scale, y_scale)
	imgmatrix <- array(imgdata) # get linear array image representations
	depth <- if (attr(imgdata, "type") == "grey") 1 else dim(imgdata)[3] # get images depth
	width <- dim(imgdata)[2]
	height <- dim(imgdata)[1]

	# dims of the result
	cols <- as.integer(width * x_scale)
	rows <- as.integer(height * y_scale)

	# call the C function for image operation
	res <- .C(method, image=as.integer(imgmatrix),
			width=as.integer(width), height=as.integer(height), depth=as.integer(depth),
			ret=integer(cols * rows * depth), new_width=as.integer(cols), new_height=as.integer(rows),
			PACKAGE="biOps")

	imgtype <- if (depth == 1) "grey" else "rgb" # type of the result
	imgdim <- c(rows, cols, if (depth == 3) depth else NULL) # dim of the result
	img <- array(res$ret, dim=imgdim) # build the matrix from linear result
	imagedata(img, type=imgtype) # build the imagedata
}
