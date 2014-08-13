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
	Title: Interpolation Operations
*/

#include "interpolation.h"
#include "defs.h"

double cubic_convolution(double x, double a);

/*
	Function: bilinear
	Performs a bilinear interpolation between 4 values with weights x and y

	Parameters:
		image - 4-value array, [nw, ne, sw, se] neighbors
		x - Horizontal coords offset
		y - Vertical coords offset

	Returns:
		The interpolated value
*/
double bilinear (int *image, double x, double y){
	int nw, ne, sw, se;
	double ew_top, ew_bottom;
	
	nw = image[0];
	ne = image[1];
	sw = image[2];
	se = image[3];
	
	/* 3 linear interpolation, two on x axis, one on y axis */
	ew_top = nw + x * (ne - nw);
	ew_bottom = sw + x * (se - sw);
	return ew_top + y * (ew_bottom - ew_top);
}

/*
	Function: cubic
	Performs a cubic interpolation between 16 values with weights x and y, and constant a

	Parameters:
		image - 16-value array, neighbors (nearest point is image[1][1])
		x - Horizontal coords offset
		y - Vertical coords offset
		a - cubic interpolation constant

	Returns:
		The interpolated value
*/
double cubic (int image[4][4], double x, double y, double a){
	double a0 = 0, a1 = 0, a2 = 0, a3 = 0;
	double column[4]; /* row interpolations */
	int i = 0;
	double ret;

	if (x == 0 && y == 0){ /* no interpolation needed */
		return (double) image[1][1];
	}
	
	if (x == 0){ /* no row interpolation needed */
		for (i = 0; i < 4; i++){ /* we keep nearest point column */
			column[i] = (double) image[i][1];
		}
	}else{ /* row interpolation needed */
		a0 = cubic_convolution (x + 1, a); /* a0 = f(1+d) = f(-1-d) */
		a1 = cubic_convolution (x, a); /* a1 = f(d) = f(-d) */
		a2 = cubic_convolution (1 - x, a); /* a2 = f(1-d) */
		a3 = cubic_convolution (2 - x, a); /* a3 = f(2-d) */
		
		if (y == 0){ /* just one row processing needed */
			ret = a0 * image[1][0] + a1 * image[1][1] + a2 * image[1][2] + a3 * image[1][3];
			return CLIP (ret, MIN_PIXEL_VALUE, MAX_PIXEL_VALUE);
		}else{ /* process 4 columns */
			for (i = 0; i < 4; i++){
				column[i] = a0 * image[i][0] + a1 * image[i][1] + a2 * image[i][2] + a3 * image[i][3];
			}
		}
	} /* x == 0 */
	
	/* now we interpolate the resulting column */
	a0 = cubic_convolution (y + 1, a);
	a1 = cubic_convolution (y, a);
	a2 = cubic_convolution (1 - y, a);
	a3 = cubic_convolution (2 - y, a);

	ret = a0 * column[0] + a1 * column[1] + a2 * column[2] + a3 * column[3];
	return CLIP (ret, MIN_PIXEL_VALUE, MAX_PIXEL_VALUE);

}

/* Cubic convolution equations; auxiliar function */
double cubic_convolution (double x, double a){
	if (1 <= x && x < 2){
		return ((a * x - 5 * a) * x + 8 * a) * x - 4 * a;
	}else if (0 <= x && x < 1){
		return ((a + 2) * x - (a + 3)) * x * x + 1;
	}else{
		return 0;
	}
}

/*
	Function: spline
	Performs a b-spline interpolation between 16 values with weights x and y

	Parameters:
		image - 16-value array, neighbors (nearest point is image[1][1])
		x - Horizontal coords offset
		y - Vertical coords offset

	Returns:
		The interpolated value
*/
double spline(int image[4][4], double x, double y){
	double column[4];
	double a0, a1, a2, a3;
	double x_plus_1, y_plus_1;
	double one_minus_x, one_minus_y;
	int i;
	double pixel;

	if (x == 0 && y == 0){ /* no interpolation needed */
		return (double) image[1][1];
	}

	if (x == 0){
		for (i = 0; i < 4; i++){
			column[i] = (double) image[i][1];
		}
	}else{
		x_plus_1 = x + 1;
		one_minus_x = 1 - x;

		a0 = ((-0.16666666 * x_plus_1 + 1) * x_plus_1 - 2) * x_plus_1 + 1.33333;
		a1 = (0.5 * x - 1) * x * x + 0.66666667;
		a2 = (0.5 * one_minus_x - 1) * one_minus_x * one_minus_x + 0.66666667;
		a3 = 1 - a0 - a1 - a2;

		if (y == 0){
			return (a0 * image[1][0] + a1 * image[1][1] + a2 * image[1][2] + a3 * image[1][3]);
		}

		for (i = 0; i < 4; i++){
			column[i] = a0 * image[i][0] + a1 * image[i][1] + a2 * image[i][2] + a3 * image[i][3];
		}
	}

	y_plus_1 = y + 1;
	one_minus_y = 1 - y;

	a0 = ((-0.16666666 * y_plus_1 + 1) * y_plus_1 - 2) * y_plus_1 + 1.33333;
	a1 = (0.5 * y - 1) * y * y + 0.66666667;
	a2 = (0.5 * one_minus_y - 1) * one_minus_y * one_minus_y + 0.66666667;
	a3 = 1 - a0 - a1 - a2;

	pixel = column[0] * a0 + column[1] * a1 + column[2] * a2 + column[3] * a3;

	return pixel;
}
