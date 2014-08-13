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
#	Title: Crop Operation
#

# 	Function: imgCrop
# 		Crops an image
# 
# 	Parameters:
# 		imgdata - Image to be cropped
# 		x_start - Upper left x coordinate of source block
# 		y_start - Upper left y coordinate of source block
# 		c_width - block's width
# 		c_height - block's height
# 
# 	Returns:
# 		The cropped image
imgCrop <- function(imgdata, x_start, y_start, c_width, c_height){
	imgmatrix <- array(imgdata) # get linear array image representation
	depth <- if (attr(imgdata, "type") == "grey") 1 else dim(imgdata)[3] # get images depth
	
	rows <- as.integer(dim(imgdata)[1])
	cols <- as.integer(dim(imgdata)[2])
	width <- as.integer(c_width)
	height <- as.integer(c_height)

	.error_range("x_start", x_start, 0, cols)
	.error_range("y_start", y_start, 0, rows)
	.error_range("c_width", c_width, 1, cols - x_start + 1)
	.error_range("c_height", c_height, 1, rows - y_start + 1)

	# call the C function for image operation
	res <- .C("crop", image=as.integer(imgmatrix), width=cols, height=rows, depth=as.integer(depth),
	           x_start=as.integer(x_start), y_start=as.integer(y_start), c_width=width, c_height=height,
	           ret=integer(width*height*depth), PACKAGE="biOps")

	imgtype <- if (depth == 1) "grey" else "rgb" # result's type
	imgdim <- c(height, width, if (res$depth == 3) res$depth else NULL) # result's dimension
	img <- array(res$ret, dim=imgdim) # build the matrix from linear result
	imagedata(img, type=imgtype) # build the imagedata
}
