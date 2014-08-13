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
	Title: K-means implementation using kd-trees
*/

#include <stdlib.h>
#include "defs.h"
#include "utils.h"
#include "kdtree.h"

/*
	Function: kdtree_kmeans_it
	K Means kdtree classification algorithm - One iteration

	Parameters:
		image - The image data
		width - Width of the image
		height - Heigth of the image
		depth - Color depth of the image
		k - Number of clusters in the classification
		clusters - Current clusters values
		mean_colors - Use the mean centroid values as cluster values?
		ret - The result image

	Returns:
		The clustered image
*/
int kdtree_kmeans_it(int *image, int width, int height, int depth, int k, int **clusters, int mean_colors, int *ret){
	int i = 0, j = 0, d = 0; /* indexes iterators */
	int min_dist = -1; /* distances */
	int cluster = 0; /* current cluster class */
	int *pixel_it = malloc(depth * sizeof(int)); /* pixel iterator */
	int *pix_count = (int *) calloc(k, sizeof(int)); /* counts the pixel in each class */
	int changed = 0; /* has centroids changed? */
	float **new_clusters = (float **) malloc(k * sizeof(float *)); /* iterative cluster class mean */
	int *hr_min = calloc(depth, sizeof(int)), *hr_max = calloc(depth, sizeof(int));
	kdtree kd_nn = NULL;

	for (i = 0; i < depth; i++){
		hr_min[i] = MIN_PIXEL_VALUE;
		hr_max[i] = MAX_PIXEL_VALUE;
	}

	kd_nn = kdtree_create(depth, hr_min, hr_max);


	/* allocate memory to keep cluster class means */
	for (i = 0; i < k; i++){
		for (d = 0; d < depth; d++){
			hr_min[d] = MIN_PIXEL_VALUE;
			hr_max[d] = MAX_PIXEL_VALUE;
		}
		kd_nn = kdtree_add(kd_nn, i, clusters[i], hr_min, hr_max);
		new_clusters[i] = calloc(depth, sizeof(float));
	}

	/* kmeans iteration */
	for (i = 0; i < width; i++){
		for (j = 0; j < height; j++){
			/* for each pixel */
			int l = 0;
			min_dist = -1;
			for (l = 0; l < depth; l++){
				pixel_it[l] = image[IMGPOS(i, j, l, width, height)];
			}
			cluster = kdtree_nearestneighbor_id(kd_nn, pixel_it);
			for (l = 0; l < depth; l++){ /* updates cluster centroids means and sets return image */
				ret[IMGPOS(i, j, l, width, height)] = (mean_colors) ? clusters[cluster][l] : clusters[cluster][l];
				new_clusters[cluster][l] = mean_it(new_clusters[cluster][l], pix_count[cluster], pixel_it[l]);
			}
			pix_count[cluster]++;
		}
	}

	/* update clusters and free used memory */
	for (i = 0; i < k; i++){
		for (d = 0; d < depth; d++){
			if (clusters[i][d] != (int) new_clusters[i][d]){
				clusters[i][d] = (int) (new_clusters[i][d]);
				changed = 1;
			}
		}
		free(new_clusters[i]);
	}
	free(new_clusters);
	free(pixel_it);
	free(hr_min);
	free(hr_max);
	kdtree_destroy(kd_nn);
	return changed;
}


/*
	Function: kdtree_kmeans
	K Means with kdtree nearest neighbor search classification algorithm

	Parameters:
		image - The image data
		width - Width of the image
		height - Heigth of the image
		depth - Color depth of the image
		k - Number of clusters in the classification
		maxit - Maximum number of iterations of the algorithm
		mean_colors - Use the mean centroid values as cluster values?
		ret - The result image

	Returns:
		The clustered image
*/
void kdtree_kmeans(int *image, int *width, int *height, int *depth, int *k, int *maxit, int *mean_colors, int *ret){
	int **clusters;
	int i = 0; /* iterators indexes */
	int changed = 1; /* has centroids changed during last execution? */

	clusters = clusters_init(image, *width, *height, *depth, *k);

	/* do the kmeans iteration */
	i = 0;
	while (i < *maxit && changed){
		changed = kdtree_kmeans_it(image, *width, *height, *depth, *k, clusters, *mean_colors, ret);
		i++;
	}

	/* free used memory */
	clusters = clusters_destroy(clusters, *k);
}
