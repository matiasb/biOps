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
#	Title: Morphologic Operations
#

# Algorithms for image processing and computer vision - J.R.Parker


# 
#	Function: .imgGrayMorphologic
#		Common interface to all C calls to morphologic operations
# 
#	Parameters:
#		imgdata - Image to be modified
#		mask - The mask to be applied
#		method - C method name to call
# 
#	Returns:
#		The dilated image
# 
.imgGrayMorphologic <- function(imgdata, mask, method){
	if (attr(imgdata, "type") != "grey") stop("This method accepts only 1-channel images")
	if (attr(mask, "type") != "grey") stop("This method accepts only 1-channel masks")
	imgmatrix <- array(imgdata) # get linear array image representations
	width <- dim(imgdata)[2]
	height <- dim(imgdata)[1]
	mask_width <- dim(mask)[2]
	mask_height <- dim(mask)[1]
	
	# call the C function for image operation
	res <- .C(method, image=as.integer(imgmatrix), width=as.integer(width), 
			  height=as.integer(height), mask=as.integer(mask), mask_width=as.integer(mask_width),
			  mask_height=as.integer(mask_height), ret=integer(width * height), PACKAGE="biOps")
	imgdim <- c(height, width, NULL) # dim of the result
	img <- array(res$ret, dim=imgdim) # build the matrix from linear result
	imagedata(img, type="grey") # build the imagedata
}


# 
# 	Function: imgBinaryDilation
# 		Makes a Dilation of a binary image with a given mask. This is, it applies the mask in every image pixel:
# 		 when reached a black point, it turns every image's mask black point into black.
# 
# 	Parameters:
# 		imgdata - Image to be dilated
# 		mask - The mask to be applied
# 
# 	Returns:
# 		The dilated image
# 
imgBinaryDilation <- function(imgdata, mask){
	.imgGrayMorphologic(imgdata, mask, "binaryDilation")
}

# 
#	Function: imgGrayScaleDilation
#		Makes an dilation of a gray scale image with a given mask. This is, it applies the mask in every image pixel and sets
#		 current point to the maximum of the sums of the corresponding pair of pixel values in the mask and image.
# 
#	Parameters:
#		image - Image to be dilated
#		mask - The mask to be applied
# 
#	Returns:
#		The dilated image
# 
imgGrayScaleDilation <- function(imgdata, mask){
	.imgGrayMorphologic (imgdata, mask, "grayScaleDilation")
}

# 
# 	Function: imgBinaryErosion
# 		Makes an Erosion of a binary image with a given mask. This is, it applies the mask in every image pixel:
# 		 when the mask matches completely, it turns its images' center into a black point
# 
# 	Parameters:
# 		image - Image to be eroded
# 		mask - The mask to be applied
# 
# 	Returns:
# 		The eroded image
# 
imgBinaryErosion <- function(imgdata, mask){
	.imgGrayMorphologic(imgdata, mask, "binaryErosion")
}

# 
#	Function: imgGrayScaleErosion
#		Makes an erosion of a gray scale image with a given mask. This is, it applies the mask in every image pixel and sets
#		 current point to the minimum of the sums of the corresponding pair of pixel values in the mask and image.
# 
#	Parameters:
#		image - Image to be eroded
#		mask - The mask to be applied
# 
#	Returns:
#		The eroded image
# 
imgGrayScaleErosion <- function(imgdata, mask){
	.imgGrayMorphologic (imgdata, mask, "grayScaleErosion")
}

# 
# 	Function: imgStdBinaryDilation
# 		Makes a Dilation of a binary image with a 0-squared mask, with given dimension.
# 
# 	Parameters:
# 		imgdata - Image to be dilated
# 		dim - dimension of the 0-squared mask
# 
# 	Returns:
# 		The dilated image
#
#	See also:
#		imgBinaryDilation
# 
imgStdBinaryDilation <- function(imgdata, dim=3){
	mat <- matrix (0, dim, dim)
	mask <- imagedata (mat, "grey")
	imgBinaryDilation (imgdata, mask)
}

# 
# 	Function: imgStdBinaryErosion
# 		Makes an Erosion of a binary image with a 0-squared mask, with given dimension.
# 
# 	Parameters:
# 		imgdata - Image to be eroded
# 		dim - dimension of the 0-squared mask
# 
# 	Returns:
# 		The eroded image
#
#	See also:
#		imgBinaryErosion
# 
imgStdBinaryErosion <- function(imgdata, dim=3){
	mat <- matrix (0, dim, dim)
	mask <- imagedata (mat, "grey")
	imgBinaryErosion (imgdata, mask)
}

# 
# 	Function: imgBinaryOpening
# 		Applies an Erosion inmediatly followed by a Dilation to the given image
# 
# 	Parameters:
# 		imgdata - Image to be 'opened'
# 		mask - Mask to apply
# 
# 	Returns:
# 		The 'opened' image
#
#	See also:
#		imgBinaryErosion
#		imgBinaryDilation
# 
imgBinaryOpening <- function(imgdata, mask){
	imgdata <- imgBinaryErosion(imgdata, mask)
	imgBinaryDilation(imgdata, mask)
}

