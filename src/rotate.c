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
	Title: Rotate Operations (C code)
*/

#include <math.h>
#include "defs.h"
#include "interpolation.h"

/*
	Function: rotate90Clockwise
		Rotates an image 90 degrees clockwise

	Parameters:
		image - Image to be rotated.
		width - The image's width.
		height - The image's height.
		depth - The image's color depth.

	Returns:
		ret - The image rotated 90 degrees clockwise
*/
void rotate90Clockwise(int *image, int *width, int *height, int *depth, int *ret){
	int i, j, k, dest, src;
	int new_h = *width, new_w = *height;
	
	for (i = 0; i < new_w; i++){
		for (j = 0; j < new_h; j++){
			for (k = 0; k < *depth; k++){
				dest = IMGPOS(i, j, k, new_w, new_h);
				src = IMGPOS(j, *height - 1 - i, k, *width, *height);
				ret[dest] = image[src];
			}
		}
	}
	return;
}

/*
	Function: rotate90CunterClockwise
		Rotates an image 90 degrees counter-clockwise

	Parameters:
		image - Image to be rotated.
		width - The image's width.
		height - The image's height.
		depth - The image's color depth.

	Returns:
		ret - The image rotated 90 degrees counter-clockwise
*/
void rotate90CounterClockwise(int *image, int *width, int *height, int *depth, int *ret){
	int i, j, k, dest, src;
	int new_h = *width, new_w = *height;
	
	for (i = 0; i < new_w; i++){
		for (j = 0; j < new_h; j++){
			for (k = 0; k < *depth; k++){
				dest = IMGPOS(i, j, k, new_w, new_h);
				src = IMGPOS(*width - 1 - j, i, k, *width, *height);
				ret[dest] = image[src];
			}
		}
	}
	return;
}

/*
	Function: rotateByNearestNeighbor
		Rotates the image a given angle by applying nearest neighbor method
 
	Parameters:
		image - Image to be rotated.
		width - The image's width.
		height - The image's height.
		depth - The image's color depth.
		angle - clockwise rotation angle
		new_width - New image's width
		new_height - New image's height

	Returns:
		ret - The image rotated counter-clockwise by an angle
		
*/
void rotateByNearestNeighbor (int *image, int *width, int *height, int *depth, double *angle, int *ret, int *new_width, int *new_height){
	int x_center, y_center, x_diff, y_diff;
	int x, y, d;
	double x_src_d, y_src_d;
	int x_src, y_src;
	
	while (*angle >= 360){
		*angle = *angle - 360;
	}
	
	x_center = *width/2;
	y_center = *height/2;
	x_diff = (*new_width - *width)/2;
	y_diff = (*new_height - *height)/2;
	
	for (y = -1*y_diff; y < (*new_height - y_diff); y++){
		for (x = -1*x_diff; x < (*new_width - x_diff); x++){
			x_src_d = (x - x_center) * cos(*angle) + (y - y_center) * sin(*angle) + x_center;
			y_src_d = (y - y_center) * cos(*angle) - (x - x_center) * sin(*angle) + y_center;
			x_src = (int) (x_src_d + 0.5);
			y_src = (int) (y_src_d + 0.5);
			
			for (d = 0; d < *depth; d++){
				if (x_src < 0 || y_src < 0 || x_src > *width - 1 || y_src > *height - 1){
					ret[IMGPOS(x + x_diff, y + y_diff, d, *new_width, *new_height)] = MIN_PIXEL_VALUE;
				}else{
					ret[IMGPOS(x + x_diff, y + y_diff, d, *new_width, *new_height)] = image[IMGPOS(x_src, y_src, d, *width, *height)];
				}
			}
		}
	}
}

/*
	Function: rotateByBilinear
		Rotates the image a given angle by applying bilinear method
 
	Parameters:
		image - Image to be rotated.
		width - The image's width.
		height - The image's height.
		depth - The image's color depth.
		angle - clockwise rotation angle
		new_width - New image's width
		new_height - New image's height

	Returns:
		ret - The image rotated counter-clockwise by an angle
		
*/
void rotateByBilinear (int *image, int *width, int *height, int *depth, double *angle, int *ret, int *new_width, int *new_height){
	int x_center, y_center, x_diff, y_diff;
	int x, y, d;
	double x_src_d, y_src_d;
	int x_src, y_src;
	double x_weight, y_weight;
	
	while (*angle >= 360){
		*angle = *angle - 360;
	}
	
	x_center = *width/2;
	y_center = *height/2;
	x_diff = (*new_width - *width)/2;
	y_diff = (*new_height - *height)/2;
	
	for (y = -1*y_diff; y < (*new_height - y_diff); y++){
		for (x = -1*x_diff; x < (*new_width - x_diff); x++){
			x_src_d = (x - x_center) * cos(*angle) + (y - y_center) * sin(*angle) + x_center;
			y_src_d = (y - y_center) * cos(*angle) - (x - x_center) * sin(*angle) + y_center;
			x_src = (int) x_src_d;
			y_src = (int) y_src_d;
			
			x_weight = x_src_d - x_src;
			y_weight = y_src_d - y_src;
			for (d = 0; d < *depth; d++){
				if (x_src_d < 0 || y_src_d < 0 || x_src_d >= *width || y_src_d >= *height){
					ret[IMGPOS(x + x_diff, y + y_diff, d, *new_width, *new_height)] = 0;
				}else{
					int a[4];
					a[0] = image[IMGPOS(x_src, y_src, d, *width, *height)];
					a[1] = (x_src == *width - 1) ? a[0] : image[IMGPOS(x_src + 1, y_src, d, *width, *height)];
					a[2] = (y_src == *height - 1)? a[0] : image[IMGPOS(x_src, y_src + 1, d, *width, *height)];
					a[3] = ((x_src == *width - 1) || (y_src == *height - 1)) ? a[0] : image[IMGPOS(x_src + 1, y_src + 1, d, *width, *height)];
					ret[IMGPOS(x + x_diff, y + y_diff, d, *new_width, *new_height)] = (int) bilinear (a, x_weight, y_weight);
				}
			}
		}
	}
}

