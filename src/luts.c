/* Copyright 2007 Walter Alini, Matías Bordese */

/*
This file is part of biOps.

    biOps is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    biOps is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with biOps; if not, write to the Free Software
    Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
*/


/*
 * Title: Look-up table operations (C code)
 */

#include <stdlib.h>
#include <math.h>
#include "defs.h"



/*
	Function: lookUpTable
		Performs an image transformation according to the "look up table" given
 
	Parameters:
		image - Image to be changed.
		width - Image width.
		height - Image height.
		depth - Image color depth.
		table - Look-up table. This table defines operation transformation

	Returns:
		ret - -1 if error, 1 if success.
		image - The image transformed by the given look-up table
*/
void lookUpTable(int *image, int *width, int *height, int *depth, int *table){
	int i;
	int plane_size = *width * *height * *depth;
	
	for (i = 0; i < plane_size; i++){
		image[i] = table[image[i]];
	}
	
	return;
}

/*
	Function: negative
		Negates an image.
 
	Parameters:
		image - Image to be changed.
		width - Image width.
		height - Image height.
		depth - Image color depth.

	Returns:
		ret - -1 if error, 1 if success.
		image - The negated image.
*/
void negative(int *image, int *width, int *height, int *depth, int *ret){
	int i = 0;
	int lut[MAX_PIXEL_VALUE_PLUS_1];
	
	for (i = MIN_PIXEL_VALUE; i < MAX_PIXEL_VALUE_PLUS_1; i++){
		lut[i] = MAX_PIXEL_VALUE - i;
	}
	
	lookUpTable (image, width, height, depth, lut);
	*ret = 1;
	return;
}

/*
	Function: decreaseIntensity
		Decreases an image intensity by a given factor.
 
	Parameters:
		image - Image to be changed.
		percentage -  A non negative value representing the intensity percentage to be decreased.
		width - Image width.
		height - Image height.
		depth - Image color depth.

	Returns:
		ret - -1 if error, 1 if success.
		image - An intensity decreased image.
*/
void decreaseIntensity(int *image, double *percentage, int *width, int *height, int *depth, int *ret){
	int i = 0;
	int lut[MAX_PIXEL_VALUE_PLUS_1];

	for (i = MIN_PIXEL_VALUE; i < MAX_PIXEL_VALUE_PLUS_1; i++){
		lut[i] = MAX((int) (i - (i * *percentage)), MIN_PIXEL_VALUE);
	}

	lookUpTable (image, width, height, depth, lut);
	*ret = 1;
	return;
}

/*
	Function: increaseIntensity
		Increases an image intensity by a given factor.
 
	Parameters:
		image - Image to be changed.
		percentage -  A non negative value representing the intensity percentage to be increased.
		width - Image width.
		height - Image height.
		depth - Image color depth.

	Returns:
		ret - -1 if error, 1 if success.
		image - An intensity increased image.
*/
void increaseIntensity(int *image, double *percentage, int *width, int *height, int *depth, int *ret){
	int i = 0;
	int lut[MAX_PIXEL_VALUE_PLUS_1];

	for (i = MIN_PIXEL_VALUE; i < MAX_PIXEL_VALUE_PLUS_1; i++){
		lut[i] = MIN((int) (i + i * *percentage), MAX_PIXEL_VALUE);
	}

	lookUpTable (image, width, height, depth, lut);
	*ret = 1;
	return;
}

/*
	Function: increaseContrast
		Increases an image contrast.

	Parameters:
		image - Image to be changed.
		min_limit - minimum limit to apply lineal modification
		max_limit - maximum limit to apply lineal modification
		width - Image width.
		height - Image height.
		depth - Image color depth.

	Returns:
		ret - -1 if error, 1 if success.
		image - A contrast increased image.
*/
void increaseContrast(int *image, int *min_limit, int *max_limit, int *width, int *height, int *depth, int *ret){
	int i = 0;
	int lut[MAX_PIXEL_VALUE_PLUS_1];
	
	/* assert (min_limit <= max_limit) */

	for (i = MIN_PIXEL_VALUE; i < *min_limit; i++){
		lut[i] = MIN_PIXEL_VALUE;
	}
	for (i = *min_limit; i < *max_limit + 1; i++){
		lut[i] = (int)(((i - *min_limit)*MAX_PIXEL_VALUE)/(*max_limit - *min_limit));
	}
	for (i = *max_limit; i < MAX_PIXEL_VALUE_PLUS_1; i++){
		lut[i] = MAX_PIXEL_VALUE;
	}
	
	lookUpTable (image, width, height, depth, lut);
	*ret = 1;
	return;
}

/*
	Function: decreaseContrast
		Decreases an image contrast, leaving each pixel value between given values.
 
	Parameters:
		image - Image to be changed.
		min_desired - Minimum value for result image.
		max_desired - Maximum value for result image.
		width - Image width.
		height - Image height.
		depth - Image color depth.

	Returns:
		ret - -1 if error, 1 if success.
		image - A contrast decreased image.
*/
void decreaseContrast(int *image, int *min_desired, int *max_desired, int *width, int *height, int *depth, int *ret){
	int i = 0;
	int lut[MAX_PIXEL_VALUE_PLUS_1];
	
	for (i = MIN_PIXEL_VALUE; i < MAX_PIXEL_VALUE_PLUS_1; i++){
		lut[i] = (i * (*max_desired - *min_desired) / MAX_PIXEL_VALUE) + *min_desired;
	}
	
	lookUpTable (image, width, height, depth, lut);
	*ret = 1;
	return;
}

/*
	Function: threshold
		Thresholds an image using a giver filter.

	Parameters:
		image - Image to be changed.
		thr_value - filter value for thresholding.
		width - Image width.
		height - Image height.
		depth - Image color depth.

	Returns:
		ret - -1 if error, 1 if success.
		image - A threshold im image.
*/
void threshold(int *image, int *thr_value, int *width, int *height, int *depth, int *ret){
	int i = 0;
	int lut[MAX_PIXEL_VALUE_PLUS_1];
	
	for (i = MIN_PIXEL_VALUE; i < *thr_value; i++){
		lut[i] = MIN_PIXEL_VALUE;
	}
	for (i = *thr_value; i < MAX_PIXEL_VALUE_PLUS_1; i++){
		lut[i] = MAX_PIXEL_VALUE;
	}
	
	lookUpTable (image, width, height, depth, lut);
	*ret = 1;
	return;
}

/*
	Function: imgGamma
		Applies gamma operation to a given image, using given value.

	Parameters:
		image - Image to be changed.
		thr_value - filter value for thresholding.
		width - Image width.
		height - Image height.
		depth - Image color depth.
		gamma_value - Gamma value for operation.

	Returns:
		ret - -1 if error, 1 if success.
		image - A gamma transformed image.
*/
void imgGamma (int *image, double *gamma_value, int *width, int *height, int *depth, int *ret){
	int i = 0;
	int lut[MAX_PIXEL_VALUE_PLUS_1];
	
	for (i = MIN_PIXEL_VALUE; i < MAX_PIXEL_VALUE_PLUS_1; i++){
		lut[i] = (int)(pow(i/255.0, 1.0/ *gamma_value)*255);
	}
	
	lookUpTable (image, width, height, depth, lut);
	*ret = 1;
	return;
}

