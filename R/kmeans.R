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
#	Title: K Means Classification
#


#	Function: imgKMeans
#	K Means straightforward classification algorithm
#
#	Parameters:
#		imgdata - The image data.
#		k - Number of clusters
#		maxit - Max number of iterations
#		mean_colors - Use the cluster values as colors for clusters?
#
#	Returns:
#		The image classified using the parameters given.
#
imgKMeans <- function(imgdata, k, maxit=10){
	imgmatrix <- array(imgdata) # get linear array image representations
	depth <- if (attr(imgdata, "type") == "grey") 1 else dim(imgdata)[3] # get images depth
	width <- dim(imgdata)[2]
	height <- dim(imgdata)[1]
	mean_colors=TRUE

	# call the C function for image operation
	res <- .C("kmeans", image=as.integer(imgmatrix),
			width=as.integer(width), height=as.integer(height), depth=as.integer(depth),
			k=as.integer(k), maxit=as.integer(maxit), colors=as.integer(mean_colors),
			ret=integer(height*width*depth), PACKAGE="biOps")

	imgtype <- if (depth == 1) "grey" else "rgb" # type of the result
	imgdim <- c(height, width, if (depth == 3) depth else NULL) # dim of the result
	img <- array(res$ret, dim=imgdim) # build the matrix from linear result
	imagedata(img, type=imgtype) # build the imagedata
}


#	Function: imgEKMeans
#	K Means enhanced classification algorithm; it avoid some comparisons
#	in the clustering iteration, keeping info of the previous iterations
#	and the distance to the centroids.
#
#	Parameters:
#		imgdata - The image data.
#		k - Number of clusters
#		maxit - Max number of iterations
#		mean_colors - Use the cluster values as colors for clusters?
#
#	Returns:
#		The image classified using the parameters given.
#
imgEKMeans <- function(imgdata, k, maxit=10){
	imgmatrix <- array(imgdata) # get linear array image representations
	depth <- if (attr(imgdata, "type") == "grey") 1 else dim(imgdata)[3] # get images depth
	width <- dim(imgdata)[2]
	height <- dim(imgdata)[1]
	mean_colors=TRUE

	# call the C function for image operation
	res <- .C("kmeans_enhanced", image=as.integer(imgmatrix),
			width=as.integer(width), height=as.integer(height), depth=as.integer(depth),
			k=as.integer(k), maxit=as.integer(maxit), colors=as.integer(mean_colors),
			ret=integer(height*width*depth), PACKAGE="biOps")

	imgtype <- if (depth == 1) "grey" else "rgb" # type of the result
	imgdim <- c(height, width, if (depth == 3) depth else NULL) # dim of the result
	img <- array(res$ret, dim=imgdim) # build the matrix from linear result
	imagedata(img, type=imgtype) # build the imagedata
}

#	Function: imgKDKMeans
#	K Means classification algorithm that uses KDTrees for resolving the
#	nearest neighbor queries; mainly useful if k is big.
#
#	Parameters:
#		imgdata - The image data.
#		k - Number of clusters
#		maxit - Max number of iterations
#		mean_colors - Use the cluster values as colors for clusters?
#
#	Returns:
#		The image classified using the parameters given.
#
imgKDKMeans <- function(imgdata, k, maxit=10){
	imgmatrix <- array(imgdata) # get linear array image representations
	depth <- if (attr(imgdata, "type") == "grey") 1 else dim(imgdata)[3] # get images depth
	width <- dim(imgdata)[2]
	height <- dim(imgdata)[1]
	mean_colors=TRUE

	# call the C function for image operation
	res <- .C("kdtree_kmeans", image=as.integer(imgmatrix),
			width=as.integer(width), height=as.integer(height), depth=as.integer(depth),
			k=as.integer(k), maxit=as.integer(maxit), colors=as.integer(mean_colors),
			ret=integer(height*width*depth), PACKAGE="biOps")

	imgtype <- if (depth == 1) "grey" else "rgb" # type of the result
	imgdim <- c(height, width, if (depth == 3) depth else NULL) # dim of the result
	img <- array(res$ret, dim=imgdim) # build the matrix from linear result
	imagedata(img, type=imgtype) # build the imagedata
}
