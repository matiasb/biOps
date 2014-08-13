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
	Title: Shen-Castan Edge Detector
*/

#include <stdlib.h>
#include <math.h>
#include "defs.h"

#define OUTLINE 25

void shen_castan(int *image, int *width, int *height, int *depth, double *smooth_factor, int *thin_factor, int *adapt_window,
                 double *thresh_ratio, int *hyst);
void shen_castan_aux(int *image, int width, int height, int depth, int *ret);
void compute_ISEF(float *x, float *y, int height, int width, int depth);
void apply_ISEF_vertical(float *x, float *y, float *A, float *B, int height, int width, int depth);
void apply_ISEF_horizontal(float *x, float *y, float *A, float *B, int height, int width, int depth);
int *compute_bli(float *buff1, float *buff2, int height, int width, int depth);
void locate_zero_crossings(float *orig, float *smoothed, int *bli, int height, int width, int depth);
void threshold_edges(float *in, int *out, int height, int width, int depth);
int mark_connected(int i, int j, int d, int level);
int is_candidate_edge(int *buff, float *orig, int row, int col, int d);
float compute_adaptive_gradient(int *bli_buffer, float *orig_buffer, int row, int col, int d, int height, int width, int depth);
void estimate_threshold(double *low, double *hi, int height, int width, int depth);
int *embed(int *im, int outline, int *width, int *height, int *depth);
int *debed(int *im, int outline, int *width, int *height, int *depth);


double b = 0.9; /* smoothing factor, 0 < b < 1 */
double ratio = 0.8;
double low_thresh = 0, high_thresh = 0;
int thinFactor;
int window_size = 7;
int do_hysteresis = 1;

float *lap;
int nr, nc;
int *edges;

/*
	Function: shen_castan
		Performs a Shen - Castan edge detection on the image

	Parameters:
		image - The input image
		width - The image width
		height - Its height
		depth - Its color depth
		smooth_factor - The smooth factor
		thin_factor - The thin factor
		adapt_window - The width of the adaptive window (gradient)
		thresh_ratio - The threshold ratio
		hyst - If true, do hysteresis

	Returns:
		The edge detected image in image
		
*/
void shen_castan(int *image, int *width, int *height, int *depth, double *smooth_factor, int *thin_factor, int *adapt_window,
                 double *thresh_ratio, int *hyst){
	int *ret = NULL, *tmp = NULL, i, plane_size = *width * *height * *depth;
	b = *smooth_factor;
	ratio = *thresh_ratio;
	thinFactor = *thin_factor;
	window_size = *adapt_window;
	do_hysteresis = *hyst;

	tmp = embed(image, OUTLINE, width, height, depth);

	plane_size = *width * *height * *depth;
	ret = (int *) calloc(plane_size, sizeof(int));
	shen_castan_aux(tmp, *width, *height, *depth, ret);

	ret = debed(ret, OUTLINE, width, height, depth);
	plane_size = *width * *height * *depth;
	for (i = 0; i < plane_size; i++){
		image[i] = ret[i];
	}
	free(ret);
}

void shen_castan_aux(int *image, int width, int height, int depth, int *ret){
	register int i;
	float *buffer;
	float *smoothed_buffer;
	int *bli_buffer, plane_size = width * height * depth;

	/* Convert input image to floating point */
	buffer = (float *) calloc(plane_size, sizeof(float));
	for (i = 0; i < plane_size; i++){
		buffer[i] = (float) image[i];
	}

	/* Smooth input image using recursively implemented ISEF filter */
	smoothed_buffer = (float *) calloc(plane_size, sizeof(float));
	compute_ISEF(buffer, smoothed_buffer, height, width, depth);

	/* Compute bli image band-limited laplacian image from smoothed image */
	bli_buffer = compute_bli(smoothed_buffer, buffer, height, width, depth);

	/* Perform edge detection using bli and gradient thresholding */
	locate_zero_crossings(buffer, smoothed_buffer, bli_buffer, height, width, depth);

	free(smoothed_buffer);
	free(bli_buffer);

	threshold_edges(buffer, ret, height, width, depth);
	free(buffer);

	for (i = 0; i < plane_size; i++)
		ret[i] = (ret[i] > 0) ? MIN_PIXEL_VALUE: MAX_PIXEL_VALUE;
}

