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
	Title: Marr-Hildreth Edge Detector
*/

#include <stdlib.h>
#include <math.h>
#include "defs.h"
#include "gaussian.h"

void marr(int *image, int *width, int *height, int *depth, double *s, int *ret);
void marr_aux(double s, int *image, int width, int height, int depth);
void marr_convolution(int *image, float *mask, int nr, int nc, float *res, int NR, int NC, int depth);
void zero_cross(float *lapim, int *image, int width, int height, int depth);


/*
	Function: marr
		Performs a Marr-Hildreth edge detection on the image

	Parameters:
		image - The input image
		width - The image width
		height - Its height
		depth - Its color depth
		s - The Gaussian standard deviation
		ret - The result image

	Returns:
		The edge detected image
		
*/
void marr(int *image, int *width, int *height, int *depth, double *s, int *ret){
	int plane_size = *width * *height * *depth;
	int i;

	for (i = 0; i < plane_size; i++){
		ret[i] = image[i];
	}

	marr_aux(*s - 0.8, image, *width, *height, *depth);
	marr_aux(*s + 0.8, ret, *width, *height, *depth);

	for (i = 0; i < plane_size; i++){
		if (image[i] > 0 && ret[i] > 0)
			ret[i] = MIN_PIXEL_VALUE;
		else
			ret[i] = MAX_PIXEL_VALUE;
	}
}


void marr_aux(double s, int *image, int width, int height, int depth){
	int gaussian_width;
	int i, j, d, n;
	float *lgau, *smx;

	/* Create Gaussian and derivative filter mask */
	gaussian_width = 3.35 * s + 0.33;
	n = gaussian_width + gaussian_width + 1;

	lgau = (float *) malloc(n*n*sizeof(float));
	for (i = 0; i < n; i++){
		for (j = 0; j < n; j++){
			float dist = distance((float) i, (float) j, (float) gaussian_width, (float) gaussian_width);
			lgau[MSKPOS(j, i, n, n)] = LoG(dist, (float) s);
		}
	}

	/* Convolution of source image with a Gaussian in x and y directions */
	smx = (float *) malloc(height * width * depth * sizeof(float));
	marr_convolution(image, lgau, n, n, smx, height, width, depth);

	/* Locate the zero crossings */
	zero_cross(smx, image, width, height, depth);

	/* Clear the boundary */
	for (d = 0; d < depth; d++){
		for (i = 0; i < height; i++){
			image[IMGPOS(0, i, d, width, height)] = MIN_PIXEL_VALUE;
			image[IMGPOS(width - 1, i, d, width, height)] = MIN_PIXEL_VALUE;
		}
		for (i = 0; i < width; i++){
			image[IMGPOS(i, 0, d, width, height)] = MIN_PIXEL_VALUE;
			image[IMGPOS(i, height - 1, d, width, height)] = MIN_PIXEL_VALUE;
		}
	}

	free(smx);
	free(lgau);
}

void marr_convolution(int *image, float *mask, int nr, int nc, float *res, int NR, int NC, int depth){
	int i, j, ii, jj, n, m, k, kk, d;
	float x;

	k = nr / 2;
	kk = nc / 2;
	for (d = 0; d < depth; d++){
		for (i = 0; i < NR; i++){
			for (j = 0; j < NC; j++){
				x = 0.0;
				for (ii = 0; ii < nr; ii++){
					n = i - k + ii;
					if (n < 0 || n >= NR)
						continue;
					for (jj = 0; jj < nc; jj++){
						m = j - kk + jj;
					
						if (m < 0 || m >= NC)
							continue;
						x = x + mask[MSKPOS(jj, ii, nc, nr)] * (float) (image[IMGPOS(m, n, d, NC, NR)]);
					}
				}
				res[IMGPOS(j, i, d, NC, NR)] = x;
			}
		}
	}
}

void zero_cross(float *lapim, int *image, int width, int height, int depth){
	int i, j, d;

	for (d = 0; d < depth; d++){
		for (i = 1; i < height - 1; i++){
			for (j = 1; j < width - 1; j++){
				image[IMGPOS(j, i, d, width, height)] = 0;
				if (lapim[IMGPOS(j, i - 1, d, width, height)] * lapim[IMGPOS(j, i + 1, d, width, height)] < 0){
					image[IMGPOS(j, i, d, width, height)] = MAX_PIXEL_VALUE;
					continue;
				}
				if (lapim[IMGPOS(j - 1, i, d, width, height)] * lapim[IMGPOS(j + 1, i, d, width, height)] < 0){
					image[IMGPOS(j, i, d, width, height)] = MAX_PIXEL_VALUE;
					continue;
				}
				if (lapim[IMGPOS(j - 1, i + 1, d, width, height)] * lapim[IMGPOS(j + 1, i - 1, d, width, height)] < 0){
					image[IMGPOS(j, i, d, width, height)] = MAX_PIXEL_VALUE;
					continue;
				}
				if (lapim[IMGPOS(j - 1, i - 1, d, width, height)] * lapim[IMGPOS(j + 1, i + 1, d, width, height)] < 0){
					image[IMGPOS(j, i, d, width, height)] = MAX_PIXEL_VALUE;
					continue;
				}
			}
		}
	}
}


