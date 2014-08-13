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
	Title: Edge detection operators
*/

#include "defs.h"
#include <stdlib.h>

/*
	Function: homogeneityEdgeDetection
		Enhace image's edge by the homogeneity method. It uses a 3x3 matrix to determine the
		current pixel value (by getting the maximum value between the distances of the pixel
		and its neighbors)

	Parameters:
		image - The input image
		width - The image width
		height - Its height
		depth - Its color depth
		bias - Value to be added to each pixel after method is applied (used to correct some expected
			behaviour)

	Returns:
		ret - The image whose edges has been enhaced
		
	See also:
		<differenceEdgeDetection>
*/
void homogeneityEdgeDetection(int *image, int *width, int *height, int *depth, int *bias, int *ret){
	int x, y, d, i;
	int max, value;

	for (x = 0; x < *width; x++){
		for (y = 0; y < *height; y++){
			for (d = 0; d < *depth; d++){
				int current = image[IMGPOS(x,y,d,*width,*height)];
				int n[8];
				n[0] = (x-1 < 0 || y-1 < 0) ? current : IMGPOS (x-1, y-1, d, *width, *height);
				n[1] = (y-1 < 0) ? current : IMGPOS (x, y-1, d, *width, *height);
				n[2] = (x+1 > *width - 1 || y-1 < 0) ? current : IMGPOS (x+1, y-1, d, *width, *height);
				n[3] = (x-1 < 0) ? current : IMGPOS (x-1, y, d, *width, *height);
				n[4] = (x+1 > *width - 1) ? current : IMGPOS (x+1, y, d, *width, *height);
				n[5] = (x-1 < 0 || y+1 > *height - 1) ? current : IMGPOS (x-1, y+1, d, *width, *height);
				n[6] = (y+1 > *height - 1) ? current : IMGPOS (x, y+1, d, *width, *height);
				n[7] = (x+1 > *width - 1 || y+1 > *height - 1) ? current : IMGPOS (x+1, y+1, d, *width, *height);
				max = 0;
				for (i = 0; i < 8; i++){
					value = abs(image[n[i]] - current);
					if (value > max){
						max = value;
					}
				}
				ret[IMGPOS(x,y,d,*width, *height)] = MIN (max + *bias, MAX_PIXEL_VALUE);
			}
		}
	}
}

/*
	Function: differenceEdgeDetection
		Enhace image's edge by the difference method. It uses a 3x3 matrix to determine the
		current pixel value (by getting the maximum value between the distances of matrix's
		opposite neighbors)

	Parameters:
		image - The input image
		width - The image width
		height - Its height
		depth - Its color depth
		bias - Value to be added to each pixel after method is applied (used to correct some expected
			behaviour)

	Returns:
		ret - The image whose edges has been enhaced
		
	See also:
		<homogeneityEdgeDetection>
*/
void differenceEdgeDetection(int *image, int *width, int *height, int *depth, int *bias, int *ret){
	int x, y, d, i;
	int max, value;

	for (x = 0; x < *width; x++){
		for (y = 0; y < *height; y++){
			for (d = 0; d < *depth; d++){
				int current = image[IMGPOS(x,y,d,*width,*height)];
				int n[8];
				n[0] = (x-1 < 0 || y-1 < 0) ? current : IMGPOS (x-1, y-1, d, *width, *height);
				n[1] = (y-1 < 0) ? current : IMGPOS (x, y-1, d, *width, *height);
				n[2] = (x+1 > *width - 1 || y-1 < 0) ? current : IMGPOS (x+1, y-1, d, *width, *height);
				n[3] = (x-1 < 0) ? current : IMGPOS (x-1, y, d, *width, *height);
				n[4] = (x+1 > *width - 1) ? current : IMGPOS (x+1, y, d, *width, *height);
				n[5] = (x-1 < 0 || y+1 > *height - 1) ? current : IMGPOS (x-1, y+1, d, *width, *height);
				n[6] = (y+1 > *height - 1) ? current : IMGPOS (x, y+1, d, *width, *height);
				n[7] = (x+1 > *width - 1 || y+1 > *height - 1) ? current : IMGPOS (x+1, y+1, d, *width, *height);
				max = 0;
				for (i = 0; i < 4; i++){
					value = abs(image[n[i]] - image[n[7-i]]);
					if (value > max){
						max = value;
					}
				}
				ret[IMGPOS(x,y,d,*width, *height)] = MIN (max + *bias, MAX_PIXEL_VALUE);
			}
		}
	}
}
