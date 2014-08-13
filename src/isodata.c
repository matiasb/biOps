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
	Title: Isodata implementation
*/

#include <stdlib.h>
#include "defs.h"
#include "isodata_cluster.h"
#include "utils.h"

/*
	Function: getTotalSD
	Get the standard deviation in the image, by channel.

	Parameters:
		image - The image data
		width - Width of the image
		height - Heigth of the image
		depth - Color depth of the image

	Returns:
		An array of depth float values, the sd of each channel
*/
float *getTotalSD(int *image, int width, int height, int depth){
	float *sd_total = calloc(depth, sizeof(float));
	float *means = calloc(depth, sizeof(float));
	int *count = calloc(depth, sizeof(int));
	int i = 0, j = 0, d = 0;
	for (i = 0; i < width; i++){
		for (j = 0; j < height; j++){
			for (d = 0; d < depth; d++){
				int value = image[IMGPOS(i, j, d, width, height)];
				float old_mean = means[d];
				means[d] = mean_it(old_mean, count[d], value);
				sd_total[d] = sd_it(sd_total[d], count[d], value, old_mean, means[d]);
				count[d]++;
			}
		}
	}
	free(count);
	free(means);

	return sd_total;
}

/*
	Function: forgy_it
	One iteration of the forgy algorithm.

	Parameters:
		image - The image data
		width - Width of the image
		height - Heigth of the image
		depth - Color depth of the image
		k - Number of clusters in the classification
		cl - Clusters information
		ret - The result image

	Returns:
		The clustered image
*/
void forgy_it(int *image, int width, int height, int depth, int k, clusters cl, int *ret){
	int i = 0, j = 0, d = 0, ki = 0; /* indexes iterators */
	int min_dist = -1, temp_dist = -1; /* distances */
	int cluster = 0; /* current cluster class */
	int *pixel_it = malloc(depth * sizeof(int)); /* pixel iterator */
	int *clusters_ids = getValidIds(cl);
	int count = getClusterCount(cl);

	/* kmeans iteration */
	for (i = 0; i < width; i++){
		for (j = 0; j < height; j++){
			/* for each pixel */
			min_dist = -1;

			/* current pixel value */
			for (d = 0; d < depth; d++){
				pixel_it[d] = image[IMGPOS(i, j, d, width, height)];
			}

			for (ki = 0; ki < count; ki++){
				/* for each cluster centroid */
				/* distance between current pixel and current centroid */
				int *cluster_centroid = getClusterValue(cl, clusters_ids[ki]);
				temp_dist = sqd_distance(pixel_it, cluster_centroid, depth);
				if (min_dist < 0 || temp_dist < min_dist){ /* if it's a nearer point */
					min_dist = temp_dist;
					cluster = clusters_ids[ki]; /* keeps nearest point's cluster index */
				}
			}
			addValueToCluster(cl, cluster, pixel_it);
			ret[IMGPOS(i, j, 0, width, height)] = cluster; /* nearer centroid id */
		}
	}
	free(clusters_ids);
	free(pixel_it);
}

/*
	Function: discard_clusters
	Discard clusters with less than min_elems

	Parameters:
		cl - Clusters information
		min_elems - Minimum elements by clusters

	Returns:
		The updated clusters
*/
clusters discard_clusters(clusters cl, int min_elems){
	int i = 0, l = 0;
	int *clusters_ids = getValidIds(cl);
	int count = getClusterCount(cl);

	for(i = 0; i < count; i++){
		l = getClusterLength(cl, clusters_ids[i]);
		if (l < min_elems){
			/* discard cluster with id clusters_ids[i] */
			cl = delCluster(cl, clusters_ids[i]);
		}
	}
	free(clusters_ids);
	return cl;
}

/*
	Function: merge
	Merge clusters too near, up to max_merge iterations

	Parameters:
		image - The image data
		width - Width of the image
		height - Heigth of the image
		depth - Color depth of the image
		cl - Clusters information
		min_dist - Minimum distance between centroids
		max_merge - Maximum number of merges
		ret - The result image

	Returns:
		Updated clusters information
*/
clusters merge(int *image, int width, int height, int depth, clusters cl, float min_dist, int max_merge, int *ret){
	int *clusters_ids;
	int merges = 0, mergeable = 1, count = 0;
	int l = 0, m = 0, i = 0, j = 0, d = 0;
	int *pixel_value = malloc(depth * sizeof(int));
	while (merges < max_merge && mergeable){
		mergeable = 0;
		clusters_ids = getValidIds(cl);
		count = getClusterCount(cl);
		for(l = 0; l < (count - 1) && !mergeable; l++){
			for(m = (l + 1); m < count && !mergeable; m++){
				if (int_distance(getClusterValue(cl, clusters_ids[l]), getClusterValue(cl, clusters_ids[m]), depth) < min_dist){
					for(i = 0; i < width; i++){
						for(j = 0; j < height; j++){
							int img_pos = IMGPOS(i, j, 0, width, height);
							if (ret[img_pos] == clusters_ids[l]){
								ret[img_pos] = clusters_ids[m];
								for (d = 0; d < depth; d++){
									pixel_value[d] = image[IMGPOS(i, j, d, width, height)];
								}
								addValueToCluster(cl, clusters_ids[m], pixel_value);
							}
						}
					}
					cl = delCluster (cl, clusters_ids[l]);
					mergeable = 1;
					merges++;
				}
			}
		}
		free(clusters_ids);
	}
	free(pixel_value);
	return cl;
}

