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
	Title: Fast Fourier Transformation (C code)
*/

#include <stdlib.h>
#include <R_ext/Complex.h>
#include <math.h>
#include "defs.h"
#include "config.h"

#ifdef HAVE_FFTW3_H
#include <fftw3.h>

void fft_image_transform(Rcomplex *image, int *width, int *height, int *depth, int direction);

/*
	Function: fft_image
	Apply a FFT image transformation

	Parameters:
		image - Complex matrix (image data)
		width - Width of the matrix
		height - Height of the matrix
		depth - Depth of the matrix
	
	Returns:
		Image transformation
*/
void fft_image(Rcomplex *image, int *width, int *height, int *depth){
	fft_image_transform(image, width, height, depth, FFTW_FORWARD);
}

/*
	Function: fftinv_image
	Apply an inverse FFT image transformation

	Parameters:
		image - Complex matrix (fft data)
		width - Width of the matrix
		height - Height of the matrix
		depth - Depth of the matrix
	
	Returns:
		Image transformation
*/
void fftinv_image(Rcomplex *image, int *width, int *height, int *depth){
	fft_image_transform(image, width, height, depth, FFTW_BACKWARD);
}

/*
	Function: fft_image_transform
	Apply a FFT image transformation (auxiliar function)

	Parameters:
		image - Complex matrix (image data)
		width - Width of the matrix
		height - Height of the matrix
		depth - Depth of the matrix
		direction - Forward or inverse?
	
	Returns:
		Image transformation
*/
void fft_image_transform(Rcomplex *image, int *width, int *height, int *depth, int direction){
	int plane_size = *width * *height * *depth, rank = (*depth == 1) ? 2 : 3;
	int i = 0, j = 0, d = 0;
	int *n = calloc(3, sizeof(int));
	fftw_complex *in, *out;
	fftw_plan p;

	in = (fftw_complex *) fftw_malloc(sizeof(fftw_complex) * plane_size);
	out = (fftw_complex *) fftw_malloc(sizeof(fftw_complex) * plane_size);

	for (d = 0; d < *depth; d++){
		for (j = 0; j < *height; j++){
			for (i = 0; i < *width; i++){
				int row_major_pos = d + *depth * (j + *height * i), im_pos = IMGPOS(i, j, d, *width, *height);
				in[row_major_pos][0] = image[im_pos].r;
				in[row_major_pos][1] = image[im_pos].i;
			}
		}
	}
	n[0] = *width;
	n[1] = *height;
	n[2] = *depth;

	p = fftw_plan_dft(rank, n, in, out, direction, FFTW_ESTIMATE);

	fftw_execute(p);

	for (d = 0; d < *depth; d++){
		for (j = 0; j < *height; j++){
			for (i = 0; i < *width; i++){
				int row_major_pos = d + *depth * (j + *height * i), im_pos = IMGPOS(i, j, d, *width, *height);
				image[im_pos].r = out[row_major_pos][0];
				image[im_pos].i = out[row_major_pos][1];
			}
		}
	}

	free(n);
	fftw_destroy_plan(p);
	fftw_free(in);
	fftw_free(out);
}

#endif

/*
	Function: padding
	Pad an image to the given dimensions (n, m); leave the image in the center

	Parameters:
		image - Complex matrix (image data)
		width - Width of the matrix
		height - Height of the matrix
		depth - Depth of the matrix
		n - New width
		m - New height
		ret - Padded image
	
	Returns:
		Image transformation
*/
void padding(int *image, int *width, int *height, int *depth, int *n, int *m, int *ret){
	int i, j, d;
	int h_ini = (*n - *width) / 2, v_ini = (*m - *height) / 2;

	for (d = 0; d < *depth; d++){
		for (j = h_ini; j < *width + h_ini; j++){
			for (i = v_ini; i < *height + v_ini; i++){
				ret[IMGPOS(j, i, d, *n, *m)] = image[IMGPOS(j - h_ini, i - v_ini, d, *width, *height)];
			}
		}
	}
}

