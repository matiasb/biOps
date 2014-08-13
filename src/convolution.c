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
	Title: Convolution Mask Operations
*/

#include <stdlib.h>
#include "defs.h"

/*
	Function: convolution
		Performs a convolution operation over an image, with given matrix mask

	Parameters:
		image - The input image
		width - The image width
		height - Its height
		depth - Its color depth
		mask - The kernel matrix to apply convolution
		mask_width - mask's width
		mask_height - mask's height
		bias - Value to be added to each pixel after method is applied (used to correct some expected
			behaviour)

	Returns:
		ret - A mask convoluted image
		
*/
void convolution(int *image, int *width, int *height, int *depth, double *mask, int *mask_width, int *mask_height, int *bias, int *ret){
	int x, y, d, i, j;

	int x_src = *mask_width / 2;
	int y_src = *mask_height / 2;

	for (x = 0; x < *width; x++){
		for (y = 0; y < *height; y++){
			for (d = 0; d < *depth; d++){
				int value = 0;
				for (i = 0; i < *mask_width; i++){
					for (j = 0; j < *mask_height; j++){
						int x_pos, y_pos;
						x_pos = (x + i < x_src) ? 0 : x + i - x_src;
						x_pos = (x_pos > *width - 1) ? *width - 1 : x_pos;
						y_pos = (y + j < y_src) ? 0 : y + j - y_src;
						y_pos = (y_pos > *height - 1) ? *height - 1 : y_pos;
						value += image[IMGPOS(x_pos, y_pos, d, *width, *height)] * mask[MSKPOS(i, j, *mask_width, *mask_height)];
					}
				}
				value += *bias;
				ret[IMGPOS(x, y, d, *width, *height)] = CLIP(value, MIN_PIXEL_VALUE, MAX_PIXEL_VALUE);
			}
		}
	}
}
