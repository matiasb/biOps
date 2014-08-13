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
	Title: Morphology Operations
*/
#include <stdio.h> /* FIXME: sacar */
#include <stdlib.h>
#include "defs.h"


/*
	Function: binaryDilation
		Makes a Dilation of a binary image with a given mask.
		This is, it applies the mask in every image pixel: when reached a black point, 
		it turns every image's mask black point into black.

	Parameters:
		image - Image to be dilated
		width - The image's width.
		height - The image's height.
		mask - The mask to be applied
		mask_width - mask's width
		mask_height - mask's height

	Returns:
		ret - The dilated image
*/
void binaryDilation (int *image, int *width, int *height, int *mask, int *mask_width, int *mask_height, int *ret){
	int x, y, i, j;
	int x_src = *mask_width / 2;
	int y_src = *mask_height / 2;
	
	/* initialize return buffer */
	for (x = 0; x < *width; x++){
		for (y = 0; y < *height; y++){
			ret[IMGPOS(x, y, 0, *width, *height)] = MAX_PIXEL_VALUE;
		}
	}
	
	for (x = 0; x < *width; x++){
		for (y = 0; y < *height; y++){
			if (image[IMGPOS(x, y, 0, *width, *height)] == MIN_PIXEL_VALUE){
				for (i = 0; i < *mask_width; i++){
					for (j = 0; j < *mask_height; j++){
						int x_pos, y_pos, this_pos;
						x_pos = (x + i < x_src) ? -1 : x + i - x_src;
						x_pos = (x_pos > *width - 1) ? -1 : x_pos;
						y_pos = (y + j < y_src) ? -1 : y + j - y_src;
						y_pos = (y_pos > *height - 1) ? -1 : y_pos;
						if (x_pos != -1 && y_pos != -1){
							if (mask[MSKPOS(i, j, *mask_width, *mask_height)] == MIN_PIXEL_VALUE){
								this_pos = IMGPOS(x_pos, y_pos, 0, *width, *height);
								ret[this_pos] = MIN_PIXEL_VALUE;
							}
						}
					}
				}
			}
		}
	}
}

/*
	Function: binaryErosion
		Makes an Erosion of a binary image with a given mask.
		This is, it applies the mask in every image pixel: when the mask matches completely,
		it turns its images' center into a black point

	Parameters:
		image - Image to be eroded
		width - The image's width.
		height - The image's height.
		mask - The mask to be applied
		mask_width - mask's width
		mask_height - mask's height

	Returns:
		ret - The eroded image
*/
void binaryErosion (int *image, int *width, int *height, int *mask, int *mask_width, int *mask_height, int *ret){
	int x, y, i, j;

	int x_src = *mask_width / 2;
	int y_src = *mask_height / 2;

	/* initialize return buffer */
	for (x = 0; x < *width; x++){
		for (y = 0; y < *height; y++){
			ret[IMGPOS(x, y, 0, *width, *height)] = MAX_PIXEL_VALUE;
		}
	}

	for (x = 0; x < *width; x++){
		for (y = 0; y < *height; y++){
			int set = 0;
			for (i = 0; i < *mask_width; i++){
				for (j = 0; j < *mask_height && !set; j++){
					int x_pos, y_pos;
					x_pos = (x + i < x_src) ? -1 : x + i - x_src;
					x_pos = (x_pos > *width - 1) ? -1 : x_pos;
					y_pos = (y + j < y_src) ? -1 : y + j - y_src;
					y_pos = (y_pos > *height - 1) ? -1 : y_pos;
					if (x_pos != -1 && y_pos != -1){
						if (mask[IMGPOS(i, j, 0, *mask_width, *mask_height)] != image[IMGPOS(x_pos, y_pos, 0, *width, *height)]){
							set = 1;
						}
					}else{
						set = 1;
					}
				}
			}
			if (!set){
				ret[IMGPOS(x, y, 0, *width, *height)] = MIN_PIXEL_VALUE;
			}
		}
	}
}

/*
	Function: grayScaleDilation
		Makes a Dilation of a gray scaled image with a given mask, by taken maximal values over one-to-one
		local elements convolution

	Parameters:
		image - Image to be dilated
		width - The image's width.
		height - The image's height.
		mask - The mask to be applied
		mask_width - mask's width
		mask_height - mask's height

	Returns:
		ret - The dilated image
*/
void grayScaleDilation (int *image, int *width, int *height, int *mask, int *mask_width, int *mask_height, int *ret){
	int x, y, i, j;

	int x_src = *mask_width / 2;
	int y_src = *mask_height / 2;

	for (x = 0; x < *width; x++){
		for (y = 0; y < *height; y++){
			int max = 0;
			int value;
			for (i = 0; i < *mask_width; i++){
				for (j = 0; j < *mask_height; j++){
					int x_pos, y_pos;
					x_pos = (x + i < x_src) ? -1 : x + i - x_src;
					x_pos = (x_pos > *width - 1) ? -1 : x_pos;
					y_pos = (y + j < y_src) ? -1 : y + j - y_src;
					y_pos = (y_pos > *height - 1) ? -1 : y_pos;
					if (x_pos != -1 && y_pos != -1){
						value = MIN(255, image[IMGPOS(x_pos, y_pos, 0, *width, *height)] + mask[IMGPOS(i, j, 0, *mask_width, *mask_height)]);
						if (value > max){
							max = value;
						}
					}
				}
			}
			ret[IMGPOS(x, y, 0, *width, *height)] = CLIP(max, MIN_PIXEL_VALUE, MAX_PIXEL_VALUE);
		}
	}
}

/*
	Function: grayScaleErosion
		Makes an erosion of a gray scaled image with a given mask, by taken minimal values over one-to-one
		local elements convolution

	Parameters:
		image - Image to be eroded
		width - The image's width.
		height - The image's height.
		mask - The mask to be applied
		mask_width - mask's width
		mask_height - mask's height

	Returns:
		ret - The eroded image
*/
void grayScaleErosion (int *image, int *width, int *height, int *mask, int *mask_width, int *mask_height, int *ret){
	int x, y, i, j;

	int x_src = *mask_width / 2;
	int y_src = *mask_height / 2;

	for (x = 0; x < *width; x++){
		for (y = 0; y < *height; y++){
			int min = 255;
			int value;
			for (i = 0; i < *mask_width; i++){
				for (j = 0; j < *mask_height; j++){
					int x_pos, y_pos;
					x_pos = (x + i < x_src) ? -1 : x + i - x_src;
					x_pos = (x_pos > *width - 1) ? -1 : x_pos;
					y_pos = (y + j < y_src) ? -1 : y + j - y_src;
					y_pos = (y_pos > *height - 1) ? -1 : y_pos;
					if (x_pos != -1 && y_pos != -1){
						value = MAX(0, image[IMGPOS(x_pos, y_pos, 0, *width, *height)] - mask[IMGPOS(i, j, 0, *mask_width, *mask_height)]);
						if (value < min){
							min = value;
						}
					}
				}
			}
			ret[IMGPOS(x, y, 0, *width, *height)] = CLIP(min, MIN_PIXEL_VALUE, MAX_PIXEL_VALUE);
		}
	}
}
