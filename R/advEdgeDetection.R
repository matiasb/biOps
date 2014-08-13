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
#	Title: Advanced Edge Detection
#


#	Function: imgMarrHildreth
#	Edge detection using Marr-Hildreth algorithm
#
#	Parameters:
#		imgdata - The image data
#		sigma - A standard deviation (for the Gaussian)
#
#	Returns:
#		The edge detected image.
#
imgMarrHildreth <- function(imgdata, sigma){
	imgmatrix <- array(imgdata) # get linear array image representations
	depth <- if (attr(imgdata, "type") == "grey") 1 else dim(imgdata)[3] # get images depth
	width <- dim(imgdata)[2]
	height <- dim(imgdata)[1]

	# call the C function for image operation
	res <- .C('marr', image=as.integer(imgmatrix),
			width=as.integer(width), height=as.integer(height), depth=as.integer(depth),
			sigma=as.double(sigma), ret=integer(width * height * depth), PACKAGE="biOps")

	imgtype <- if (depth == 1) "grey" else "rgb" # type of the result
	imgdim <- c(height, width, if (depth == 3) depth else NULL) # dim of the result
	img <- array(res$ret, dim=imgdim) # build the matrix from linear result
	imagedata(img, type=imgtype) # build the imagedata
}

#	Function: imgCanny
#	Edge detection using Canny algorithm
#
#	Parameters:
#		imgdata - The image data
#		sigma - A standard deviation (for the Gaussian)
#		low - Lower threshold
#		high - Higher threshold
#
#	Returns:
#		The edge detected image.
#
imgCanny <- function(imgdata, sigma, low=0, high=-1){
	imgmatrix <- array(imgdata) # get linear array image representations
	depth <- if (attr(imgdata, "type") == "grey") 1 else dim(imgdata)[3] # get images depth
	width <- dim(imgdata)[2]
	height <- dim(imgdata)[1]

	# call the C function for image operation
	res <- .C('canny', image=as.integer(imgmatrix),
			width=as.integer(width), height=as.integer(height), depth=as.integer(depth),
			sigma=as.double(sigma), low=as.integer(low), high=as.integer(high), PACKAGE="biOps")

	imgtype <- if (depth == 1) "grey" else "rgb" # type of the result
	imgdim <- c(height, width, if (depth == 3) depth else NULL) # dim of the result
	img <- array(res$image, dim=imgdim) # build the matrix from linear result
	imagedata(img, type=imgtype) # build the imagedata
}

#	Function: imgShenCastan
#	Edge detection using Shen and Castan algorithm
#
#	Parameters:
#		imgdata - The image data
#		smooth_factor - The smooth factor
#		thin_factor - The thin factor
#		adapt_window - The width of the adaptive window (gradient)
#		thresh_ratio - The threshold ratio
#		do_hysteresis - If true, do hysteresis
#
#	Returns:
#		The edge detected image.
#
imgShenCastan <- function(imgdata, smooth_factor=0.9, thin_factor=2, adapt_window=7, thresh_ratio=0.8, do_hysteresis=1){
	imgmatrix <- array(imgdata) # get linear array image representations
	depth <- if (attr(imgdata, "type") == "grey") 1 else dim(imgdata)[3] # get images depth
	width <- dim(imgdata)[2]
	height <- dim(imgdata)[1]

	# call the C function for image operation
	res <- .C('shen_castan', image=as.integer(imgmatrix),
			width=as.integer(width), height=as.integer(height), depth=as.integer(depth),
			smooth_factor=as.double(smooth_factor), thin_factor=as.integer(thin_factor), adapt_window = as.integer(adapt_window),
			thresh_ratio=as.double(thresh_ratio), hyst=as.integer(do_hysteresis),
			PACKAGE="biOps")

	imgtype <- if (depth == 1) "grey" else "rgb" # type of the result
	imgdim <- c(height, width, if (depth == 3) depth else NULL) # dim of the result
	img <- array(res$image, dim=imgdim) # build the matrix from linear result
	imagedata(img, type=imgtype) # build the imagedata
}
