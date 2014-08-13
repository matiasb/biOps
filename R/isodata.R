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
#	Title: Isodata Classification
#


#	Function: imgIsoData
#	Isodata classification algorithm
#
#	Parameters:
#		imgdata - The image data.
#		k - Number of clusters
#		min_dist - Min distance between clusters' centroids
#		min_elems - Min elements per cluster
#		split_sd - Standard deviation threshold for splitting operation
#		iter_start - Max number of forgy iterations
#		max_merge - Max number of cluster merger per iteration
#		max_iter - Max number of iterations of the algorithm
#
#	Returns:
#		The image classified using the parameters given.
#
imgIsoData <- function(imgdata, k, min_dist=1, min_elems=1, split_sd=0.1, iter_start=5, max_merge=2, max_iter=10){
	imgmatrix <- array(imgdata) # get linear array image representations
	depth <- if (attr(imgdata, "type") == "grey") 1 else dim(imgdata)[3] # get images depth
	width <- dim(imgdata)[2]
	height <- dim(imgdata)[1]

	# call the C function for image operation
	res <- .C("isodata", image=as.integer(imgmatrix),
			width=as.integer(width), height=as.integer(height), depth=as.integer(depth),
			k=as.integer(k), min_dist=as.double(min_dist), min_elems=as.integer(min_elems),
			split_size=as.double(split_sd), iter_start=as.integer(iter_start),
			max_merge=as.integer(max_merge), max_iter=as.integer(max_iter),
			ret=integer(height*width*depth), PACKAGE="biOps")

	imgtype <- if (depth == 1) "grey" else "rgb" # type of the result
	imgdim <- c(height, width, if (depth == 3) depth else NULL) # dim of the result
	img <- array(res$ret, dim=imgdim) # build the matrix from linear result
	imagedata(img, type=imgtype) # build the imagedata
}

