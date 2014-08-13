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
	Title: Scale Operations (C code)
*/

#include "defs.h"
#include "interpolation.h"

/*
	Function: scaleByNearestNeighbor
	Performs a scaling operation using nearest neighbor interpolation

	Parameters:
		image - The input image
		width - The image width
		height - Its height
		depth - Its color depth
		ret - The result image
		x_scale - The percentage of the scaled image in the horizontal axe
		y_scale - The percentage of the scaled image in the vertical axe

	Returns:
		The scaled image
*/
void scaleByNearestNeighbor(int *image, int *width, int *height, int *depth, int *ret, double *x_scale, double *y_scale){
	int cols, rows, i, j, k;
	int x_src, y_src;

	/* new image dims */
	cols = (int) (*width * *x_scale);
	rows = (int) (*height * *y_scale);

	for (i = 0; i < rows; i++){
		for (j = 0; j < cols; j++){
			x_src = (int) ((j / *x_scale) + 0.5); /* nearest neighbor */
			y_src = (int) ((i / *y_scale) + 0.5);

			x_src = (x_src >= *width) ? *width - 1: x_src;
			y_src = (y_src >= *height) ? *height - 1: y_src;

			for (k = 0; k < *depth; k++){
				int next = IMGPOS(j,i,k,cols,rows);
				int src = IMGPOS(x_src,y_src,k,*width,*height);
				ret[next] = image[src];
			}
		}
	}
	return;
}

/*
	Function: scaleByBilinear
	Performs a scaling operation using bilinear interpolation

	Parameters:
		image - The input image
		width - The image width
		height - Its height
		depth - Its color depth
		ret - The result image
		x_scale - The percentage of the scaled image in the horizontal axe
		y_scale - The percentage of the scaled image in the vertical axe

	Returns:
		The scaled image
*/
void scaleByBilinear(int *image, int *width, int *height, int *depth, int *ret, double *x_scale, double *y_scale){
	int cols, rows, i, j, k;
	int x_src, y_src;
	double h_weight, v_weight;

	/* new image dims */
	cols = (int) (*width * *x_scale);
	rows = (int) (*height * *y_scale);

	for (i = 0; i < rows; i++){
		for (j = 0; j < cols; j++){
			x_src = (int) (j / *x_scale);
			y_src = (int) (i / *y_scale);
			h_weight = (j / *x_scale) - x_src;
			v_weight = (i / *y_scale) - y_src;

			for (k = 0; k < *depth; k++){
				int next = IMGPOS(j,i,k,cols,rows);

				int a[4]; /* 4 neighbors */
				a[0] = image[IMGPOS(x_src,y_src,k,*width,*height)]; /* nw */
				a[1] = (x_src == *width-1) ? a[0] : image[IMGPOS(x_src+1,y_src,k,*width,*height)]; /* ne */
				a[2] = (y_src == *height-1) ? a[0] : image[IMGPOS(x_src,y_src+1,k,*width,*height)]; /* sw */
				a[3] = (x_src == *width-1 || y_src == *height-1) ? a[0] : image[IMGPOS(x_src+1,y_src+1,k,*width,*height)]; /* se */

				ret[next] = (int) bilinear(a, h_weight, v_weight);
			}
		}
	}
	return;
}

/*
	Function: scaleByCubic
	Performs a scaling operation using cubic interpolation

	Parameters:
		image - The input image
		width - The image width
		height - Its height
		depth - Its color depth
		ret - The result image
		x_scale - The percentage of the scaled image in the horizontal axe
		y_scale - The percentage of the scaled image in the vertical axe

	Returns:
		The scaled image
*/
void scaleByCubic(int *image, int *width, int *height, int *depth, int *ret, double *x_scale, double *y_scale){
	int cols, rows, i, j, k;
	int x_src, y_src;
	double h_weight, v_weight;

	/* new image dims */
	cols = (int) (*width * *x_scale);
	rows = (int) (*height * *y_scale);

	for (i = 0; i < rows; i++){
		for (j = 0; j < cols; j++){
			x_src = (int) (j / *x_scale);
			y_src = (int) (i / *y_scale);
			h_weight = (j / *x_scale) - x_src;
			v_weight = (i / *y_scale) - y_src;

			for (k = 0; k < *depth; k++){
				int next = IMGPOS(j,i,k,cols,rows);
				int src = IMGPOS(x_src,y_src,k,*width,*height);
				int a[4][4];
				int m,n;

				for (n = 0; n < 4; n++){
					for (m = 0; m < 4; m++){
						int x = x_src - 1 + m, y = y_src - 1 + n;
						if (x < 0 || y < 0 || x >= *width || y >= *height)
							a[n][m] = image[src];
						else
							a[n][m] = image[IMGPOS(x, y, k, *width, *height)];
					}
				}

				ret[next] = (int) cubic(a, h_weight, v_weight, -1.0);
			}
		}
	}
	return;
}

/*
	Function: scaleByBSpline
	Performs a scaling operation using b-spline interpolation

	Parameters:
		image - The input image
		width - The image width
		height - Its height
		depth - Its color depth
		ret - The result image
		x_scale - The percentage of the scaled image in the horizontal axe
		y_scale - The percentage of the scaled image in the vertical axe

	Returns:
		The scaled image
*/
void scaleBySpline(int *image, int *width, int *height, int *depth, int *ret, double *x_scale, double *y_scale){
	int cols, rows, i, j, k;
	int x_src, y_src;
	double h_weight, v_weight;

	/* new image dims */
	cols = (int) (*width * *x_scale);
	rows = (int) (*height * *y_scale);

	for (i = 0; i < rows; i++){
		for (j = 0; j < cols; j++){
			x_src = (int) (j / *x_scale);
			y_src = (int) (i / *y_scale);
			h_weight = (j / *x_scale) - x_src;
			v_weight = (i / *y_scale) - y_src;

			for (k = 0; k < *depth; k++){
				int next = IMGPOS(j,i,k,cols,rows);
				int src = IMGPOS(x_src,y_src,k,*width,*height);
				int a[4][4];
				int m,n;

				for (n = 0; n < 4; n++){
					for (m = 0; m < 4; m++){
						int x = x_src - 1 + m, y = y_src - 1 + n;
						if (x < 0 || y < 0 || x >= *width || y >= *height)
							a[n][m] = image[src];
						else
							a[n][m] = image[IMGPOS(x, y, k, *width, *height)];
					}
				}

				ret[next] = (int) spline(a, h_weight, v_weight);
			}
		}
	}
	return;
}