/* Recursive ISEF filter (Shen and Castan, 1992) */
void compute_ISEF(float *x, float *y, int height, int width, int depth){
	int plane_size = width * height * depth;
	float *A = NULL, *B = NULL;

	A = (float *) calloc(plane_size, sizeof(float)); /* causal component */
	B = (float *) calloc(plane_size, sizeof(float)); /* anti-causal component */

	/* apply the filter in the vertical direction (to the rows) */
	apply_ISEF_vertical(x, y, A, B, height, width, depth);

	/* apply the filter in the horizontal direction to the last result (to the columns) */
	apply_ISEF_horizontal(y, y, A, B, height, width, depth);

	free(A);
	free(B);
}

void apply_ISEF_vertical(float *x, float *y, float *A, float *B, int height, int width, int depth){
	register int row, col, d;
	float b1 = (1.0 - b) / (1.0 + b), b2 = b1*b;

	/* compute boundary conditions */
	for (d = 0; d < depth; d++){
		for (col = 0; col < width; col++){
			/* boundary exists for 1st and last columns */
			int pos = IMGPOS(col, 0, d, width, height);
			A[pos] = b1 * x[pos];
			pos = IMGPOS(col, height - 1, d, width, height);
			B[pos] = b2 * x[pos];
		}
	}

	/* compute causal component */
	for (d = 0; d < depth; d++){
		for (row = 1; row < height; row++){
			for (col = 0; col < width; col++){
				int pos = IMGPOS(col, row, d, width, height), pos2 = IMGPOS(col, row - 1, d, width, height);
				A[pos] = b1 * x[pos] + b * A[pos2];
			}
		}
	}

	/* compute anti-causal component */
	for (d = 0; d < depth; d++){
		for (row = height - 2; row >= 0; row--){
			for (col = 0; col < width; col++){
				int pos = IMGPOS(col, row, d, width, height), pos2 = IMGPOS(col, row + 1, d, width, height);
				B[pos] = b2 * x[pos] + b * B[pos2];
			}
		}
	}

	/* boundary case for computing output of first filter */
	for (d = 0; d < depth; d++){
		for (col = 0; col < width; col++){
			int pos = IMGPOS(col, height - 1, d, width, height);
			y[pos] = A[pos];
		}
	}

	/* compute the output of the first filter and store in y
	   this is the sum of the causal and anti-causal components */
	for (d = 0; d < depth; d++){
		for (row = 0; row < height - 1; row++){
			for (col = 0; col < width; col++){
				int pos = IMGPOS(col, row, d, width, height), pos2 = IMGPOS(col, row + 1, d, width, height);
				y[pos] = A[pos] + B[pos2];
			}
		}
	}
}

