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
#	Title: Convolution Mask Operations
#

#	Function: imgConvolve
#		Performs an image convolution with given mask
#
#	Parameters:
#		imgdata - The image data.
#		mask - The mask matrix to be convoluted with the image
#		bias - Optional value to adjust images values
#
#	Returns:
#		The convolved image
#
imgConvolve <- function(imgdata, mask, bias=0){
	imgmatrix <- array(imgdata) # get linear array image representations
	depth <- if (attr(imgdata, "type") == "grey") 1 else dim(imgdata)[3] # get images depth
	width <- dim(imgdata)[2]
	height <- dim(imgdata)[1]
	linear_mask <- array(mask)
	mask_width <- dim(mask)[2]
	mask_height <- dim(mask)[1]

	# call the C function for image operation
	res <- .C('convolution', image=as.integer(imgmatrix),
			width=as.integer(width), height=as.integer(height), depth=as.integer(depth),
			mask=as.double(linear_mask), mask_width=as.integer(mask_width), mask_height=as.integer(mask_height),
			bias=as.integer(bias), ret=integer(width * height * depth), PACKAGE="biOps")

	imgtype <- if (depth == 1) "grey" else "rgb" # type of the result
	imgdim <- c(height, width, if (depth == 3) depth else NULL) # dim of the result
	img <- array(res$ret, dim=imgdim) # build the matrix from linear result
	imagedata(img, type=imgtype) # build the imagedata
}

#	Function: imgStdBlur
#		Blurs an image with a average square matrix, with the given dimension
#
#	Parameters:
#		imgdata - The image data.
#		dim - Matrix's dimension (default=5)
#
#	Returns:
#		A blurred image
#
imgStdBlur <- function(imgdata, dim=5){
	if (as.integer(dim) < 0) stop ("dim must be a non negative value")
	m <- matrix(1/(dim*dim), dim, dim, byrow = TRUE)
	imgConvolve(imgdata, m, 0)
}

#	Function: imgBlur
#		Blurs an image
#
#	Parameters:
#		imgdata - The image data.
#
#	Returns:
#		A blurred image
#
imgBlur <- function(imgdata){
	data <- c(1,2,1,2,4,2,1,2,1)/16
	m <- matrix(data, 3, 3, byrow = TRUE)
	imgConvolve(imgdata, m, 0)
}

#	Function: imgSharpen
#		Sharpens an image with the mask selected
#
#	Parameters:
#		imgdata - The image data.
#		mask - The mask to be applied. Must be one of 1, 2, 3 (default=1)
#
#	Returns:
#		A sharpened image
#
imgSharpen <- function(imgdata, mask=1){
	data <- switch(as.integer(mask), "1" = c(0,-1,0,-1,5,-1,0,-1,0),
	                       "2" = c(-1,-1,-1,-1,9,-1,-1,-1,-1),
	                       "3" = c(1,-2,1,-2,5,-2,1,-2,1))
	.error_range ("mask", as.integer(mask), 1, 3)
	m <- matrix(data, 3, 3, byrow = TRUE)
	imgConvolve(imgdata, m, 0)
}

#	Function: imgUnsharpen
#		Unsharpens an image with the mask selected. Performs a difference between original image and
#		sharp convolved image with the specified mask
#
#	Parameters:
#		imgdata - The image data.
#		mask - The mask to be applied for sharp image. Must be one of 1, 2, 3 (default=1)
#
#	Returns:
#		An unsharpened image
#
imgUnsharpen <- function(imgdata, mask=1){
	.error_range ("mask", as.integer(mask), 1, 3)
	imgDiffer(imgdata, imgSharpen(imgdata, mask))
}

#	Function: imgHighPassFilter
#		Sharps an image with the high pass filter mask.
#
#	Parameters:
#		imgdata - The image data.
#
#	Returns:
#		An sharpened image
#
imgHighPassFilter <- function(imgdata){
	data <- c(-1,-1,-1,-1,8,-1,-1,-1,-1)/9
	m <- matrix(data, 3, 3, byrow = TRUE)
	imgConvolve(imgdata, m, 0)
}

#	Function: imgBoost
#		Boost an image
#
#	Parameters:
#		imgdata - The image data.
#		proportion - proportion intensity to be increased
#
#	Returns:
#		An boosted image
#
imgBoost <- function(imgdata, proportion=1){
	data <- c(-1,-1,-1,-1,9*proportion-1,-1,-1,-1,-1)/9
	m <- matrix(data, 3, 3, byrow = TRUE)
	imgConvolve(imgdata, m, 0)
}

#
#	First Order Derivarive Edge Detection Operators
#

#	Function: .firstOrder
#		Applies convolution for a mask and its 90 degrees clockwise rotation. Then, take matrices average
#
#	Parameters:
#		imgdata - The image data
#		matrix - base mask
#
#	Returns:
#		An edge enhaced image
#
.firstOrder <- function(imgdata, matrix){
	hr <- imgConvolve(imgdata, matrix, 0)
	matrix <- .mrotate90 (matrix)
	hc <- imgConvolve(imgdata, matrix, 0)
	imgAverage(list(hr,hc))
}


#	Function: imgRoberts
#		Applies convolution with the Roberts Edge Detection kernel matrix
#
#	Parameters:
#		imgdata - The image data.
#
#	Returns:
#		An edge enhaced image
#
imgRoberts <- function(imgdata){
	data <- c(0,0,-1,0,1,0,0,0,0)
	m <- matrix(data, 3, 3, byrow = TRUE)
	.firstOrder(imgdata, m)
}

