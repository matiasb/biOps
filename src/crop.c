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
	Title: Crop Operation (C code)
*/

#include <stdlib.h>
#include "defs.h"

/*
	Function: crop
		Crops an image

	Parameters:
		image - Image to be cropped
		width - The image's width.
		height - The image's height.
		depth - The image's color depth.
		x_start - Upper left x coordinate of src block
		y_start - Upper left y coordinate of src block
		t_width - block's width
		t_height - block's height

	Returns:
		image - The cropped image
*/
void crop(int *image, int *width, int *height, int *depth, int *x_start, int *y_start, int *c_width, int *c_height, int *ret){
	int i, j, k;
	for (i = 0; i < *c_width; i++){
		for (j = 0 ; j < *c_height; j++){
			for (k = 0; k < *depth; k++){
				ret[IMGPOS(i, j, k, *c_width, *c_height)] = image[IMGPOS(*x_start + i, *y_start + j, k, *width, *height)];
			}
		}
	}
	return;
}
