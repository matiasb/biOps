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
	Title: Arithmetics Operations (C code)
*/

#include "defs.h"

/*
	Function: addition
		Adds two images.

	Parameters:
		image1 - The first image.
		width1 - The width of the first image.
		height1 - Its height.
		depth1 - Its color depth.
		image2 - The second image.
		width2 - The width of the second image.
		height2 - Its height.
		depth2 - Its color depth.

	Returns:
		ret - -1 if there is an error, 1 if success.
		image1 - The two images added; the added region corresponds to the smaller of the images. The result image is clipped.
*/
void addition(int *image1, int *width1, int *height1, int *depth1, int *image2, int *width2, int *height2, int *depth2, int *ret){
	int i = 0, j = 0, d = 0;

	if (*depth1 != *depth2){ /* if different depth => error */
		*ret = -1;
		return;
	}

	for (i = 0; i < *height1; i++){ /* image1 as base */
		for (j = 0; j < *width1; j++){
			for (d = 0; d < *depth1; d++){
				if (i < *height2 && j < *width2){
					int index1 = IMGPOS(j, i, d, *width1, *height1);
					int index2 = IMGPOS(j, i, d, *width2, *height2);
					int res = image1[index1] + image2[index2]; /* the addition */
					image1[index1] = MIN(res, MAX_PIXEL_VALUE);
				}
			}
		}
	}

	*ret = 1;
	return;
}

/*
	Function: difference
	Substracts two images.

	Parameters:
		image1 - The first image.
		width1 - The width of the first image.
		height1 - Its height.
		depth1 - Its color depth.
		image2 - The second image.
		width2 - The width of the second image.
		height2 - Its height.
		depth2 - Its color depth.

	Returns:
		ret - -1 if there is an error, 1 if success.
		image1 - The two images substracted (image1 minus image2); the substracted region corresponds to the smaller of the images. 
		The result image is clipped.
*/
void difference(int *image1, int *width1, int *height1, int *depth1, int *image2, int *width2, int *height2, int *depth2, int *ret){
	int i = 0, j = 0, d = 0;

	if (*depth1 != *depth2){
		*ret = -1;
		return;
	}

	for (i = 0; i < *height1; i++){
		for (j = 0; j < *width1; j++){
			for (d = 0; d < *depth1; d++){
				if (i < *height2 && j < *width2){
					int index1 = IMGPOS(j, i, d, *width1, *height1);
					int index2 = IMGPOS(j, i, d, *width2, *height2);
					int res = image1[index1] - image2[index2]; /* the difference */
					image1[index1] = MAX(res, MIN_PIXEL_VALUE);
				}
			}
		}
	}

	*ret = 1;
	return;
}

/*
	Function: product
	Multiply two images.

	Parameters:
		image1 - The first image.
		width1 - The width of the first image.
		height1 - Its height.
		depth1 - Its color depth.
		image2 - The second image.
		width2 - The width of the second image.
		height2 - Its height.
		depth2 - Its color depth.

	Returns:
		ret - -1 if there is an error, 1 if success.
		image1 - The product of the two images; the product region corresponds to the smaller of the images. The result image is clipped.
*/
void product(int *image1, int *width1, int *height1, int *depth1, int *image2, int *width2, int *height2, int *depth2, int *ret){
	int i = 0, j = 0, d = 0;

	if (*depth1 != *depth2){
		*ret = -1;
		return;
	}

	for (i = 0; i < *height1; i++){
		for (j = 0; j < *width1; j++){
			for (d = 0; d < *depth1; d++){
				if (i < *height2 && j < *width2){
					int index1 = IMGPOS(j, i, d, *width1, *height1);
					int index2 = IMGPOS(j, i, d, *width2, *height2);
					int res = image1[index1] * image2[index2]; /* the product */
					image1[index1] = MIN(res, MAX_PIXEL_VALUE);
				}
			}
		}
	}

	*ret = 1;
	return;
}

/*
	Function: division
	Divide two images.

	Parameters:
		image1 - The first image.
		width1 - The width of the first image.
		height1 - Its height.
		depth1 - Its color depth.
		image2 - The second image.
		width2 - The width of the second image.
		height2 - Its height.
		depth2 - Its color depth.

	Returns:
		ret - -1 if there is an error, 1 if success.
		image1 - The division of the two images; the division region corresponds to the smaller of the images. The result image is clipped.
*/
void division(int *image1, int *width1, int *height1, int *depth1, int *image2, int *width2, int *height2, int *depth2, int *ret){
	int i = 0, j = 0, d = 0;

	if (*depth1 != *depth2){
		*ret = -1;
		return;
	}

	for (i = 0; i < *height1; i++){
		for (j = 0; j < *width1; j++){
			for (d = 0; d < *depth1; d++){
				if (i < *height2 && j < *width2){
					int index1 = IMGPOS(j, i, d, *width1, *height1);
					int index2 = IMGPOS(j, i, d, *width2, *height2);
					int res = (image2[index2] != 0) ? image1[index1] / image2[index2] : 0; /* the division */
					image1[index1] = res;
				}
			}
		}
	}

	*ret = 1;
	return;
}

/*
	Function: average
		Auxiliar function for calculate the average of images.
		It takes two images and add them, but not clip the result.

	Parameters:
		image1 - The first image.
		image2 - The second image.
		width - The width of the images.
		height - The height.
		depth - The color depth.

	Returns:
		ret - -1 if there is an error, 1 if success.
		image1 - The addition of the two images. The result image is NOT clipped.
*/
void average(int *image1, int *image2, int *width, int *height, int *depth, int *ret){
	int i = 0;
	int plane_size = *width * *height * *depth;

	for (i = 0; i < plane_size; i++){
		image1[i] = image1[i] + image2[i]; /* accumulates image2 in image1 */
	}

	*ret = 1;
	return;
}


void maximum(int *image1, int *image2, int *width, int *height, int *depth, int *ret){
	int i = 0;
	int plane_size = *width * *height * *depth;

	for (i = 0; i < plane_size; i++){
		image1[i] = MAX(image1[i],image2[i]);
	}

	*ret = 1;
	return;
}