#	Function: imgPrewitt
#		Applies convolution with the Prewitt Edge Detection kernel matrix
#
#	Parameters:
#		imgdata - The image data.
#
#	Returns:
#		An edge enhaced image
#
imgPrewitt <- function (imgdata){
	data <- c(1,0,-1,1,0,-1,1,0,-1)
	m <- matrix(data, 3, 3, byrow = TRUE)
	.firstOrder(imgdata,m)
}

#	Function: imgSobel
#		Applies convolution with the Sobel Edge Detection kernel matrix
#
#	Parameters:
#		imgdata - The image data.
#
#	Returns:
#		An edge enhaced image
#
imgSobel <- function (imgdata){
	data <- c(1,0,-1,2,0,-2,1,0,-1)
	m <- matrix(data, 3, 3, byrow = TRUE)
	.firstOrder(imgdata,m)
}

#	Function: imgFreiChen
#		Applies convolution with the Frei-Chen Edge Detection kernel matrix
#
#	Parameters:
#		imgdata - The image data.
#
#	Returns:
#		An edge enhaced image
#
imgFreiChen <- function(imgdata){
	data <- c(1,0,-1,sqrt(2),0,-sqrt(2),1,0,-1)
	m <- matrix(data, 3, 3, byrow = TRUE)
	.firstOrder(imgdata,m)
}


#
#	Compass Gradient Edge Detection Operators
#

#	Function: .compassGradient
#		Applies convolution for 8 different masks (each one 45 degrees clockwise rotation of given matrix)
#
#	Parameters:
#		imgdata - The image data
#		matrix - base mask
#
#	Returns:
#		An edge enhaced image
#
.compassGradient <- function (imgdata, matrix){
	conv <- imgConvolve(imgdata, matrix)
	max <- conv
	for (i in 1:7){
		matrix <- .mrotate(matrix)
		conv <- imgConvolve(imgdata, matrix)
		max <- imgMaximum(list(conv, max))
	}
}

#	Function: .mrotate
#		Rotates a 3x3 matrix 45 degrees clockwise
#
#	Parameters:
#		matrix - matrix to be rotated
#
#	Returns:
#		A 45 degrees clockwise rotated image
#
.mrotate <- function(matrix){
	if (dim(matrix)[1] != 3 || dim(matrix)[2] != 3) stop ("'matrix' must be a 3x3 matrix")
	data <- array(0,9)
	res <- matrix(data, 3, 3, TRUE)
	res[2,2] <- matrix[2,2]
	for (i in 1:2){
		res[1,i] <- matrix[1,i+1]
		res[i,3] <- matrix[i+1,3]
	}
	for (i in 2:3){
		res[3,i] <- matrix[3,i-1]
		res[i,1] <- matrix[i-1,1]
	}
	res
}

#	Function: .mrotate90
#		Rotates a 3x3 matrix 90 degrees clockwise
#
#	Parameters:
#		matrix - matrix to be rotated
#
#	Returns:
#		A 90 degrees clockwise rotated image
#
.mrotate90 <- function(matrix){
	if (dim(matrix)[1] != 3 || dim(matrix)[2] != 3) stop ("'matrix' must be a 3x3 matrix")
	data <- array(0,9)
	res <- matrix(data, 3, 3, TRUE)
	for(i in 1:3){
		for(j in 1:3){
			res[i,j] <- matrix[j,4-i]
		}
	}
	res
}

#	Function: imgPrewittCompassGradient
#		Applies convolution with the Prewitt compass gradient method
#
#	Parameters:
#		imgdata - The image data.
#
#	Returns:
#		An edge enhaced image
#
imgPrewittCompassGradient <- function (imgdata){
	data <- c(1,1,-1,1,-2,-1,1,1,-1)
	m <- matrix(data, 3, 3, byrow = TRUE)
	.compassGradient(imgdata, m)
}

#	Function: imgKirsch
#		Applies convolution with the Kirsch Edge Detection method
#
#	Parameters:
#		imgdata - The image data.
#
#	Returns:
#		An edge enhaced image
#
imgKirsch <- function (imgdata){
	data <- c(5,-3,-3,5,0,-3,5,-3,-3)
	m <- matrix(data, 3, 3, byrow = TRUE)
	.compassGradient(imgdata, m)
}

#	Function: imgRobinson3Level
#		Applies convolution with the 3 level Robinson Edge Detection method
#
#	Parameters:
#		imgdata - The image data.
#
#	Returns:
#		An edge enhaced image
#
imgRobinson3Level <- function (imgdata){
	data <- c(1,0,-1,1,0,-1,1,0,-1)
	m <- matrix(data, 3, 3, byrow = TRUE)
	.compassGradient(imgdata, m)
}

#	Function: imgRobinson5Level
#		Applies convolution with the 5 level Robinson Edge Detection method
#
#	Parameters:
#		imgdata - The image data.
#
#	Returns:
#		An edge enhaced image
#
imgRobinson5Level <- function (imgdata){
	data <- c(1,0,-1,2,0,-2,1,0,-1)
	m <- matrix(data, 3, 3, byrow = TRUE)
	.compassGradient(imgdata, m)
}