void apply_ISEF_horizontal(float *x, float *y, float *A, float *B, int height, int width, int depth){
	register int row, col, d;
	float b1 = (1.0 - b) / (1.0 + b), b2 = b1*b;

	/* compute boundary conditions */
	for (d = 0; d < depth; d++){
		for (row = 0; row < height; row++){
			/* boundary exists for 1st and last columns */
			int pos = IMGPOS(0, row, d, width, height);
			A[pos] = b1 * x[pos];
			pos = IMGPOS(width - 1, row, d, width, height);
			B[pos] = b2 * x[pos];
		}
	}

	/* compute causal component */
	for (d = 0; d < depth; d++){
		for (col = 1; col < width; col++){
			for (row = 0; row < height; row++){
				int pos = IMGPOS(col, row, d, width, height), pos2 = IMGPOS(col - 1, row, d, width, height);
				A[pos] = b1 * x[pos] + b * A[pos2];
			}
		}
	}

	/* compute anti-causal component */
	for (d = 0; d < depth; d++){
		for (col = width - 2; col >= 0; col--){
			for (row = 0; row < height; row++){
				int pos = IMGPOS(col, row, d, width, height), pos2 = IMGPOS(col + 1, row, d, width, height);
				B[pos] = b2 * x[pos] + b * B[pos2];
			}
		}
	}

	/* boundary case for computing output of second filter */
	for (d = 0; d < depth; d++){
		for (row = 0; row < height; row++){
			int pos = IMGPOS(width - 1, row, d, width, height);
			y[pos] = A[pos];
		}
	}

	/* compute the output of the second filter and store in y
	   this is the sum of the causal and anti-causal components */
	for (d = 0; d < depth; d++){
		for (row = 0; row < height; row++){
			for (col = 0; col < width - 1; col++){
				int pos = IMGPOS(col, row, d, width, height), pos2 = IMGPOS(col + 1, row, d, width, height);
				y[pos] = A[pos] + B[pos2];
			}
		}
	}
}


/* Compute the band limited laplacian of the input image */
int *compute_bli(float *buff1, float *buff2, int height, int width, int depth){
	register int i;
	int *bli_buffer;
	int plane_size = width * height * depth;

	bli_buffer = (int *) calloc (plane_size, sizeof(int));
	for (i = 0; i < plane_size; i++)
		bli_buffer[i] = 0;

	/* The BLI is computed by taking the difference between the smoothed image
	   and the original image; in Shen and Castan paper this is shown to approximate
	   the band limited laplacian of the image. The bli is then made by setting all
	   values in the bli to 1 where the laplacian is positive and 0 otherwise. */
	for (i = 0; i < plane_size; i++){
		bli_buffer[i] = ((buff1[i] - buff2[i]) > 0.0);
	}
	return bli_buffer;
}

void locate_zero_crossings(float *orig, float *smoothed, int *bli, int height, int width, int depth){
	register int row, col, d;
	nr = height;
	nc = width;

	for (d = 0; d < depth; d++){
		for (row = 0; row < height; row++){
			for (col = 0; col < width; col++){
				if (row < OUTLINE || row >= height - OUTLINE ||
				    col < OUTLINE || col >= width - OUTLINE){
					/* ignore pixels around the boundary */
					orig[IMGPOS(col, row, d, width, height)] = 0.0;
				}else if (is_candidate_edge(bli, smoothed, row, col, d)){
					/* pixel is a zero crossing of the laplacian => gradient thresholding */
					float grad = compute_adaptive_gradient(bli, smoothed, row, col, d, height, width, depth);
					orig[IMGPOS(col, row, d, width, height)] = grad;
				}else{
					orig[IMGPOS(col, row, d, width, height)] = 0.0;
				}
			}
		}
	}
}

void threshold_edges(float *in, int *out, int height, int width, int depth){
	register int i, j, d;
	int plane_size = width * height * depth;

	lap = in;
	edges = out;
	nr = height;
	nc = width;

	estimate_threshold(&low_thresh, &high_thresh, height, width, depth);
	if (!do_hysteresis)
		low_thresh = high_thresh;

	for (i = 0; i < plane_size; i++)
		out[i] = 0;

	for (d = 0; d < depth; d++){
		for (i = 0; i < height; i++){
			for (j = 0; j < width; j++){
				if (i < OUTLINE || i >= height - OUTLINE ||
				    j < OUTLINE || j >= width - OUTLINE)
					continue;

				/* only check a contour if it is above high_thresh */
				if (lap[IMGPOS(j, i, d, width, height)] > high_thresh)
					/* mark all connected points above low_thresh */
					mark_connected(i, j, d, 0);
			}
		}
	}

	/* erase all points which were 255 */
	for (i = 0; i < plane_size; i++)
		if (out[i] == MAX_PIXEL_VALUE)
			out[i] = MIN_PIXEL_VALUE;

}

