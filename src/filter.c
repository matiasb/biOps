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
	Title: Filter Operations
*/
#include <stdlib.h>
#include <math.h>
#include "defs.h"


/*
	Function: block_median_filter
		Filters an image by the Median filter, with a block window

	Parameters:
		image - Image to be filtered
		width - The image's width.
		height - The image's height.
		depth - The image's color depth.
		dim - Block's dimension

	Returns:
		ret - The filtered image
*/
void block_median_filter(int *image, int *width, int *height, int *depth, int *dim, int *ret){
	int x, y, d, i, j, median_index = 0;
	for (x = 0; x < *width; x++){
		for (y = 0; y < *height; y++){
			int src = *depth / 2;
			int index = 0;
			int values[*dim * *dim * *depth];
			for (i = 0; i < *dim; i++){
				for (j = 0; j < *dim; j++){
					int x_pos, y_pos;
					x_pos = (x + i < src) ? -1 : x + i - src;
					x_pos = (x_pos > *width - 1) ? -1 : x_pos;
					y_pos = (y + j < src) ? -1 : y + j - src;
					y_pos = (y_pos > *height - 1) ? -1 : y_pos;
					if (x_pos != -1 && y_pos != -1){
						for (d = 0; d < *depth; d++){
							values[index + d] = image[IMGPOS(x_pos, y_pos, d, *width, *height)];
						}
						index += *depth;
					}
				}
			}
			int median = 255 * index; /* maximum difference */
			for (i = 0; i < index; i+=*depth){
				int value = 0;
				for (j = 0; j < index; j+=*depth){
					for (d = 0; d < *depth; d++){
						value += abs(values[i+d] - values[j+d]);
					}
				}
				if (value < median){
					median = value;
					median_index = i;
				}
			}
			for (d = 0; d < *depth; d++){
				ret[IMGPOS(x, y, d, *width, *height)] = values[median_index+d];
			}
		}
	}
}

/*
	Function: maximum_filter
		Filters an image by the Maximum filter, with a block window

	Parameters:
		image - Image to be filtered
		width - The image's width.
		height - The image's height.
		depth - The image's color depth.
		dim - Block's dimension

	Returns:
		ret - The filtered image
*/
void maximum_filter (int *image, int *width, int *height, int *depth, int *dim, int *ret){
/*
Try getting the red, green, and blue values and averaging them. The pixel with the lowest average would be the "most black."
http://forum.java.sun.com/thread.jspa?threadID=5156961&tstart=135
*/
	int x, y, d, i, j, maximum_index = 0;
	for (x = 0; x < *width; x++){
		for (y = 0; y < *height; y++){
			int src = *depth / 2;
			int index = 0;
			int values[*dim * *dim * *depth];
			int max = -1;
			for (i = 0; i < *dim; i++){
				for (j = 0; j < *dim; j++){
					int x_pos, y_pos;
					x_pos = (x + i < src) ? -1 : x + i - src;
					x_pos = (x_pos > *width - 1) ? -1 : x_pos;
					y_pos = (y + j < src) ? -1 : y + j - src;
					y_pos = (y_pos > *height - 1) ? -1 : y_pos;
					if (x_pos != -1 && y_pos != -1){
						int value = 0;
						for (d = 0; d < *depth; d++){
							values[index + d] = image[IMGPOS(x_pos, y_pos, d, *width, *height)];
							value += image[IMGPOS(x_pos, y_pos, d, *width, *height)];
						}
						if (value > max){
							max = value;
							maximum_index = index;
						}
						index += *depth;
					}
				}
			}
			for (d = 0; d < *depth; d++){
				ret[IMGPOS(x, y, d, *width, *height)] = values[maximum_index+d];
			}
		}
	}
}

/*
	Function: maximum_filter
		Filters an image by the Minimum filter, with a block window

	Parameters:
		image - Image to be filtered
		width - The image's width.
		height - The image's height.
		depth - The image's color depth.
		dim - Block's dimension

	Returns:
		ret - The filtered image
*/
void minimum_filter (int *image, int *width, int *height, int *depth, int *dim, int *ret){
	int x, y, d, i, j, minimum_index = 0;
	for (x = 0; x < *width; x++){
		for (y = 0; y < *height; y++){
			int src = *depth / 2;
			int index = 0;
			int values[*dim * *dim * *depth];
			int min = 255 * *depth;
			for (i = 0; i < *dim; i++){
				for (j = 0; j < *dim; j++){
					int x_pos, y_pos;
					x_pos = (x + i < src) ? -1 : x + i - src;
					x_pos = (x_pos > *width - 1) ? -1 : x_pos;
					y_pos = (y + j < src) ? -1 : y + j - src;
					y_pos = (y_pos > *height - 1) ? -1 : y_pos;
					if (x_pos != -1 && y_pos != -1){
						int value = 0;
						for (d = 0; d < *depth; d++){
							values[index + d] = image[IMGPOS(x_pos, y_pos, d, *width, *height)];
							value += image[IMGPOS(x_pos, y_pos, d, *width, *height)];
						}
						if (value < min){
							min = value;
							minimum_index = index;
						}
						index += *depth;
					}
				}
			}
			for (d = 0; d < *depth; d++){
				ret[IMGPOS(x, y, d, *width, *height)] = values[minimum_index+d];
			}
		}
	}
}

