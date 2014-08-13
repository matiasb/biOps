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
#	Title: Arithmetics Operations
#

#	Function: imgAdd
#	Adds two images.
#
#	Parameters:
#		imgdata1 - The first image.
#		imgdata2 - The second image.
#
#	Returns:
#		The two images added.
#
imgAdd <- function(imgdata1, imgdata2){
	.imgArithmeticOperator(imgdata1, imgdata2, 'add')
}

#	Function: imgDiffer
#	Substracts two images.
#
#	Parameters:
#		imgdata1 - The first image.
#		imgdata2 - The second image.
#
#	Returns:
#		The two images substracted.
#
imgDiffer <- function(imgdata1, imgdata2){
	.imgArithmeticOperator(imgdata1, imgdata2, 'differ')
}

#	Function: imgMultiply
#	Multiply two images.
#
#	Parameters:
#		imgdata1 - The first image.
#		imgdata2 - The second image.
#
#	Returns:
#		The two images product.
#
imgMultiply <- function(imgdata1, imgdata2){
	.imgArithmeticOperator(imgdata1, imgdata2, 'multiply')
}

#	Function: imgDivide
#	Divides two images.
#
#	Parameters:
#		imgdata1 - The first image.
#		imgdata2 - The second image.
#
#	Returns:
#		The two images divided.
#
imgDivide <- function(imgdata1, imgdata2){
	.imgArithmeticOperator(imgdata1, imgdata2, 'divide')
}


#	Function: .imgArithmeticOperator
#	Operate with the two images.
#
#	Parameters:
#		imgdata1 - The first image.
#		imgdata2 - The second image.
#		operator - The arithmetic operator: add | differ | multiply | divide.
#
#	Returns:
#		The result of the operation with the two images.
#
.imgArithmeticOperator <- function(imgdata1, imgdata2, operator){
	method = switch(operator, add='addition', differ='difference', multiply='product', divide='division')
	if (is.null(method)) stop('Unsupported operator')
	imgmatrix1 <- array(imgdata1) # get linear array image representations
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
	img <- array(res$image1, dim=imgdim) # build the matrix from linear result
	imagedata(img, type=imgtype) # build the imagedata
}

#	Function: imgAverage
#	Return the images average.
#
#	Parameters:
#		imgdata_list - An image list; at least one image
#
#	Returns:
#		The average of the given images.
#
imgAverage <- function(imgdata_list){
	qimgs <- length(imgdata_list) # number of images to average

	imgdata <- 0
	if (qimgs > 0){
		imgdata <- imgdata_list[[1]] # the first as base for the result
		imgmatrix <- array(imgdata)
		dims <- dim(imgdata)
		depth <- if (attr(imgdata, "type") == "grey") 1 else dims[3]

		for (k in 2:qimgs){ # accumulate the images in imgmatrix
			img <- imgdata_list[[k]]
			imgmatrix2 <- array(img)
			next_depth <- if (attr(img, "type") == "grey") 1 else dims[3]

			if (next_depth != depth){
				warning("Image does not have the same depth than the first one. Skipped")
				next
			}

			res <- .C("average", image1=as.integer(imgmatrix), image2=as.integer(imgmatrix2),
	                  width=as.integer(dims[2]), height=as.integer(dims[1]), depth=as.integer(depth),
	                  ret=integer(1), PACKAGE="biOps")
	        imgmatrix <- res$image1
		}
		imgtype <- if (depth == 1) "grey" else "rgb" # type of the result
		imgmatrix <- array(imgmatrix, dim=dims) # build the result matrix
		imgdata <- imagedata(imgmatrix/qimgs, type=imgtype) # do the average and build the imagedata
	}
	imgdata
}

#	Function: imgMaximum
#		Return the images average.
#
#	Parameters:
#		imgdata_list - An image list; at least one image
#
#	Returns:
#		The maximum of the given images.
#
imgMaximum <- function(imgdata_list){
	qimgs <- length(imgdata_list) # number of images to average

	imgdata <- 0
	if (qimgs > 0){
		imgdata <- imgdata_list[[1]] # the first as base for the result
		imgmatrix <- array(imgdata)
		dims <- dim(imgdata)
		depth <- if (attr(imgdata, "type") == "grey") 1 else dims[3]

		for (k in 2:qimgs){ # accumulate the images in imgmatrix
			img <- imgdata_list[[k]]
			imgmatrix2 <- array(img)
			next_depth <- if (attr(img, "type") == "grey") 1 else dims[3]

			if (next_depth != depth){
				warning("Image does not have the same depth than the first one. Skipped")
				next
			}

			res <- .C("maximum", image1=as.integer(imgmatrix), image2=as.integer(imgmatrix2),
	                  width=as.integer(dims[2]), height=as.integer(dims[1]), depth=as.integer(depth),
	                  ret=integer(1), PACKAGE="biOps")
	        imgmatrix <- res$image1
		}
		imgtype <- if (depth == 1) "grey" else "rgb" # type of the result
		imgmatrix <- array(imgmatrix, dim=dims) # build the result matrix
		imgdata <- imagedata(imgmatrix, type=imgtype) # do the average and build the imagedata
	}
	imgdata
}