/* Return true if it marked something */
int mark_connected(int i, int j, int d, int level){
	int notChainEnd = 0, pos = IMGPOS(j, i, d, nc, nr);

	/* stop if you go off the edge of the image */
	if (i >= nr || i < 0 || j >= nc || j < 0)
		return 0;

	/* stop if the point has already been visited */
	if (edges[pos] != 0)
		return 0;

	/* stop when you hit an image boundary */
	if (lap[pos] == 0.0)
		return 0;

	if (lap[pos] > low_thresh){
		edges[pos] = MIN_PIXEL_VALUE_PLUS_1;
	}else{
		edges[pos] = MAX_PIXEL_VALUE;
	}

	notChainEnd = mark_connected(i, j + 1, d, level + 1);
	notChainEnd = mark_connected(i, j - 1, d, level + 1);
	notChainEnd = mark_connected(i + 1, j + 1, d, level + 1);
	notChainEnd = mark_connected(i + 1, j, d, level + 1);
	notChainEnd = mark_connected(i + 1, j - 1, d, level + 1);
	notChainEnd = mark_connected(i - 1, j - 1, d, level + 1);
	notChainEnd = mark_connected(i - 1, j, d, level + 1);
	notChainEnd = mark_connected(i - 1, j + 1, d, level + 1);

	if (notChainEnd && level > 0){
		/* do some contour thinning */
		if (thinFactor > 0){
			if ((level % thinFactor) != 0){
				/* delete this point */
				edges[pos] = MAX_PIXEL_VALUE;
			}
		}
	}
	return 1;
}

/* Finds zero crossings in laplacian (buff) orig is the smoothed image */
int is_candidate_edge(int *buff, float *orig, int row, int col, int d){
	int pos = IMGPOS(col, row, d, nc, nr), pos2 = IMGPOS(col, row + 1, d, nc, nr),
	    pos3 = IMGPOS(col, row - 1, d, nc, nr), pos4 = IMGPOS(col + 1, row, d, nc, nr),
	    pos5  = IMGPOS(col - 1, row, d, nc, nr);
	/* A positive z-c have a positive 1st derivative, where
	   positive z-c means the second derivative goes from + to -
	   as we cross the edge */
	if (buff[pos] == 1 && buff[pos2] == 0){
		/* positive z-c */
		if (orig[pos2] - orig[pos3] > 0)
			return 1;
		else
			return 0;
	}else if (buff[pos] == 1 && buff[pos4] == 0){
		/* positive z-c */
		if (orig[pos4] - orig[pos5] > 0)
			return 1;
		else
			return 0;
	}else if (buff[pos] == 1 && buff[pos3] == 0){
		/* negative z-c */
		if (orig[pos2] - orig[pos3] < 0)
			return 1;
		else
			return 0;
	}else if (buff[pos] == 1 && buff[pos5] == 0){
		/* negative z-c */
		if (orig[pos4] - orig[pos5] < 0)
			return 1;
		else
			return 0;
	}else{
		/* not a z-c */
		return 0;
	}
}

float compute_adaptive_gradient(int *bli_buffer, float *orig_buffer, int row, int col, int d, int height, int width, int depth){
	register int i, j, k;
	float sum_on, sum_off;
	float avg_on, avg_off;
	int num_on, num_off;

	sum_on = sum_off = 0.0;
	num_on = num_off = 0;
	avg_on = avg_off = 0.0;

	for (k = 0; k < depth; k++){
		for (i = (-window_size / 2); i <= (window_size / 2); i++){
			for (j = (-window_size / 2); j <= (window_size / 2); j++){
				int pos = IMGPOS(col + j, row + i, k, width, height);
				if (bli_buffer[pos]){
					sum_on = sum_on + orig_buffer[pos];
					num_on++;
				}else{
					sum_off = sum_off + orig_buffer[pos];
					num_off++;
				}
			}
		}
	}

	if (sum_off)
		avg_off = sum_off / num_off;
	if (sum_on)
		avg_on = sum_on / num_on;

	return (avg_off - avg_on);
}

