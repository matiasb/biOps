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
	Title: K-means straightforward implementation
*/

#include <stdlib.h>
#include "defs.h"
#include "utils.h"

/*
	Function: kmeans_it
	K Means straightforward classification algorithm - One iteration

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
/* executes a kmeans iteration and updates the new centroids */
int kmeans_it(int *image, int width, int height, int depth, int k, int **clusters, int mean_colors, int *ret){
	int i = 0, j = 0, d = 0, ki = 0; /* indexes iterators */
	int min_dist = -1, temp_dist = -1; /* distances */
	int cluster = 0; /* current cluster class */
	int *pixel_it = malloc(depth * sizeof(int)); /* pixel iterator */
	int *pix_count = (int *) calloc(k, sizeof(int)); /* counts the pixel in each class */
	int changed = 0; /* has centroids changed? */
	float **new_clusters = (float **) malloc(k * sizeof(float *)); /* iterative cluster class mean */

	/* allocate memory to keep cluster class means */
	for (i = 0; i < k; i++){
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
			for (ki = 0; ki < k; ki++){
				/* for each cluster centroid */
				/* distance between current pixel and current centroid */
				temp_dist = sqd_distance(pixel_it, clusters[ki], depth);
				if (min_dist < 0 || temp_dist < min_dist){ /* if it's a nearer point */
					min_dist = temp_dist;
					cluster = ki; /* keeps nearest point's cluster index */
				}
			}
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
	return changed;
}


/*
	Function: kmeans
	K Means straightforward classification algorithm

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
void kmeans(int *image, int *width, int *height, int *depth, int *k, int *maxit, int *mean_colors, int *ret){
	int **clusters;
	int i = 0; /* iterators indexes */
	int changed = 1; /* has centroids changed during last execution? */

	/* initialize first centroids */
	clusters = clusters_init(image, *width, *height, *depth, *k);

	/* do the kmeans iteration */
	i = 0;
	while (i < *maxit && changed){
		changed = kmeans_it(image, *width, *height, *depth, *k, clusters, *mean_colors, ret);
		i++;
	}

	/* free used memory */
	clusters = clusters_destroy(clusters, *k);
}
