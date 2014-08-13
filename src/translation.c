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
	Title: Translate Operations (C code)
*/

#include <stdlib.h>
#include "defs.h"

/*
	Function: translate
		Translates an image block to a given area

	Parameters:
		image - Image to be changed
		width - The image's width.
		height - The image's height.
		depth - The image's color depth.
		x_start - Upper left x coordinate of src block
		y_start - Upper left y coordinate of src block
		x_end - Upper left x coordinate of dest block
		y_end - Upper left y coordinate of dest block
		t_width - block to move's width
		t_height - block to move's height

	Returns:
		image - The translated image
*/
void translate(int *image, int *width, int *height, int *depth, int *x_start, int *y_start, int *x_end, int *y_end, int *t_width, int *t_height){
	int *tmp_block;
	int i, j, k, tmp, src, dst;

	/* if translation width and height are too big, we set it to the biggest possible */
	if (*x_start + *t_width > *width || *x_end + *t_width > *width){
		*t_width = MIN(*width - *x_start, *width - *x_end);
	}
	if (*y_start + *t_height > *height || *y_end + *t_height > *height){
		*t_height = MIN(*height - *y_start, *height - *y_end);
	}

	tmp_block = (int *) calloc (*t_width * *t_height * *depth, sizeof (int));

	tmp = 0;
	for (i = 0; i < *t_width; i++){ /* use tmp_block to copy block to translate */
		for (j = 0; j < *t_height; j++){
			for (k = 0; k < *depth; k++){
				src = IMGPOS(*x_start + i, *y_start + j, k, *width, *height);
				tmp_block[tmp] = image[src];
				tmp++;
			}
		}
	}
	tmp = 0;
	for (i = 0; i < *t_width; i++){ /* copy block to image */
		for (j = 0; j < *t_height; j++){
			for (k = 0; k < *depth; k++){
				dst = IMGPOS(*x_end + i, *y_end + j, k, *width, *height);
				image[dst] = tmp_block[tmp];
				tmp++;
			}
		}
	}
	return;
}
