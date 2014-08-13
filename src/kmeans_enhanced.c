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
	Title: K-means enhanced implementation
*/

#include <stdlib.h>
#include "defs.h"
#include "utils.h"

/*
	Function: kmeans_enhanced_it
	K Means enhanced classification algorithm - One iteration

	Parameters:
		image - The image data
		width - Width of the image
		height - Heigth of the image
		depth - Color depth of the image
		k - Number of clusters in the classification
		clusters - Current clusters values
		mean_colors - Use the mean centroid values as cluster values?
		ret - The result image
		num_it - Number of the current iteration

	Returns:
		The clustered image
*/
/* executes a kmeans iteration and updates the new centroids */
int kmeans_enhanced_it(int *image, int width, int height, int depth, int k, int **clusters, int mean_colors, int *ret, int num_it){
	int i = 0, j = 0, d = 0, ki = 0; /* indexes iterators */
	int min_dist = -1, temp_dist = -1; /* distances */
	int cluster = 0; /* current cluster class */
	int *pixel_it = malloc(depth * sizeof(int)); /* pixel iterator */
	int *pix_count = (int *) calloc(k, sizeof(int)); /* counts the pixel in each class */
	int changed = 0; /* has centroids changed? */
	float **new_clusters = (float **) malloc(k * sizeof(float *)); /* iterative cluster class mean */
	int *dists = (depth == 1) ? (int *) calloc(width*height, sizeof(int)) : NULL;

	/* allocate memory to keep cluster class means */
	for (i = 0; i < k; i++){
		new_clusters[i] = calloc(depth, sizeof(float));
	}

	/* kmeans iteration */
	for (i = 0; i < width; i++){
		for (j = 0; j < height; j++){
			/* for each pixel */
			int l = 0;
			int no_enh = 0;
			min_dist = -1;

			/* current pixel value */
			for (l = 0; l < depth; l++){
				pixel_it[l] = image[IMGPOS(i, j, l, width, height)];
			}

			/* enhanced iteration */
			if (num_it >= 2){
				int old_cluster = ret[IMGPOS(i, j, 0, width, height)]; /* previous iteration cluster id */
				int old_dist = (dists) ? dists[MSKPOS(i, j, width, height)] : ret[IMGPOS(i, j, 1, width, height)]; /* previous iteration minimum distance */
				temp_dist = sqd_distance(pixel_it, clusters[old_cluster], depth); /* distance to updated centroid */
				if (temp_dist > old_dist) /* new centroid is further => check all centroids */
					no_enh = 1;
				else /* new centroid is nearer => same cluster */
					cluster = old_cluster;
			}

			if (num_it < 2 || no_enh){ /* standard iteration (two firsts or if check needed) */
				for (ki = 0; ki < k; ki++){
					/* for each cluster centroid */
					/* distance between current pixel and current centroid */
					temp_dist = sqd_distance(pixel_it, clusters[ki], depth);
					if (min_dist < 0 || temp_dist < min_dist){ /* if it's a nearer point */
						min_dist = temp_dist;
						cluster = ki; /* keeps nearest point's cluster index */
					}
				}
				ret[IMGPOS(i, j, 0, width, height)] = cluster; /* nearer centroid id */
				if (dists)
					dists[MSKPOS(i, j, width, height)] = min_dist; /* distance to centroid */
				else
					ret[IMGPOS(i, j, 1, width, height)] = min_dist; /* distance to centroid */
			}
			for (l = 0; l < depth; l++){ /* updates cluster centroids means and sets return image */
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
	if (dists)
		free(dists);
	free(new_clusters);
	free(pixel_it);
	return changed;
}


/*
	Function: kmeans_enhanced
	K Means enhanced classification algorithm

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
void kmeans_enhanced(int *image, int *width, int *height, int *depth, int *k, int *maxit, int *mean_colors, int *ret){
	int **clusters;
	int i = 0, j = 0, d = 0; /* iterators indexes */
	int changed = 1; /* has centroids changed during last execution? */

	clusters = clusters_init(image, *width, *height, *depth, *k);

	/* do the kmeans iteration */
	i = 0;
	while (i < *maxit && changed){
		changed = kmeans_enhanced_it(image, *width, *height, *depth, *k, clusters, *mean_colors, ret, i);
		i++;
	}

	/* update return image pixel values */
	for (i = 0; i < *width; i++){
		for (j = 0; j < *height; j++){
			int cluster = ret[IMGPOS(i, j, 0, *width, *height)];
			for (d = 0; d < *depth; d++){
				ret[IMGPOS(i, j, d, *width, *height)] = (*mean_colors) ? clusters[cluster][d] : clusters[cluster][d];
			}
		}
	}

	/* free used memory */
	clusters = clusters_destroy(clusters, *k);
}

