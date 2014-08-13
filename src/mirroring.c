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
	Title: Mirroring Operations (C code)
*/

#include "defs.h"


/*
	Function: horizontalMirroring
	Flips an image about the y axis

	Parameters:
		image - The input image
		width - The image width
		height - Its height
		depth - Its color depth
		ret - The result mirrored image

	Returns:
		The horizontal mirrored image
*/
void horizontalMirroring(int *image, int *width, int *height, int *depth, int *ret){
	int x, y, d;

	for (y = 0; y < *height; y++){
		for (x = 0; x < *width; x++){
			for (d = 0; d < *depth; d++){
				ret[IMGPOS(x, y, d, *width, *height)] = image[IMGPOS((*width - 1) - x, y, d, *width, *height)];
			}
		}
	}
}

/*
	Function: verticalMirroring
	Flips an image about the x axis

	Parameters:
		image - The input image
		width - The image width
		height - Its height
		depth - Its color depth
		ret - The result mirrored image

	Returns:
		The vertical mirrored image
*/
void verticalMirroring(int *image, int *width, int *height, int *depth, int *ret){
	int x, y, d;

	for (y = 0; y < *height; y++){
		for (x = 0; x < *width; x++){
			for (d = 0; d < *depth; d++){
				ret[IMGPOS(x, y, d, *width, *height)] = image[IMGPOS(x, (*height - 1) - y, d, *width, *height)];
			}
		}
	}
}
