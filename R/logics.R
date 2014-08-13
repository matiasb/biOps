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
#	Title: Logic Operations
#

#	Function: imgAND
#	Do the conjunction of the two images.
#
#	Parameters:
#		imgdata1 - The first image.
#		imgdata2 - The second image.
#
#	Returns:
#		The AND of the two images, bit a bit.
#
imgAND <- function(imgdata1, imgdata2){
	.imgLogicOperator(imgdata1, imgdata2, 'and')
}


#	Function: imgOR
#	Do the disjunction of the two images.
#
#	Parameters:
#		imgdata1 - The first image.
#		imgdata2 - The second image.
#
#	Returns:
#		The OR of the two images, bit a bit.
#
imgOR <- function(imgdata1, imgdata2){
	.imgLogicOperator(imgdata1, imgdata2, 'or')
}

#	Function: imgXOR
#	Do the exclusive disjunction of the two images.
#
#	Parameters:
#		imgdata1 - The first image.
#		imgdata2 - The second image.
#
#	Returns:
#		The XOR of the two images, bit a bit.
#
imgXOR <- function(imgdata1, imgdata2){
	.imgLogicOperator(imgdata1, imgdata2, 'xor')
}

#	Function: .imgLogicOperator
#	Do the logic operation of the two images.
#
#	Parameters:
#		imgdata1 - The first image.
#		imgdata2 - The second image.
#		operator - The logic operator: and | or | xor.
#
#	Returns:
#		The operation of the two images, bit a bit.
#
.imgLogicOperator <- function(imgdata1, imgdata2, operator){
	method = switch(operator, and='conjunction', or='disjunction', xor='xdisjunction')
	if (is.null(method)) stop('Unsupported operator')
	imgmatrix1 <- array(imgdata1) # get linear representations
	imgmatrix2 <- array(imgdata2)
	depth1 <- if (attr(imgdata1, "type") == "grey") 1 else dim(imgdata1)[3] # get images depth
	depth2 <- if (attr(imgdata2, "type") == "grey") 1 else dim(imgdata2)[3]

	if (depth1 != depth2)
		stop("Images must have the same color depth")

	# call the C function for image operation
	res <- .C(method, image1=as.integer(imgmatrix1),
			width1=as.integer(dim(imgdata1)[2]), height1=as.integer(dim(imgdata1)[1]), depth1=as.integer(depth1),
			image2=as.integer(imgmatrix2),
			width2=as.integer(dim(imgdata2)[2]), height2=as.integer(dim(imgdata2)[1]), depth2=as.integer(depth2),
			ret=integer(1), PACKAGE="biOps")

	imgtype <- if (depth1 == 1) "grey" else "rgb" # type of the result
	imgdim <- c(res$height1, res$width1, if (res$depth1 == 3) res$depth1 else NULL) # dim of the result
	img <- array(res$image1, dim=imgdim) # build result matrix
	imagedata(img, type=imgtype) # build the imagedata
}
