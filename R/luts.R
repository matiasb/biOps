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
#	Title: Look-up table operations
#

# 
#	Function: imgNegative
#		Negates an image.
# 
#	Parameters:
#		imgdata - Image to be changed.
#
#	Returns:
#		The negated image.
#
#	See also:
#		<r_negative>
#		<r_negative_lut>
imgNegative <- function(imgdata){
	imgmatrix <- array(imgdata) # get linear array image representation
	depth <- if (attr(imgdata, "type") == "grey") 1 else dim(imgdata)[3] # get images depth

	# call the C function for image operation
	res <- .C("negative", image=as.integer(imgmatrix),
	          width=as.integer(dim(imgdata)[2]), height=as.integer(dim(imgdata)[1]), depth=as.integer(depth),
	          ret=integer(1), PACKAGE="biOps")

	imgtype <- if (depth == 1) "grey" else "rgb" # result's type
	imgdim <- c(res$height, res$width, if (res$depth == 3) res$depth else NULL) # result's dimension
	img <- array(res$image, dim=imgdim) # build the matrix from linear result
	imagedata(img, type=imgtype) # build the imagedata
}

#
#	Function: imgDecreaseIntensity
#		Decreases an image intensity by a given factor.
#
#	Parameters:
#		imgdata - Image to be changed.
#		percentage - A non negative 0 value representing the intensity percentage to be decreased.
#		             1 stands for 100% (eg. 0.5 = 50%)
#
#	Returns:
#		A percentage intensity decreased image.
#
#	See also:
#		<r_dec_intensity>
imgDecreaseIntensity <- function(imgdata, percentage){
	.imgIntensity(imgdata, percentage, "decreaseIntensity")
}

#
#	Function: imgIncreaseIntensity
#		Increases an image intensity by a given factor.
#
#	Parameters:
#		imgdata - Image to be changed.
#		percentage - A non negative 0 value representing the intensity percentage to be increased.
#		             1 stands for 100% (eg. 0.5 = 50%)
#
#	Returns:
#		A percentage intensity increased image.
#
#	See also:
#		<r_inc_intensity>
imgIncreaseIntensity <- function(imgdata, percentage){
	.imgIntensity(imgdata, percentage, "increaseIntensity")
}


#
#	Function: .imgIntensity
#		Modifies an image intensity by a given factor.
#
#	Parameters:
#		imgdata - Image to be changed.
#		percentage - A non negative 0 value representing the intensity percentage to be changed.
#		             1 stands for 100% (eg. 0.5 = 50%)
#		method - The C method to tall. Must be one of "increaseIntensity" or "decreaseIntensity"
#
#	Returns:
#		A percentage intensity modified image.
#
#	See also:
#		<imgIncreaseIntensity>
#		<imgDecreaseIntensity>
#		<r_inc_intensity>
#		<r_dec_intensity>
.imgIntensity <- function(imgdata, percentage, method){
	if (as.double(percentage) < 0){
		stop("percentage must be a non negative value")
	}

	imgmatrix <- array(imgdata) # get linear array image representation
	depth <- if (attr(imgdata, "type") == "grey") 1 else dim(imgdata)[3] # get images depth

	# call the C function for image operation
	res <- .C(method, image=as.integer(imgmatrix), percentage=as.double(percentage),
	          width=as.integer(dim(imgdata)[2]), height=as.integer(dim(imgdata)[1]), depth=as.integer(depth),
	          ret=integer(1), PACKAGE="biOps")

	imgtype <- if (depth == 1) "grey" else "rgb" # result's type
	imgdim <- c(res$height, res$width, if (res$depth == 3) res$depth else NULL) # result's dimension
	img <- array(res$image, dim=imgdim) # build the matrix from linear result
	imagedata(img, type=imgtype) # build the imagedata
}
	
	
#
#	Function: imgIncreaseContrast
#		Increases an image contrast by augmenting pixel values differences between given limits (in a linear fashion)
#
#	Parameters:
#		imgdata - Image to be changed.
#		min_limit - minimum limit to apply lineal modification
#		max_limit - maximum limit to apply lineal modification
#
#	Returns:
#		A contrast increased image.
#
#	See also:
#		<r_inc_contrast>
imgIncreaseContrast <- function(imgdata, min_limit, max_limit){
	if (min_limit > max_limit){
		stop ("min_limit must be greater than max_limit")
	}
	.error_range ("min_limit", min_limit, 0, 255)
	.error_range ("max_limit", max_limit, 0, 255)

	.imgContrast(imgdata, min_limit, max_limit, "increaseContrast")
}

#
#	Function: imgDecreaseContrast
#		Decreases an image contrast, leaving each pixel value between given values.
# 
#	Parameters:
#		imgdata - Image to be changed.
#		min_desired - Minimum value for result image.
#		max_desired - Maximum value for result image.
#
#	Returns:
#		A contrast decreased image.
#
#	See also:
#		<r_dec_contrast>
imgDecreaseContrast <- function(imgdata, min_desired, max_desired){
	if (min_desired > max_desired){
		stop ("min_desired must be greater than max_desired")
	}
	.error_range ("min_desired", min_desired, 0, 255)
	.error_range ("max_desired", max_desired, 0, 255)

	.imgContrast(imgdata, min_desired, max_desired, "decreaseContrast")
}

