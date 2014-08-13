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
	Title: Canny Edge Detector
*/

#include <stdlib.h>
#include <math.h>
#include "defs.h"
#include "gaussian.h"

#define MAX_MASK_SIZE 20
#define MAG_SCALE 20.0

void canny(int *image, int *width, int *height, int *depth, double *s, int *low, int *high);
void canny_aux(int *image, int width, int height, int depth, double s, int *mag);
void hysteresis(int high, int low, int *image, int *mag, int width, int height, int depth);
int trace(int i, int j, int d, int low, int *image, int *mag, int width, int height, int depth);
void separable_convolution(int *image, int width, int height, int depth, float *gau, int gau_width, float *smx, float *smy);
void dxy_separable_convolution(float *im, int height, int width, int depth, float *gau, int gau_width, float *sm, int which);
void nonmax_suppress(float *dx, float *dy, int height, int width, int depth, int *mag);
void estimate_thresh(int *mag, int width, int height, int depth, int *low, int *high);

/*
	Function: canny
		Performs a Canny edge detection on the image

	Parameters:
		image - The input image
		width - The image width
		height - Its height
		depth - Its color depth
		s - The Gaussian standard deviation
		low - Lower threshold
		high - Higher threshold

	Returns:
		The edge detected image in image
		
*/
void canny(int *image, int *width, int *height, int *depth, double *s, int *low, int *high){
	int plane_size = *width * *height * *depth;
	int *magim, i, d;

	magim = (int *) malloc (plane_size * sizeof(int));

	/* Apply the filter */
	canny_aux(image, *width, *height, *depth, *s, magim);

	/* Hysteresis thresholding of edge pixels */
	hysteresis(*high, *low, image, magim, *width, *height, *depth);

	/* Clear the boundary */
	for (d = 0; d < *depth; d++){
		for (i = 0; i < *height; i++){
			image[IMGPOS(0, i, d, *width, *height)] = MAX_PIXEL_VALUE;
			image[IMGPOS(*width - 1, i, d, *width, *height)] = MAX_PIXEL_VALUE;
		}
		for (i = 0; i < *width; i++){
			image[IMGPOS(i, 0, d, *width, *height)] = MAX_PIXEL_VALUE;
			image[IMGPOS(i, *height - 1, d, *width, *height)] = MAX_PIXEL_VALUE;
		}
	}

	free(magim);
}

void canny_aux(int *image, int width, int height, int depth, double s, int *mag){
	int gau_width = 0;
	float *smx, *smy, *dx, *dy;
	int i, n;
	float gau[MAX_MASK_SIZE], dgau[MAX_MASK_SIZE];

	/* Gaussian and derivative of Gaussian filter mask */
	for (i = 0; i < MAX_MASK_SIZE; i++){
		gau[i] = meanGauss((float) i, s);
		if (gau[i] < 0.005){
			gau_width = i;
			break;
		}
		dgau[i] = dGauss((float) i, s);
	}

	n = gau_width + gau_width + 1;

	smx = (float *) malloc(width * height * depth * sizeof(float));
	smy = (float *) malloc(width * height * depth * sizeof(float));

	/* Convolution of image with a Gaussian in x and y directions */
	separable_convolution(image, width, height, depth, gau, gau_width, smx, smy);

	/* Convolve smoothed data with a derivative */
	dx = (float *) malloc(width * height * depth * sizeof(float));
	dxy_separable_convolution(smx, height, width, depth, dgau, gau_width, dx, 1);
	free(smx);

	dy = (float *) malloc(width * height * depth * sizeof(float));
	dxy_separable_convolution(smy, height, width, depth, dgau, gau_width, dy, 0);
	free(smy);

	/* Non-maximum suppression (edge pixels should be a local max) */
	nonmax_suppress(dx, dy, height, width, depth, mag);

	free(dx);
	free(dy);
}

/* Hysteresis thresholding of edge pixels.
   Starting at pixels with a value greater than the HIGH threshold, trace a connected sequence
   of pixels that have a value greater than the LOW threshold */