/*
	Function: rotateByCubic
		Rotates the image a given angle by applying cubic method
 
	Parameters:
		image - Image to be rotated.
		width - The image's width.
		height - The image's height.
		depth - The image's color depth.
		angle - clockwise rotation angle
		new_width - New image's width
		new_height - New image's height

	Returns:
		ret - The image rotated counter-clockwise by an angle
		
*/
void rotateByCubic (int *image, int *width, int *height, int *depth, double *angle, int *ret, int *new_width, int *new_height){
	int x_center, y_center, x_diff, y_diff;
	int x, y, d;
	double x_src_d, y_src_d;
	int x_src, y_src;
	double x_weight, y_weight;
	
	while (*angle >= 360){
		*angle = *angle - 360;
	}
	
	x_center = *width/2;
	y_center = *height/2;
	x_diff = (*new_width - *width)/2;
	y_diff = (*new_height - *height)/2;
	
	for (y = -1*y_diff; y < (*new_height - y_diff); y++){
		for (x = -1*x_diff; x < (*new_width - x_diff); x++){
			x_src_d = (x - x_center) * cos(*angle) + (y - y_center) * sin(*angle) + x_center;
			y_src_d = (y - y_center) * cos(*angle) - (x - x_center) * sin(*angle) + y_center;
			x_src = (int) x_src_d;
			y_src = (int) y_src_d;
			
			x_weight = x_src_d - x_src;
			y_weight = y_src_d - y_src;
			for (d = 0; d < *depth; d++){
				int src = IMGPOS(x_src, y_src, d, *width, *height);
				int next = IMGPOS(x + x_diff, y + y_diff, d, *new_width, *new_height);
				if (x_src_d < 0 || y_src_d < 0 || x_src_d >= *width || y_src_d >= *height){
					ret[next] = 0;
				}else{
					int a[4][4];
					int m,n;
					
					for (n = 0; n < 4; n++){
						for (m = 0; m < 4; m++){
							int xs = x_src - 1 + m, ys = y_src - 1 + n;
							if (xs < 0 || ys < 0 || xs >= *width || ys >= *height){
								a[n][m] = image[src];
							}else{
								a[n][m] = image[IMGPOS(xs, ys, d, *width, *height)];
							}
						}
					}
					ret[next] = (int) cubic(a, x_weight, y_weight, -1.0);
				}
			}
		}
	}
}

/*
	Function: rotateBySpline
		Rotates the image a given angle by applying Spline method
 
	Parameters:
		image - Image to be rotated.
		width - The image's width.
		height - The image's height.
		depth - The image's color depth.
		angle - clockwise rotation angle
		new_width - New image's width
		new_height - New image's height

	Returns:
		ret - The image rotated counter-clockwise by an angle
		
*/
void rotateBySpline (int *image, int *width, int *height, int *depth, double *angle, int *ret, int *new_width, int *new_height){
	int x_center, y_center, x_diff, y_diff;
	int x, y, d;
	double x_src_d, y_src_d;
	int x_src, y_src;
	double x_weight, y_weight;
	
	while (*angle >= 360){
		*angle = *angle - 360;
	}
	
	x_center = *width/2;
	y_center = *height/2;
	x_diff = (*new_width - *width)/2;
	y_diff = (*new_height - *height)/2;
	
	for (y = -1*y_diff; y < (*new_height - y_diff); y++){
		for (x = -1*x_diff; x < (*new_width - x_diff); x++){
			x_src_d = (x - x_center) * cos(*angle) + (y - y_center) * sin(*angle) + x_center;
			y_src_d = (y - y_center) * cos(*angle) - (x - x_center) * sin(*angle) + y_center;
			x_src = (int) x_src_d;
			y_src = (int) y_src_d;
			
			x_weight = x_src_d - x_src;
			y_weight = y_src_d - y_src;
			for (d = 0; d < *depth; d++){
				int src = IMGPOS(x_src, y_src, d, *width, *height);
				int next = IMGPOS(x + x_diff, y + y_diff, d, *new_width, *new_height);
				if (x_src_d < 0 || y_src_d < 0 || x_src_d >= *width || y_src_d >= *height){
					ret[next] = 0;
				}else{
					int a[4][4];
					int m,n;
					
					for (n = 0; n < 4; n++){
						for (m = 0; m < 4; m++){
							int xs = x_src - 1 + m, ys = y_src - 1 + n;
							if (xs < 0 || ys < 0 || xs >= *width || ys >= *height){
								a[n][m] = image[src];
							}else{
								a[n][m] = image[IMGPOS(xs, ys, d, *width, *height)];
							}
						}
					}
					ret[next] = (int) spline(a, x_weight, y_weight);
				}
			}
		}
	}
}

