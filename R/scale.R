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
#	Title: Scale Operations
#


.check_scale_factors <- function(x_scale, y_scale){
	if (x_scale <= 0 || y_scale <= 0)
		stop("Scale factors must be positive")
	if(x_scale < 1 || y_scale < 1)
		warning("Use imgMedianShrink or imgAverageShrink to get better results")
}

#	Function: imgNearestNeighborScale
#		Scale an image using the nearest neighbor interpolation algorithm
#
#	Parameters:
#		imgdata - The image data.
#		x_scale - Horizontal axe scale factor.
#		y_scale - Vertical axe scale factor.
#
#	Returns:
#		The scaled imaged.
#
imgNearestNeighborScale <- function(imgdata, x_scale, y_scale){
	imgScale(imgdata, x_scale, y_scale, 'nearestneighbor')
}

#	Function: imgBilinearScale
#	Scale an image using the bilinear interpolation algorithm
#
#	Parameters:
#		imgdata - The image data.
#		x_scale - Horizontal axe scale factor.
#		y_scale - Vertical axe scale factor.
#
#	Returns:
#		The scaled imaged.
#
imgBilinearScale <- function(imgdata, x_scale, y_scale){
	imgScale(imgdata, x_scale, y_scale, 'bilinear')
}

#	Function: imgCubicScale
#		Scale an image using the cubic interpolation algorithm
#
#	Parameters:
#		imgdata - The image data.
#		x_scale - Horizontal axe scale factor.
#		y_scale - Vertical axe scale factor.
#
#	Returns:
#		The scaled imaged.
#
imgCubicScale <- function(imgdata, x_scale, y_scale){
	imgScale(imgdata, x_scale, y_scale, 'cubic')
}

#	Function: imgSplineScale
#	Scale an image using the b-spline interpolation algorithm
#
#	Parameters:
#		imgdata - The image data.
#		x_scale - Horizontal axe scale factor.
#		y_scale - Vertical axe scale factor.
#
#	Returns:
#		The scaled imaged.
#
imgSplineScale <- function(imgdata, x_scale, y_scale){
	imgScale(imgdata, x_scale, y_scale, 'spline')
}

#	Function: imgScale
#		Scale an image using the the given interpolation algorithm
#
#	Parameters:
#		imgdata - The image data.
#		x_scale - Horizontal axe scale factor.
#		y_scale - Vertical axe scale factor.
#		interpolation - The interpolation method.
#
#	Returns:
#		The scaled imaged.
#
imgScale <- function(imgdata, x_scale, y_scale, interpolation='cubic'){
	.check_scale_factors(x_scale, y_scale)
	method <- switch(interpolation,
	                 nearestneighbor='scaleByNearestNeighbor',
	                 bilinear='scaleByBilinear',
	                 cubic='scaleByCubic',
	                 spline='scaleBySpline')
	if (is.null(method)) stop('Unsupported interpolation method')

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
			ret=integer(cols * rows * depth), x_sc=as.double(x_scale), y_sc=as.double(y_scale),
			PACKAGE="biOps")

	imgtype <- if (depth == 1) "grey" else "rgb" # type of the result
	imgdim <- c(rows, cols, if (depth == 3) depth else NULL) # dim of the result
	img <- array(res$ret, dim=imgdim) # build the matrix from linear result
	imagedata(img, type=imgtype) # build the imagedata
}