#
#	R Implementations (slow)
#

#	Function: r_imgAdd
#	Adds two images. Implemented in R code.
#
#	Parameters:
#		imgdata1 - The first image.
#		imgdata2 - The second image.
#
#	Returns:
#		The two images added.
#
#	See Also:
#		<imgAdd>
r_imgAdd <- function(imgdata1, imgdata2){
	dims1 <- dim(imgdata1)
	dims2 <- dim(imgdata2)

	if (attr(imgdata1, "type") == "grey" || attr(imgdata2, "type") == "grey")
		stop("Images must have rgb type")

	for (i in 1:dims1[1]){
		for (j in 1:dims1[2]){
			for (d in 1:dims1[3]){
				if (i <= dims2[1] && j <= dims2[2] && d <= dims2[3]){
					res <- imgdata1[i,j,d] + imgdata2[i,j,d]
					if (res <= 255)
						imgdata1[i,j,d] = res
					else
						imgdata1[i,j,d] = 255
				}
			}
		}
	}
	imgdata1
}

#	Function: r_imgDiffer
#	Substracts two rgb images. Implemented in R code.
#
#	Parameters:
#		imgdata1 - The first image.
#		imgdata2 - The second image.
#
#	Returns:
#		The two images substracted.
#
#	See Also:
#		<imgDiffer>
r_imgDiffer <- function(imgdata1, imgdata2){
	dims1 <- dim(imgdata1)
	dims2 <- dim(imgdata2)

	if (attr(imgdata1, "type") == "grey" || attr(imgdata2, "type") == "grey")
		stop("Images must have rgb type")

	for (i in 1:dims1[1]){
		for (j in 1:dims1[2]){
			for (d in 1:dims1[3]){
				if (i <= dims2[1] && j <= dims2[2] && d <= dims2[3]){
					res <- imgdata2[i,j,d] - imgdata1[i,j,d]
					if (res < 0)
						imgdata1[i,j,d] = 0
					else
						imgdata1[i,j,d] = res
				}
			}
		}
	}
	imgdata1
}

#	Function: r_imgAverage
#	Return the rgb images average. Implemented in R code.
#
#	Parameters:
#		imgdata_list - An image list; at least one image
#
#	Returns:
#		The average of the given images.
#
#	See Also:
#		<imgAverage>
r_imgAverage <- function(imgdata_list){
	qimgs <- length(imgdata_list)

	imgdata <- 0
	if (qimgs > 0){
		imgdata <- imgdata_list[[1]]
		dims <- dim(imgdata)
		if (attr(imgdata, "type") == "grey")
			stop("Images must have rgb type")

		for (k in 2:qimgs){
			img <- imgdata_list[[k]]

			if (attr(img, "type") == "grey")
				stop("Images must have rgb type")

			for (i in 1:dims[1]){
				for (j in 1:dims[2]){
					for (d in 1:dims[3]){
						imgdata[i,j,d] = imgdata[i,j,d] + img[i,j,d]
					}
				}
			}
		}
	}
	imgdata/qimgs
}

#	Function: r_imgMaximum
#		Return the rgb images maximum. Implemented in R code.
#
#	Parameters:
#		imgdata_list - An image list; at least one image
#
#	Returns:
#		The maximum of the given images.
#
#	See Also:
#		<imgMaximum>
r_imgMaximum <- function(imgdata_list){
	qimgs <- length(imgdata_list)

	imgdata <- 0
	if (qimgs > 0){
		imgdata <- imgdata_list[[1]]
		dims <- dim(imgdata)
		if (attr(imgdata, "type") == "grey")
			stop("Images must have rgb type")

		for (k in 2:qimgs){
			img <- imgdata_list[[k]]

			if (attr(img, "type") == "grey")
				stop("Images must have rgb type")

			for (i in 1:dims[1]){
				for (j in 1:dims[2]){
					for (d in 1:dims[3]){
						imgdata[i,j,d] = max(imgdata[i,j,d], img[i,j,d])
					}
				}
			}
		}
	}
	imgdata
}
