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
	Title: Noise Generation Operations (C code)
*/

#include <stdlib.h>
#include <math.h>
#include "defs.h"

#define unit_random() (1.0 * rand() / RAND_MAX)

/*
	Function: saltPepperNoise
	Adds salt and pepper noise to an image

	Parameters:
		image - The input image
		width - The image width
		height - Its height
		depth - Its color depth
		percent - Noise percent

	Returns:
		The image with salt and pepper noise
*/
void saltPepperNoise(int *image, int *width, int *height, int *depth, double *percent){
	int i = 0, plane_size = *width * *height * *depth;
	double pr = 1.0 - *percent / 100.0;

	srand(1);

	for (i = 0; i < plane_size; i++){
			/* Generate random number between -1.0 and +1.0 */
			double random = 2.0 * (rand() - RAND_MAX / 2.0) / RAND_MAX;
			if (random > pr){
				/* Salt noise */
				image[i] = MAX_PIXEL_VALUE;
			}else if (random < -pr){
				/* Pepper noise */
				image[i] = MIN_PIXEL_VALUE;
			}
	}
}

/*
	Function: gaussianNoise
	Adds gaussian noise to an image

	Parameters:
		image - The input image
		width - The image width
		height - Its height
		depth - Its color depth
		mean - Gaussian mean
		variance - Gaussian variance

	Returns:
		The image with gaussian noise
*/
void gaussianNoise(int *image, int *width, int *height, int *depth, double *mean, double *variance){
	int i = 0, plane_size = *width * *height * *depth;
	double temp, u1, u2;
	int g1, g2;

	srand(1);
	for (i = 0; i < plane_size; i = i + 2){
			int res1 = 0, res2 = 0;
			/* Generate random uniform number between 0 and 1.0 */
			while (u1 == 0.0) u1 = unit_random();
			u2 = unit_random();
			temp = sqrt(-2.0 * *variance * log(u1));
			/* Generate 2 gaussians - Box Muller method */
			g1 = (int) (temp * cos(TWO_PI*u2) + *mean);
			g2 = (int) (temp * sin(TWO_PI*u2) + *mean);

			res1 = CLIP(image[i] + g1, MIN_PIXEL_VALUE, MAX_PIXEL_VALUE);
			image[i] = res1;

			if (i + 1 < plane_size){
				res2 = CLIP(image[i + 1] + g2, MIN_PIXEL_VALUE, MAX_PIXEL_VALUE);
				image[i + 1] = res2;
			}
			u1 = 0.0;
	}
}