#
#	Function: .imgContrast
#		Modifies an image contrast.
# 
#	Parameters:
#		imgdata - Image to be changed.
#		min - Minimum value for method application.
#		max - Maximum value for method application.
#		method - The C method to tall. Must be one of "increaseContrast or "decreaseContrast"
#
#	Returns:
#		A contrast modified image.
#
#	See also:
#		<r_dec_contrast>
.imgContrast <- function(imgdata, min, max, method){
	imgmatrix <- array(imgdata) # get linear array image representation
	depth <- if (attr(imgdata, "type") == "grey") 1 else dim(imgdata)[3] # get images depth

	# call the C function for image operation
	res <- .C(method, image=as.integer(imgmatrix), min_desired=as.integer(min),
	           max_desired=as.integer(max), width=as.integer(dim(imgdata)[2]),
	           height=as.integer(dim(imgdata)[1]), depth=as.integer(depth),
	           ret=integer(1), PACKAGE="biOps")

	imgtype <- if (depth == 1) "grey" else "rgb" # result's type
	imgdim <- c(res$height, res$width, if (res$depth == 3) res$depth else NULL) # result's dimension
	img <- array(res$image, dim=imgdim) # build the matrix from linear result
	imagedata(img, type=imgtype) # build the imagedata
}

#
#	Function: imgThreshold
#		Thresholds an image using a given filter.
#
#	Parameters:
#		imgdata - Image to be changed.
#		thr_value: filter value for thresholding.
#
#	Returns:
#		A threshold image.
#
#	See also:
#		<r_threshold>
imgThreshold <- function(imgdata, thr_value){
	imgmatrix <- array(imgdata) # get linear array image representation
	depth <- if (attr(imgdata, "type") == "grey") 1 else dim(imgdata)[3] # get images depth

	# call the C function for image operation
	res <- .C("threshold", image=as.integer(imgmatrix), thr_value=as.integer(thr_value),
	           width=as.integer(dim(imgdata)[2]), height=as.integer(dim(imgdata)[1]), depth=as.integer(depth),
	           ret=integer(1), PACKAGE="biOps")

	imgtype <- if (depth == 1) "grey" else "rgb" # result's type
	imgdim <- c(res$height, res$width, if (res$depth == 3) res$depth else NULL) # result's dimension
	img <- array(res$image, dim=imgdim) # build the matrix from linear result
	imagedata(img, type=imgtype) # build the imagedata
}

#
#	Function: imgGamma
#		Applies gamma operation to a given image. Each pixel value is taken to the inverse of gamma_value-th exponent
#
#	Parameters:
#		imgdata - Image to be changed.
#		gamma_value - A non negative value representing operation gamma value
#
#	Returns:
#		A gamma transformed image.
#
#	See also:
#		<r_gamma_img>
imgGamma <- function(imgdata, gamma_value){
	if (as.double(gamma_value) < 0){
		stop("gamma_value must be a non negative value")
	}
	imgmatrix <- array(imgdata) # get linear array image representation
	depth <- if (attr(imgdata, "type") == "grey") 1 else dim(imgdata)[3] # get images depth

	# call the C function for image operation
	res <- .C("imgGamma", image=as.integer(imgmatrix), gamma_value=as.double(gamma_value),
	           width=as.integer(dim(imgdata)[2]), height=as.integer(dim(imgdata)[1]), depth=as.integer(depth),
	           ret=integer(1), PACKAGE="biOps")

	imgtype <- if (depth == 1) "grey" else "rgb" # result's type
	imgdim <- c(res$height, res$width, if (res$depth == 3) res$depth else NULL) # result's dimension
	img <- array(res$image, dim=imgdim) # build the matrix from linear result
	imagedata(img, type=imgtype) # build the imagedata
}

#
# R Implementations (slow)
#

# 
#	Function: r_look_up_table
#		Applies a transformation by a given table
# 
#	Parameters:
#		imgdata - Image to be changed.
#		table - value transformation table
#
#	Returns:
#		The transformed image
#
r_look_up_table <- function(imgdata, table){
	for (i in 1:length(imgdata)){
		imgdata[i] <- table[imgdata[i]+1]
	}
	imgdata
}


# 
#	Function: r_negative
#		Negates an image (R implementation).
# 
#	Parameters:
#		imgdata - Image to be changed.
#
#	Returns:
#		The negated image.
#
#	See also:
#		<imgNegative>
#		<r_negative_lut>
r_negative <- function(imgdata){
	255 - imgdata
}

# 
#	Function: r_negative_lut
#		Negates an image using look up table (R implementation).
# 
#	Parameters:
#		imgdata - Image to be changed.
#
#	Returns:
#		The negated image.
#
#	See also:
#		<imgNegative>
#		<r_negative>
r_negative_lut <- function(imgdata){
	lut <- seq(255, 0, by=-1)
	r_look_up_table(imgdata, lut)
}


