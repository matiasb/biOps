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
#	Title: Edge Detection Operations
#

#
#	Function: imgHomogeneityEdgeDetection
#		Enhace image's edge by the homogeneity method. It uses a 3x3 matrix to determine the
#		current pixel value (by getting the maximum value between the distances of the pixel
#		and its neighbors)
#
#	Parameters:
#		imgdata - The input image
#		bias - Value to be added to each pixel after method is applied (used to correct some expected
#			behaviour). This value is optional (default = 32)
#
#	Returns:
#		The image whose edges has been enhaced
#		
#	See also:
#		<imgDifferenceEdgeDetection>
#
imgHomogeneityEdgeDetection <- function(imgdata, bias=32){
	.edgeDetection(imgdata, bias, "homogeneityEdgeDetection")
}

#
#	Function: imgDifferenceEdgeDetection
#		Enhace image's edge by the difference method. It uses a 3x3 matrix to determine the
#		current pixel value (by getting the maximum value between the distances of matrix's
#		opposite neighbors)
#
#	Parameters:
#		imgdata - The input image
#		bias - Value to be added to each pixel after method is applied (used to correct some expected
#			behaviour)
#
#	Returns:
#		ret - The image whose edges has been enhaced
#		
#	See also:
#		<imgHomogeneityEdgeDetection>
#
imgDifferenceEdgeDetection <- function(imgdata, bias=32){
	.edgeDetection(imgdata, bias, "differenceEdgeDetection")
}

.edgeDetection <- function(imgdata, bias=32, method){
	.error_range ("bias", bias, 0, 255)
	imgmatrix <- array(imgdata) # get linear array image representations
	depth <- if (attr(imgdata, "type") == "grey") 1 else dim(imgdata)[3] # get images depth
	width <- dim(imgdata)[2]
	height <- dim(imgdata)[1]

	# call the C function for image operation
	res <- .C(method, image=as.integer(imgmatrix), width=as.integer(width), height=as.integer(height), 
			   depth=as.integer(depth), bias=as.integer(bias), ret=integer(width * height * depth), PACKAGE="biOps")

	imgtype <- if (depth == 1) "grey" else "rgb" # type of the result
	imgdim <- c(height, width, if (depth == 3) depth else NULL) # dim of the result
	img <- array(res$ret, dim=imgdim) # build the matrix from linear result
	imagedata(img, type=imgtype) # build the imagedata
}