void estimate_threshold(double *low, double *hi, int height, int width, int depth){
	float vmax, vmin, scale, x;
	int i, j, k, d, hist[MAX_PIXEL_VALUE_PLUS_1], count;

	/* build a histogram of the laplacian image */
	
	vmin = vmax = fabs((float) (lap[IMGPOS(20, 20, 0, width, height)]));
	for (d = 0; d < depth; d++){
		for (i = 0; i < height; i++){
			for (j = 0; j < width; j++){
				if (i < OUTLINE || i >= height - OUTLINE ||
				    j < OUTLINE || j >= width - OUTLINE)
					continue;
				x = lap[IMGPOS(j, i, d, width, height)];
				if (vmin > x)
					vmin = x;
				if (vmax < x)
					vmax = x;
			}
		}
	}

	for (k = 0; k < MAX_PIXEL_VALUE_PLUS_1; k++){
		hist[k] = 0;
	}
	scale = 256.0 / (vmax - vmin + 1);

	for (d = 0; d < depth; d++){
		for (i = 0; i < height; i++){
			for (j = 0; j < width; j++){
				if (i < OUTLINE || i >= height - OUTLINE ||
				    j < OUTLINE || j >= width - OUTLINE)
					continue;
				x = lap[IMGPOS(j, i, d, width, height)];
				k = (int) ((x - vmin) * scale);
				hist[k]++;
			}
		}
	}

	/* the high threshold should be > 80 or 90% of the pixels */
	k = MAX_PIXEL_VALUE;
	j = (int) (ratio * height * width * depth);
	count = hist[MAX_PIXEL_VALUE];
	while (count < j){
		k--;
		if (k < MIN_PIXEL_VALUE)
			break;
		count = count + hist[k];
	}
	*hi = (double) k / scale + vmin;
	*low = (*hi) / 2;
}

int *embed(int *im, int outline, int *width, int *height, int *depth){
	int i, j, d, I, J;
	int *new;
	int h = *height, w = *width, k = *depth;
	int new_width, new_height;

	outline = outline + 2;
	new_width = w + outline + outline;
	new_height = h + outline + outline;
	new = (int *) calloc(new_width * new_height * k, sizeof(int));

	for (d = 0; d < k; d++){
		for (i = 0; i < new_height; i++){
			for (j = 0; j < new_width; j++){
				I = (i - outline + h) % h;
				J = (j - outline + w) % w;
				I = (I < 0) ? I + h: I;
				J = (J < 0) ? J + w: J;
				new[IMGPOS(j, i, d, new_width, new_height)] = im[IMGPOS(J, I, d, w, h)];
			}
		}
	}

/*	free(im);*/
	im = new;
	*width = new_width;
	*height = new_height;
	return im;
}

int *debed(int *im, int outline, int *width, int *height, int *depth){
	int i, j, d;
	int *new;
	int h = *height, w = *width, k = *depth;
	int new_width, new_height;

	outline = outline + 2;
	new_width = w - outline - outline;
	new_height = h - outline - outline;
	new = (int *) calloc(new_width * new_height * k, sizeof(int));

	for (d = 0; d < k; d++){
		for (i = 0; i < new_height - 1; i++){
			for (j = 1; j < new_width; j++){
				new[IMGPOS(j, i, d, new_width, new_height)] = im[IMGPOS(j + outline, i + outline, d, w, h)];
				new[IMGPOS(j, new_height - 1, d, new_width, new_height)] = MAX_PIXEL_VALUE;
			}
			new[IMGPOS(0, i, d, new_width, new_height)] = MAX_PIXEL_VALUE;
		}
	}

	free(im);
	im = new;
	*width = new_width;
	*height = new_height;
	return im;
}
