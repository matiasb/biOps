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
#	Title: Translate Operations
#

# 	Function: imgTranslate
# 		Translates an image block to a given area
# 
# 	Parameters:
# 		imgdata - Image to be changed
# 		x_start - Upper left x coordinate of source block
# 		y_start - Upper left y coordinate of source block
# 		x_end - Upper left x coordinate of destination block
# 		y_end - Upper left y coordinate of destination block
# 		t_width - block to move's width
# 		t_height - block to move's height
# 
# 	Returns:
# 		The translated image
imgTranslate <- function(imgdata, x_start, y_start, x_end, y_end, t_width, t_height){
	imgmatrix <- array(imgdata) # get linear array image representation
	depth <- if (attr(imgdata, "type") == "grey") 1 else dim(imgdata)[3] # get images depth
	
	rows <- as.integer(dim(imgdata)[1])
	cols <- as.integer(dim(imgdata)[2])

	.error_range("x_start", x_start, 0, cols)
	.error_range("y_start", y_start, 0, rows)
	.error_range("x_end", x_end, 0, cols)
	.error_range("y_end", y_end, 0, rows)
	.warning_range("t_width", t_width, 0, cols - x_end)
	.warning_range("t_height", t_height, 0, rows - y_end)

	# call the C function for image operation
	res <- .C("translate", image=as.integer(imgmatrix), width=cols, height=rows, depth=as.integer(depth),
	           x_start=as.integer(x_start), y_start=as.integer(y_start), x_end=as.integer(x_end),
	           y_end=as.integer(y_end), t_width=as.integer(t_width), t_height=as.integer(t_height), PACKAGE="biOps")

	imgtype <- if (depth == 1) "grey" else "rgb" # result's type
	imgdim <- c(res$height, res$width, if (res$depth == 3) res$depth else NULL) # result's dimension
	img <- array(res$image, dim=imgdim) # build the matrix from linear result
	imagedata(img, type=imgtype) # build the imagedata
}