# 
# 	Function: imgGrayScaleOpening
# 		Applies an Erosion inmediatly followed by a Dilation to the given image
# 
# 	Parameters:
# 		imgdata - Image to be 'opened'
# 		mask - Mask to apply
# 
# 	Returns:
# 		The 'opened' image
#
#	See also:
#		imgGrayScaleErosion
#		imgGrayScaleDilation
# 
imgGrayScaleOpening <- function(imgdata, mask){
	imgdata <- imgGrayScaleErosion(imgdata, mask)
	imgGrayScaleDilation(imgdata, mask)
}

# 
# 	Function: imgBinaryClosing
# 		Applies an Dilation inmediatly followed by a Erosion to the given image
# 
# 	Parameters:
# 		imgdata - Image to be 'closed'
# 		mask - Mask to apply
# 
# 	Returns:
# 		The 'closed' image
#
#	See also:
#		imgBinaryErosion
#		imgBinaryDilation
# 
imgBinaryClosing <- function(imgdata, mask){
	imgdata <- imgBinaryDilation(imgdata, mask)
	imgBinaryErosion(imgdata, mask)
}

# 
# 	Function: imgGrayScaleClosing
# 		Applies an Dilation inmediatly followed by a Erosion to the given image
# 
# 	Parameters:
# 		imgdata - Image to be 'closed'
# 		mask - Mask to apply
# 
# 	Returns:
# 		The 'closed' image
#
#	See also:
#		imgGrayScaleErosion
#		imgGrayScaleDilation
# 
imgGrayScaleClosing <- function(imgdata, mask){
	imgdata <- imgGrayScaleDilation(imgdata, mask)
	imgGrayScaleErosion(imgdata, mask)
}

# 
# 	Function: imgStdBinaryOpening
# 		Applies a Binary Opening with a 0-squared mask, with given dimension
# 
# 	Parameters:
# 		imgdata - Image to be 'opened'
# 		dim - 0-squared mask dimension
# 
# 	Returns:
# 		The 'opened' image
#
#	See also:
#		imgBinaryOpening
#		imgStdBinaryErosion
#		imgStdBinaryDilation
# 
imgStdBinaryOpening <- function(imgdata, dim=3){
	imgdata <- imgStdBinaryErosion(imgdata, dim)
	imgStdBinaryDilation(imgdata, dim)
}

# 
# 	Function: imgStdBinaryClosing
# 		Applies a Binary Closing with a 0-squared mask, with given dimension
# 
# 	Parameters:
# 		imgdata - Image to be 'closed'
# 		dim - 0-squared mask dimension
# 
# 	Returns:
# 		The 'closed' image
#
#	See also:
#		imgBinaryClosing
#		imgStdBinaryErosion
#		imgStdBinaryDilation
# 
imgStdBinaryClosing <- function(imgdata, dim=3){
	imgdata <- imgStdBinaryDilation(imgdata, dim)
	imgStdBinaryErosion(imgdata, dim)
}

# 
#	Function: imgNErosionDilation
#		Applies Erosion n times and then Dilation n times. Approach to an opening of depth N
# 
# 	Parameters:
# 		imgdata - Image to be modified
# 		mask - mask to apply the operation
#		n - times to apply each operation
# 
#	Returns:
#		The modified image
#
#	See also:
#		imgBinaryDilation
#		imgBinaryErosion
# 
imgNErosionDilation <- function(imgdata, mask, n){
	for (i in seq(1, n)){
		imgdata <- imgBinaryErosion (imgdata, mask)
	}
	for (i in seq(1, n)){
		imgdata <- imgBinaryDilation (imgdata, mask)
	}
}

# 
#	Function: imgNDilationErosion
#		Applies Dilation n times and then Erosion n times. Smoothes of irregularities of N pixels in size
#
#	Parameters:
#		imgdata - Image to be modified
#		mask - mask to apply the operation
#		n - times to apply each operation
# 
#	Returns:
#		The modified image
#
#	See also:
#		imgBinaryDilation
#		imgBinaryErosion
# 
imgNDilationErosion <- function(imgdata, mask, n){
	for (i in seq(1, n)){
		imgdata <- imgBinaryDilation (imgdata, mask)
	}
	for (i in seq(1, n)){
		imgdata <- imgBinaryErosion (imgdata, mask)
	}

}

# 
# 	Function: imgStdNErosionDilation
#		Applies Erosion n times and then Dilation n times, with a 0-squared matrix with a given dimension.
# 
#	Parameters:
#		imgdata - Image to be modified
#		n - times to apply each operation
#		dim - 0-squared mask dimension
# 
# 	Returns:
# 		The modified image
#
#	See also:
#		imgStdNErosionDilation
# 
imgStdNErosionDilation <- function (imgdata, n, dim=3){
	mat <- matrix (0, dim, dim)
	mask <- imagedata (mat, "grey")
	imgNErosionDilation (imgdata, mask, n)
}

# 
# 	Function: imgStdNDilationErosion
#		Applies Dilation n times and then Erosion n times, with a 0-squared matrix with a given dimension.
# 
#	Parameters:
#		imgdata - Image to be modified
#		n - times to apply each operation
#		dim - 0-squared mask dimension
# 
# 	Returns:
# 		The modified image
#
#	See also:
#		imgStdNDilationErosion
# 
imgStdNDilationErosion <- function (imgdata, n, dim=3){
	mat <- matrix (0, dim, dim)
	mask <- imagedata (mat, "grey")
	imgNDilationErosion (imgdata, mask, n)
}

