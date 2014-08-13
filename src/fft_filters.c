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
	Title: Fast Fourier Transformation and Filters (C code)
*/

#include <stdlib.h>
#include <R_ext/Complex.h>
#include <math.h>
#include "defs.h"

/*
	Function: fft_highPass
	Apply a high pass filter to the given fft image

	Parameters:
		fft_image - Complex matrix (FFT of an image)
		width - Width of the matrix
		height - Height of the matrix
		depth - Depth of the matrix
		r - Radius of the filter
	
	Returns:
		Filter applied on fft_image
*/
void fft_highPass(Rcomplex *fft_image, int *width, int *height, int *depth, int *r){
	int i, j, d, radius = *r;
	int hc = *width/2, vc = *height/2;
	for (d = 0; d < *depth; d++){
		for (i=0; i<*height; i++){
			for (j=0; j<*width; j++){
				int dist = (float)sqrt((double)((i-vc)*(i-vc) + (j-hc)*(j-hc)));
				if (dist <= radius){
					fft_image[IMGPOS(j, i, d, *width, *height)].r = 0.0;
					fft_image[IMGPOS(j, i, d, *width, *height)].i = 0.0;
				}
			}
		}
	}
}

/*
	Function: fft_lowPass
	Apply a low pass filter to the given fft image

	Parameters:
		fft_image - Complex matrix (FFT of an image)
		width - Width of the matrix
		height - Height of the matrix
		depth - Depth of the matrix
		r - Radius of the filter
	
	Returns:
		Filter applied on fft_image
*/
void fft_lowPass(Rcomplex *fft_image, int *width, int *height, int *depth, int *r){
	int i, j, d, radius = *r;
	int hc = *width/2, vc = *height/2;
	for (d = 0; d < *depth; d++){
		for (i=0; i<*height; i++){
			for (j=0; j<*width; j++){
				int dist = (float)sqrt((double)((i-vc)*(i-vc) + (j-hc)*(j-hc)));
				if (dist >= radius){
					fft_image[IMGPOS(j, i, d, *width, *height)].r = 0.0;
					fft_image[IMGPOS(j, i, d, *width, *height)].i = 0.0;
				}
			}
		}
	}
}

/*
	Function: fft_bandPass
	Apply a band pass filter to the given fft image

	Parameters:
		fft_image - Complex matrix (FFT of an image)
		width - Width of the matrix
		height - Height of the matrix
		depth - Depth of the matrix
		r1 - Min radius of the filter
		r2 - Max radius of the filter
	
	Returns:
		Filter applied on fft_image
*/
void fft_bandPass(Rcomplex *fft_image, int *width, int *height, int *depth, int *r1, int *r2){
	int i, j, d;
	int hc = *width/2, vc = *height/2;
	for (d = 0; d < *depth; d++){
		for (i=0; i<*height; i++){
			for (j=0; j<*width; j++){
				int dist = (float)sqrt((double)((i-vc)*(i-vc) + (j-hc)*(j-hc)));
				if (dist <= *r1 || dist >= *r2){
					fft_image[IMGPOS(j, i, d, *width, *height)].r = 0.0;
					fft_image[IMGPOS(j, i, d, *width, *height)].i = 0.0;
				}
			}
		}
	}
}

/*
	Function: fft_bandStop
	Apply a band stop filter to the given fft image

	Parameters:
		fft_image - Complex matrix (FFT of an image)
		width - Width of the matrix
		height - Height of the matrix
		depth - Depth of the matrix
		r1 - Min radius of the filter
		r2 - Max radius of the filter
	
	Returns:
		Filter applied on fft_image
*/
void fft_bandStop(Rcomplex *fft_image, int *width, int *height, int *depth, int *r1, int *r2){
	int i, j, d;
	int hc = *width/2, vc = *height/2;
	for (d = 0; d < *depth; d++){
		for (i=0; i<*height; i++){
			for (j=0; j<*width; j++){
				int dist = (float)sqrt((double)((i-vc)*(i-vc) + (j-hc)*(j-hc)));
				if (dist <= *r2 && dist >= *r1){
					fft_image[IMGPOS(j, i, d, *width, *height)].r = 0.0;
					fft_image[IMGPOS(j, i, d, *width, *height)].i = 0.0;
				}
			}
		}
	}
}