/*
	Function: split
	Split cluster with standard deviation greater than split_sd

	Parameters:
		image - The image data
		width - Width of the image
		height - Heigth of the image
		depth - Color depth of the image
		cl - Clusters information
		min_dist - Minimum distance between centroids
		split_sd - Maximum standard deviation allowed in a cluster
		ret - The result image

	Returns:
		Updated clusters information
*/
clusters split(int *image, int width, int height, int depth, clusters cl, float min_dist, float split_sd, int *ret){
	int *clusters_ids = getValidIds(cl);
	int *pixel_value = calloc(depth, sizeof(int));
	int count = getClusterCount(cl);
	int tried_split = 0;
	int l = 0, i = 0, j = 0, d = 0;
	while(l < count && !tried_split){
		int cluster = clusters_ids[l];
		float *sd_cluster = getClusterSD(cl, cluster);
		for (d = 0; d < depth; d++){
			if (sd_cluster[d] > split_sd){
				/* SPLIT */
				float *cluster_mean = getClusterMean(cl, cluster);
				int cluster_id1 = getNextId(cl), cluster_id2;
				float *id1_centroid, *id2_centroid;
				cl = addCluster(cl, cluster_id1, pixel_value);
				cluster_id2 = getNextId(cl);
				cl = addCluster(cl, cluster_id2, pixel_value);
				for (i = 0; i < width; i++){
					for (j = 0; j < height; j++){
						int pos = IMGPOS(i, j, 0, width, height);
						if (ret[pos] == cluster){
							for (l = 0; l < depth; l++){
								pixel_value[l] = image[IMGPOS(i, j, l, width, height)];
							}
							pos = IMGPOS(i, j, d, width, height);
							if (image[pos] >= cluster_mean[d]){
								addValueToCluster(cl, cluster_id1, pixel_value);
								ret[pos] = cluster_id1;
							}else{
								addValueToCluster(cl, cluster_id2, pixel_value);
								ret[pos] = cluster_id2;
							}
						}
					}
				}
				/* getCentroids */
				id1_centroid = getClusterMean(cl, cluster_id1);
				id2_centroid = getClusterMean(cl, cluster_id2);
				/* if distance(centroids) < 1.1*min_dist => undo split */
				if (float_distance(id1_centroid, id2_centroid, depth) < 1.1 * min_dist){
					cl = delCluster(cl, cluster_id1);
					cl = delCluster(cl, cluster_id2);
					/* restore ret[] = cluster */
					for (i = 0; i < width; i++){
						for (j = 0; j < height; j++){
							int pos = IMGPOS(i, j, 0, width, height);
							if (ret[pos] == cluster_id1 || ret[pos] == cluster_id2){
								ret[pos] = cluster;
							}
						}
					}
				}else{
					/* del cluster */
					cl = delCluster(cl, cluster);
				}
				tried_split = 1;
				break;
			}
		}
	}
	free(clusters_ids);
	free(pixel_value);
	return cl;
}

/*
	Function: isodata
	Isodata clustering algorithm

	Parameters:
		image - The image data
		width - Width of the image
		height - Heigth of the image
		depth - Color depth of the image
		k - Number of clusters in the classification
		min_dist - Minimum distance between centroids
		min_elems - Minimum elements by cluster
		split_sd - Maximum standard deviation allowed in a cluster
		iter_start - Maximum number of forgy iterations by isodata iteration
		max_merge - Maximum number of merges by iteration
		max_iter - Maximum number of iterations of the algorithm
		ret - The result image

	Returns:
		The clustered image
*/
void isodata(int *image, int *width, int *height, int *depth, int *k, float *min_dist, int *min_elems,
             float *split_sd, int *iter_start, int *max_merge, int *max_iter, int *ret){
	int i = 0, j = 0, d = 0, count = 0; /* iterators indexes */
	int l = 0;
	int changed = 1; /* has centroids changed during last execution? */
	int iter_no = 0;
	clusters cl;
	int *pixel_value = malloc(*depth * sizeof(int));

	/* create clusters holder */
	cl = clusters_create (*k, *depth);
	
	/* clusters init */
	for (l = 0; l < *k; l++){
		int *pixel = rand_pixel(*width, *height); /* get random pixel coords from image */
		for (d = 0; d < *depth; d++)
			pixel_value[i] = image[IMGPOS(pixel[0], pixel[1], d, *width, *height)];
		cl = addCluster(cl, l, pixel_value);
		free(pixel);
	}

	while (iter_no < *max_iter && changed){

		/* do at most iter_start forgy iterations */
		i = 0;
		while (i < *iter_start && changed){
			if (i > 0)
				cl = restartClusters(cl);
			forgy_it(image, *width, *height, *depth, *k, cl, ret);
			changed = changedClusters(cl);
			i++;
		}

		/* discard cluster with less than min_elems pixels */
		cl = discard_clusters(cl, *min_elems);
		changed = changedClusters(cl);

		/* merge? */
		count = getClusterCount(cl);
		if (count >= (2 * *k)){
			cl = merge(image, *width, *height, *depth, cl, *min_dist, *max_merge, ret);
			changed = changedClusters(cl);
		}

		/* split? */
		count = getClusterCount(cl);
		if (count <= (*k / 2) || (iter_no % 2 == 1 && count < 2 * *k)){
			cl = split(image, *width, *height, *depth, cl, *min_dist, *split_sd, ret);
			changed = changedClusters(cl);
		}

		iter_no++;
	}

	/* update return image pixel values */
	for (i = 0; i < *width; i++){
		for (j = 0; j < *height; j++){
			int cluster_id = ret[IMGPOS(i, j, 0, *width, *height)];
			int *cluster_value = getClusterValue(cl, cluster_id);
			for (d = 0; d < *depth; d++){
				ret[IMGPOS(i, j, d, *width, *height)] = cluster_value[d];
			}
		}
	}
	
	/* free used memory */
	free(pixel_value);
	cl = clusters_free(cl);
}

