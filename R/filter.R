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
#	Title: Filter Operations
#

# 
# 	Function: imgBlockMedianFilter
# 		Filters an image by the Median filter, with a block window
# 
# 	Parameters:
# 		imgdata - Image to be filtered
# 		dim - Block's dimension
# 
# 	Returns:
# 		The filtered image
# 
imgBlockMedianFilter <- function(imgdata, dim=3){
	.imgFilter('block_median_filter', imgdata, dim)
}

# 
# 	Function: imgMaximumFilter
# 		Filters an image by the Maximum filter, with a block window
# 
# 	Parameters:
# 		imgdata - Image to be filtered
# 		dim - Block's dimension
# 
# 	Returns:
# 		The filtered image
# 
imgMaximumFilter <- function(imgdata, dim=3){
	.imgFilter('maximum_filter', imgdata, dim)
}

# 
# 	Function: imgMinimumFilter
# 		Filters an image by the Minimum filter, with a block window
# 
# 	Parameters:
# 		imgdata - Image to be filtered
# 		dim - Block's dimension
# 
# 	Returns:
# 		The filtered image
# 
imgMinimumFilter <- function(imgdata, dim=3){
	.imgFilter('minimum_filter', imgdata, dim)
}

# 
# 	Function: .imgFilter
# 		Filters an image by the given method with a block window
# 
# 	Parameters:
#		method - C method to be called
# 		imgdata - Image to be filtered
# 		dim - Block's dimension
# 
# 	Returns:
# 		The filtered image
# 
.imgFilter <- function(method, imgdata, dim=3){
	imgmatrix <- array(imgdata) # get linear array image representations
	depth <- if (attr(imgdata, "type") == "grey") 1 else dim(imgdata)[3] # get images depth
	width <- dim(imgdata)[2]
	height <- dim(imgdata)[1]

	# call the C function for image operation
	res <- .C(method, image=as.integer(imgmatrix),
			width=as.integer(width), height=as.integer(height), depth=as.integer(depth),
			dim=as.integer(dim), ret=integer(width * height * depth), PACKAGE="biOps")

	imgtype <- if (depth == 1) "grey" else "rgb" # type of the result
	imgdim <- c(height, width, if (depth == 3) depth else NULL) # dim of the result
	img <- array(res$ret, dim=imgdim) # build the matrix from linear result
	imagedata(img, type=imgtype) # build the imagedata
}