void hysteresis(int high, int low, int *image, int *mag, int width, int height, int depth){
	int i, j, d, plane_size = width * height * depth;
	for (i = 0; i < plane_size; i++){
		image[i] = 0;
	}

	if (high < low){
		estimate_thresh(mag, width, height, depth, &low, &high);
	}

	/* For each edge with a magnitude above the high threshold,
	   begin tracing edge pixels that are above the low threshold */
	for (d = 0; d < depth; d++){
		for (i = 0; i < height; i++){
			for (j = 0; j < width; j++){
				if (mag[IMGPOS(j, i, d, width, height)] >= high){
					trace(i, j, d, low, image, mag, width, height, depth);
				}
			}
		}
	}

	/* Make the edge black */
	for (i = 0; i < plane_size; i++){
		image[i] = (image[i] == 0) ? MAX_PIXEL_VALUE: MIN_PIXEL_VALUE;
	}

}

/* Recursively trace edge pixels that have a threshold greater than the low edge threshold,
   continuing from the pixel at (i,j) */
int trace(int i, int j, int d, int low, int *image, int *mag, int width, int height, int depth){
	int n, m;
	char flag = 0;

	if (image[IMGPOS(j, i, d, width, height)] == 0){
		image[IMGPOS(j, i, d, width, height)] = MAX_PIXEL_VALUE;
		flag = 0;

		for (n = -1; n <= 1; n++){
			for (m = -1; m <= 1; m++){
				if (i == 0 && m == 0)
					continue;
				if (i + n > 0 && i + n < height && j + m > 0 && j + m < width && mag[IMGPOS(j + m, i + n, d, width, height)] >= low){
					if (trace(i + n, j + m, d, low, image, mag, width, height, depth)){
						flag = 1;
						break;
					}
				}
			}
			if (flag)
				break;
		}
		return 1;
	}
	return 0;
}


void separable_convolution(int *image, int width, int height, int depth, float *gau, int gau_width, float *smx, float *smy){
	int i, j, k, d, I1, I2;
	float x, y;

	for (d = 0; d < depth; d++){
		for (i = 0; i < height; i++){
			for (j = 0; j < width; j++){
				x = gau[0] * image[IMGPOS(j, i, d, width, height)];
				y = gau[0] * image[IMGPOS(j, i, d, width, height)];

				for (k = 1; k < gau_width; k++){
					I1 = (i + k) % height;
					I2 = (i - k + height) % height;
					y = y + gau[k] * image[IMGPOS(j, I1, d, width, height)] + gau[k] * image[IMGPOS(j, I2, d, width, height)];
					I1 = (j + k) % width;
					I2 = (j - k + width) % width;
					x = x + gau[k] * image[IMGPOS(I1, i, d, width, height)] + gau[k] * image[IMGPOS(I2, i, d, width, height)];
				}
				smx[IMGPOS(j, i, d, width, height)] = x;
				smy[IMGPOS(j, i, d, width, height)] = y;
			}
		}
	}
}

void dxy_separable_convolution(float *image, int height, int width, int depth, float *gau, int gau_width, float *sm, int which){
	int i, j, k, d, I1, I2;
	float x;

	for (d = 0; d < depth; d++){
		for (i = 0; i < height; i++){
			for (j = 0; j < width; j++){
				x = 0.0;
				for (k = 1; k < gau_width; k++){
					if (which == 0){
						I1 = (i + k) % height;
						I2 = (i - k + height) % height;
						x = x - gau[k] * image[IMGPOS(j, I1, d, width, height)] + gau[k] * image[IMGPOS(j, I2, d, width, height)];
					}else{
						I1 = (j + k) % width;
						I2 = (j - k + width) % width;
						x = x - gau[k] * image[IMGPOS(I1, i, d, width, height)] + gau[k] * image[IMGPOS(I2, i, d, width, height)];
					}
				}
				sm[IMGPOS(j, i, d, width, height)] = x;
			}
		}
	}
}


