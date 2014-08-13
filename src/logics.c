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
	Title: Logic Operations (C code)
*/

#include <stdlib.h>
#include "defs.h"


/*
	Function: conjunction
	The conjunction of two images.

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
		image1 - The AND of the two images; the "ANDed" region corresponds to the smaller of the images. The result image is clipped.
*/
void conjunction(int *image1, int *width1, int *height1, int *depth1, int *image2, int *width2, int *height2, int *depth2, int *ret){
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
					int res = (image1[index1] & image2[index2]); /* logic bit and operator */
					image1[index1] = MIN(res, MAX_PIXEL_VALUE);
				}
			}
		}
	}

	*ret = 1;
	return;
}

/*
	Function: disjunction
	The disjunction of two images.

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
		image1 - The OR of the two images; the "ORed" region corresponds to the smaller of the images. The result image is clipped.
*/
void disjunction(int *image1, int *width1, int *height1, int *depth1, int *image2, int *width2, int *height2, int *depth2, int *ret){
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
					int res = (image1[index1] | image2[index2]); /* logic bit or operator */
					image1[index1] = MIN(res, MAX_PIXEL_VALUE);
				}
			}
		}
	}

	*ret = 1;
	return;
}

/*
	Function: xdisjunction
	The exclusive disjunction of two images.

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
		image1 - The XOR of the two images; the "XORed" region corresponds to the smaller of the images. The result image is clipped.
*/
void xdisjunction(int *image1, int *width1, int *height1, int *depth1, int *image2, int *width2, int *height2, int *depth2, int *ret){
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
					int res = (image1[index1] ^ image2[index2]); /* logic bit xor operator */
					image1[index1] = MIN(res, MAX_PIXEL_VALUE);
				}
			}
		}
	}

	*ret = 1;
	return;
}
