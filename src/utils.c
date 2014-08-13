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
	Title: Some useful functions for k-means implementations
*/

#include <stdlib.h>
#include <math.h>
#include "defs.h"
#include "utils.h"

/*
	Function: mean_it
		Performs an iterative mean over int values. Helpful not to compute a sample mean every time
		a specimen is added (or removed)

	Parameters:
		m - Mean value for previous step
		t - Previous step sample's size
		v - Current value to be computed

	Returns:
		float - Current mean
		
	See also:
		sd_it
*/
float mean_it(float m, int t, int v){
	float ret = m + (v - m) / (double)(t + 1);
	return ret;
}

/*
	Function: sd_it
		Performs an iterative standard desviation over int values.
		Helpful not to compute every time a specimen is added (or removed)

	Parameters:
		sd - Standard desviation for previous step
		t - Previous step sample's size
		v - Current value to be computed
		m - Mean value for previous step
		mnext - Mean value with v added

	Returns:
		float - Current standard desviation
		
	See also:
		mean_it
*/
float sd_it(float sd, int t, int v, float m, float mnext){
	float ret = 0;
	if (t > 0)
		ret = (1 - 1/(double) t) * sd * sd + (t + 1)*(mnext - m)*(mnext - m);
	return sqrt(ret);
}

/*
	Function: rand_pixel
		Chooses a 2-coord number in a given range
	
	Parameters:
		width, height - upper limit for random value
	
	Returns:
		int[2] - An array with 2 random values in the range given
*/
int *rand_pixel(int width, int height){
	int *ret = malloc(2*sizeof(int));
	ret[0] = (int) width * (rand() / (RAND_MAX + 1.0));
	ret[1] = (int) height * (rand() / (RAND_MAX + 1.0));

	return ret;
}

/*
	Function: sqd-distance
		Determines the squared distance for k-dimension points represented as arrays
		of same length
	
	Parameters:
		p1, p2 - k-dimensions points represented by integer arrays
		k - dimension
	
	Returns:
		int - Squared distance between given points
*/
int sqd_distance(int *p1, int *p2, int k){
	int ret = 0, i = 0;
	for (i = 0; i < k; i++){
		int next = p1[i] - p2[i];
		ret = ret + next*next;
	}
	return ret;
}

/*
	Function: int_distance
		Determines the distance for k-dimension points represented as arrays
		of same length.
	
	Parameters:
		p1, p2 - k-dimensions points represented by integer arrays
		k - dimension
	
	Returns:
		int - Rounded distance between given points.
*/
int int_distance(int *p1, int *p2, int k){
	int ret = sqd_distance(p1, p2, k);
	return (int) sqrt(ret);
}

/*
	Function: float_distance
		Determines the distance for k-dimension points represented as arrays
		of same length.
	
	Parameters:
		p1, p2 - k-dimensions points represented by integer arrays
		k - dimension
	
	Returns:
		float - Distance between given points.
*/
float float_distance(float *p1, float *p2, int k){
	float ret = 0;
	int i = 0;
	for (i = 0; i < k; i++){
		float next = p1[i] - p2[i];
		ret = ret + next*next;
	}
	return sqrt(ret);
}

/*
	Function: clusters_init
		Fills an array with random "pixels", in given range, chosen from provided image.
	
	Parameters:
		image - Image from which values are taken
		width - image's width
		height - image's height
		depth - image's depth
		k - array length to be filled
	
	Returns:
		int** - A "pixel" random array taken from the provided image
*/
int **clusters_init(int *image, int width, int height, int depth, int k){
	int **clusters = (int **) malloc(k * sizeof(int *)); /* current centroids */
	int i = 0, j = 0;
	/* initialize first centroids */
	for (i = 0; i < k; i++){
		int *pixel = rand_pixel(width, height); /* get random pixel coords from image */
		clusters[i] = malloc(sizeof(int) * depth);
		for (j = 0; j < depth; j++){
			clusters[i][j] = image[IMGPOS(pixel[0], pixel[1], j, width, height)];
		}
		free(pixel);
	}
	return clusters;
}

/*
	Function: clusters_destroy
		Frees an pixel array
	
	Parameters:
		clusters - array to be freed
		k - array length
	
	Returns:
		int** - Freed array
*/
int **clusters_destroy(int **clusters, int k){
	int i = 0;
	for (i = 0; i < k; i++){
		free(clusters[i]);
	}
	free(clusters);
	clusters = NULL;
	return clusters;
}