void nonmax_suppress(float *dx, float *dy, int height, int width, int depth, int *mag){
	int i, j, d;
	float xx, yy, g1, g2, g3, g4, g, xc, yc;

	for (d = 0; d < depth; d++){
		for (i = 1; i < height - 1; i++){
			for (j = 1; j < width - 1; j++){
				mag[IMGPOS(j, i, d, width, height)] = 0;

				/* Treat the x and y derivatives as components of a vector */
				xc = dx[IMGPOS(j, i, d, width, height)];
				yc = dy[IMGPOS(j, i, d, width, height)];
				if (fabs(xc) < 0.01 && fabs(yc) < 0.01)
					continue;
				g = norm(xc, yc);

				/* Follow the gradient direction, as indicated by the direction of the vector (xc, yc);
				   retain pixels that are a local maximum */
				if (fabs(yc) > fabs(xc)){
					/* y component bigger => up/down direction */
					xx = fabs(xc) / fabs(yc);
					yy = 1.0;

					g2 = norm(dx[IMGPOS(j, i - 1, d, width, height)], dy[IMGPOS(j, i - 1, d, width, height)]);
					g4 = norm(dx[IMGPOS(j, i + 1, d, width, height)], dy[IMGPOS(j, i + 1, d, width, height)]);
					if (xc * yc > 0.0){
						g3 = norm(dx[IMGPOS(j + 1, i + 1, d, width, height)], dy[IMGPOS(j + 1, i + 1, d, width, height)]);
						g1 = norm(dx[IMGPOS(j - 1, i - 1, d, width, height)], dy[IMGPOS(j - 1, i - 1, d, width, height)]);
					}else{
						g3 = norm(dx[IMGPOS(j - 1, i + 1, d, width, height)], dy[IMGPOS(j - 1, i + 1, d, width, height)]);
						g1 = norm(dx[IMGPOS(j + 1, i - 1, d, width, height)], dy[IMGPOS(j + 1, i - 1, d, width, height)]);
					}
				}else{
					/* x component bigger => left/right direction */
					xx = fabs(yc) / fabs(xc);
					yy = 1.0;

					g2 = norm(dx[IMGPOS(j + 1, i, d, width, height)], dy[IMGPOS(j + 1, i, d, width, height)]);
					g4 = norm(dx[IMGPOS(j - 1, i, d, width, height)], dy[IMGPOS(j - 1, i, d, width, height)]);
					if (xc * yc > 0.0){
						g3 = norm(dx[IMGPOS(j - 1, i - 1, d, width, height)], dy[IMGPOS(j - 1, i - 1, d, width, height)]);
						g1 = norm(dx[IMGPOS(j + 1, i + 1, d, width, height)], dy[IMGPOS(j + 1, i + 1, d, width, height)]);
					}else{
						g3 = norm(dx[IMGPOS(j - 1, i + 1, d, width, height)], dy[IMGPOS(j - 1, i + 1, d, width, height)]);
						g1 = norm(dx[IMGPOS(j + 1, i - 1, d, width, height)], dy[IMGPOS(j + 1, i - 1, d, width, height)]);
					}
				}

				/* Compute the interpolated value of the gradient magnitude */
				if ((g > (xx * g1 + (yy - xx) * g2)) && (g > (xx * g3 + (yy - xx) * g4))){
					if (g * MAG_SCALE <= 255){
						mag[IMGPOS(j, i, d, width, height)] = (int) (g * MAG_SCALE);
					}else{
						mag[IMGPOS(j, i, d, width, height)] = MAX_PIXEL_VALUE;
					}
				}else{
					mag[IMGPOS(j, i, d, width, height)] = 0;
				}
			}
		}
	}
}


void estimate_thresh(int *mag, int width, int height, int depth, int *low, int *high){
	int i, j, d, k, hist[MAX_PIXEL_VALUE_PLUS_1], count;

	/* Build histogram of the magnitude image */
	for (k = 0; k < MAX_PIXEL_VALUE_PLUS_1; k++)
		hist[k] = 0;

	for (d = 0; d < depth; d++){
		for (i = 1; i < height - 1; i++){
			for (j = 1; j < width - 1; j++){
				hist[mag[IMGPOS(j, i, d, width, height)]]++;
			}
		}
	}

	/* The high threshold should be greater than 80/90% of the pixels */
	j = (width < height) ? height: width;
	j = (int) (0.8 * j);
	
	k = MAX_PIXEL_VALUE;

	count = hist[MAX_PIXEL_VALUE];
	while (count < j){
		k--;
		if (k < MIN_PIXEL_VALUE)
			break;
		count = count + hist[k];
	}
	if (k == 0)
		k = MAX_PIXEL_VALUE;
	*high = k;
	
	i = 0;
	while (hist[i] == 0){
		i++;
		if (i > MAX_PIXEL_VALUE)
			break;
	}
	*low = (k + i) / 2.0;
}


