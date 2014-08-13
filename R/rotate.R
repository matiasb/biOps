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
#	Title: Rotate Operations
#

#
#	Function: imgRotate90Clockwise
#		Rotates the image 90 degrees clockwise
# 
#	Parameters:
#		imgdata - Image to be rotated
#
#	Returns:
#		A 90 degrees clockwise rotated image
#
imgRotate90Clockwise <- function(imgdata){
	.imgRotate90(imgdata, "rotate90Clockwise")
}

#
#	Function: imgRotate90CounterClockwise
#		Rotates the image 90 degrees counter-clockwise
# 
#	Parameters:
#		imgdata - Image to be rotated
#
#	Returns:
#		A 90 degrees counter-clockwise rotated image
#
imgRotate90CounterClockwise <- function(imgdata){
	.imgRotate90(imgdata, "rotate90CounterClockwise")
}

#
#	Function: .imgRotate90
#		Rotates the image 90 degrees
# 
#	Parameters:
#		imgdata - Image to be rotated
#		method - C method to call for this operation. Must be one of "rotate90Clockwise" or "rotate90CounterClockwise"
#
#	Returns:
#		A 90 degrees rotated image
#
.imgRotate90 <- function(imgdata, method){
	imgmatrix <- array(imgdata) # get linear array image representation
	depth <- if (attr(imgdata, "type") == "grey") 1 else dim(imgdata)[3] # get images depth
	
	rows <- as.integer(dim(imgdata)[1])
	cols <- as.integer(dim(imgdata)[2])

	# call the C function for image operation
	res <- .C(method, image=as.integer(imgmatrix), width=cols,
	           height=rows, depth=as.integer(depth), ret=integer(cols*rows*depth), PACKAGE="biOps")

	imgtype <- if (depth == 1) "grey" else "rgb" # type of the result
	imgdim <- c(cols, rows, if (depth == 3) depth else NULL) # dim of the result
	img <- array(res$ret, dim=imgdim) # build the matrix from linear result
	imagedata(img, type=imgtype) # build the imagedata
}

#
#	Function: imgNearestNeighborRotate
#		Rotates the image by a given angle, applying nearest neighbor interpolation method
# 
#	Parameters:
#		imgdata - Image to be rotated
#		angle - clockwise rotation angle
#
#	Returns:
#		A rotated image
#
imgNearestNeighborRotate <- function(imgdata, angle){
	imgRotate(imgdata, angle, "nearestneighbor")
}

#
#	Function: imgBilinearRotate
#		Rotates the image by a given angle, applying bilinear interpolation method
# 
#	Parameters:
#		imgdata - Image to be rotated
#		angle - clockwise rotation angle
#
#	Returns:
#		A rotated image
#
imgBilinearRotate <- function(imgdata, angle){
	imgRotate(imgdata, angle, "bilinear")
}

#
#	Function: imgCubicRotate
#		Rotates the image by a given angle, applying cubic interpolation method
# 
#	Parameters:
#		imgdata - Image to be rotated
#		angle - clockwise rotation angle
#
#	Returns:
#		A rotated image
#
imgCubicRotate <- function(imgdata, angle){
	imgRotate(imgdata, angle, "cubic")
}

#
#	Function: imgSplineRotate
#		Rotates the image by a given angle, applying spline interpolation method
# 
#	Parameters:
#		imgdata - Image to be rotated
#		angle - clockwise rotation angle
#
#	Returns:
#		A rotated image
#
imgSplineRotate <- function(imgdata, angle){
	imgRotate(imgdata, angle, "spline")
}

#
#	Function: imgRotate
#		Rotates the image by a given angle, applying a given interpolation method
# 
#	Parameters:
#		imgdata - Image to be rotated
#		angle - clockwise rotation angle
#		interpolation - interpolation method to be applied. Must be one of "nearestneighbor", "cubic",
#		                "bilinear" or "spline"
#
#	Returns:
#		A rotated image
#
imgRotate <- function(imgdata, angle, interpolation="cubic"){
	method <- switch(interpolation, nearestneighbor="rotateByNearestNeighbor", 
	                                bilinear="rotateByBilinear",
	                                cubic="rotateByCubic",
	                                spline="rotateBySpline")
	if (is.null(method)) stop("Unsupported interpolation method")
	imgmatrix <- array(imgdata) # get linear array image representation
	depth <- if (attr(imgdata, "type") == "grey") 1 else dim(imgdata)[3] # get images depth
	
	rows <- as.integer(dim(imgdata)[1])
	cols <- as.integer(dim(imgdata)[2])
	angle <- angle * pi/180
	new_width <- as.integer(rows * abs(cos(pi/2 - angle)) + cols * abs(cos(angle)))
	new_height <- as.integer(rows * abs(cos(angle)) + cols * abs(cos(pi/2 - angle)))

	# call the C function for image operation
	res <- .C(method, image=as.integer(imgmatrix), width=cols, height=rows, depth=as.integer(depth),
	           angle=as.double(angle), ret=integer(new_width*new_height*depth),
	           new_width=new_width, height=new_height, PACKAGE="biOps")

	imgtype <- if (depth == 1) "grey" else "rgb" # type of the result
	imgdim <- c(new_height, new_width, if (depth == 3) depth else NULL) # dim of the result
	img <- array(res$ret, dim=imgdim) # build the matrix from linear result
	imagedata(img, type=imgtype) # build the imagedata
}