#
#	Function: r_dec_intensity
#		Decreases an image intensity by a given factor.
#
#	Parameters:
#		imgdata - Image to be changed.
#		percentage - A non negative 0 value representing the intensity percentage to be decreased.
#		             1 stands for 100% (eg. 0.5 = 50%)
#
#	Returns:
#		A percentage intensity decreased image.
#
#	See also:
#		<imgDecreaseIntensity>
r_dec_intensity <- function(imgdata, percentage){
	if (as.double(percentage) < 0){
		stop("percentage must be a non negative value")
	}
	lut <- array(0, 256)
	for (i in 0:255){
		lut[i+1] <- max(as.integer(i - i * percentage), 0)
	}
	r_look_up_table(imgdata, lut)
}

#
#	Function: r_inc_intensity
#		Increases an image intensity by a given factor.
#
#	Parameters:
#		imgdata - Image to be changed.
#		percentage - A non negative 0 value representing the intensity percentage to be increased.
#		             1 stands for 100% (eg. 0.5 = 50%)
#
#	Returns:
#		A percentage intensity increased image.
#
#	See also:
#		<imgIncreaseIntensity>
r_inc_intensity <- function(imgdata, percentage){
	if (as.double(percentage) < 0){
		stop("percentage must be a non negative value")
	}
	lut <- array(0, 256)
	for (i in 0:255){
		lut[i+1] <- min (as.integer(i + i * percentage), 255)
	}
	r_look_up_table(imgdata, lut)
}


#
#	Function: r_inc_contrast
#		Increases an image contrast by augmenting pixel values differences between given limits (in a linear fashion)
#
#	Parameters:
#		imgdata - Image to be changed.
#		min_limit - minimum limit to apply lineal modification
#		max_limit - maximum limit to apply lineal modification
#
#	Returns:
#		A contrast increased image.
#
#	See also:
#		<imgIncreaseContrast>
r_inc_contrast <- function(imgdata, min_limit, max_limit){
	if (min_limit > max_limit){
		stop ("min_limit must be greater than max_limit")
	}
	.error_range ("min_limit", min_limit, 0, 255)
	.error_range ("max_limit", max_limit, 0, 255)

	lut <- array(0, 256)
	for (i in 0:(min_limit-1)) lut[i+1] <- 0
	for (i in min_limit:(max_limit-1)) lut[i+1] <- as.integer(((i-min_limit)*255)/(max_limit-min_limit))
	for (i in max_limit:255) lut[i+1] <- 255
	r_look_up_table(imgdata, lut)
}

#
#	Function: r_dec_contrast
#		Decreases an image contrast, leaving each pixel value between given values (R implementation).
# 
#	Parameters:
#		imgdata - Image to be changed.
#		min_desired - Minimum value for result image.
#		max_desired - Maximum value for result image.
#
#	Returns:
#		A contrast decreased image.
#
#	See also:
#		<imgDecreaseContrast>
r_dec_contrast <- function(imgdata, min_desired, max_desired){
	if (min_desired > max_desired){
		stop ("min_desired must be greater than max_desired")
	}
	.error_range ("min_desired", min_desired, 0, 255)
	.error_range ("max_desired", max_desired, 0, 255)
	
	lut <- array(0, 256)
	for (i in 0:255){
		lut[i+1] <- (as.integer(i * (max_desired - min_desired)) / 255) + min_desired
	}
	r_look_up_table(imgdata, lut)
}

#
#	Function: r_threshold
#		Thresholds an image using a given filter (R implementation).
#
#	Parameters:
#		imgdata - Image to be changed.
#		thr_value: filter value for thresholding.
#
#	Returns:
#		A threshold image.
#
#	See also:
#		<imgThreshold>
r_threshold <- function(imgdata, thr_value){
	# We set pixel value to 0 or 1 wheather it passes thr_value or not
	
	lut <- array(0, 256)
	for (i in 0:(thr_value-1)){
		lut[i+1] <- 0
	}
	for (i in thr_value:255){
		lut[i+1] <- 255
	}
	r_look_up_table(imgdata, lut)
}

#
#	Function: r_gamma
#		Applies gamma operation to a given image. Each pixel value is taken to the inverse of gamma_value-th exponent
#
#	Parameters:
#		imgdata - Image to be changed.
#		gamma_value - A non negative value representing operation gamma value
#
#	Returns:
#		A gamma transformed image.
#
#	See also:
#		<imgGamma>
r_gamma <- function(imgdata, gamma_value){
	if (as.double(gamma_value) < 0){
		stop("gamma_value must be a non negative value")
	}
	
	lut <- array(0, 256)
	# We raise to the (gamma_value)th power
	for (i in 0:255){
		lut[i+1] <- as.integer(((i/255) ** (1/gamma_value))*255)
	}
	r_look_up_table(imgdata, lut)
}
