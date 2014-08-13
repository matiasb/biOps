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
	Title: Isodata cluster data structure
*/

#include <stdlib.h>
#include "utils.h"
#include "isodata_cluster.h"

struct st_cluster{
	int **clusters; /* cluster values */
	float **sd; /* standard deviation of clusters (by channel) */
	float **means; /* means of clusters (by channel) */
	int *elems; /* number of elements by cluster */
	int depth; /* dimension of the cluster values */
	int used; /* number of cluster slots used */
	int len; /* total number of cluster slots */
};

/*
	Function: clusters_create
	Create and initialize the clusters structure

	Parameters:
		k - Number of desired clusters (total slots defined from this)
		depth - Dimension of the values in a cluster
	
	Returns:
		The new clusters structure
*/
clusters clusters_create(int k, int depth){
	clusters ret = malloc(sizeof(struct st_cluster));
	ret->used = 0;
	ret->len = 2*k + 2;
	ret->depth = depth;
	ret->clusters = calloc(ret->len, sizeof(int *));
	ret->sd = calloc(ret->len, sizeof(float *));
	ret->means = calloc(ret->len, sizeof(float *));
	ret->elems = calloc(ret->len, sizeof(int));

	return ret;
}

/*
	Function: getNextId
	Return a free slot id

	Parameters:
		cl - Clusters structure

	Returns:
		The id of the next free slot
*/
int getNextId(clusters cl){
	int ret = 0;
	for (ret = 0; ret < cl->len; ret++){
		if (cl->clusters[ret] == NULL)
			break;
	}
	return ret;
}

/*
	Function: addCluster
	Add a cluster for value with the given id; initialize the slot

	Parameters:
		cl - Clusters structure
		id - Id of the new slot (given by getNextId)
		value - The centroid value of the cluster
	
	Returns:
		The updated clusters structure
*/
clusters addCluster(clusters cl, int id, int *value){
	int i = 0;
	cl->clusters[id] = calloc(cl->depth, sizeof(int));
	cl->sd[id] = calloc(cl->depth, sizeof(float));
	cl->means[id] = calloc(cl->depth, sizeof(float));
	cl->elems[id] = 0;

	for (i = 0; i < cl->depth; i++)
		cl->clusters[id][i] = value[i];

	cl->used++;
	return cl;
}

/*
	Function: getClusterValue
	Return the centroid value of cluster with the given id

	Parameters:
		cl - Clusters structure
		id - Cluster id

	Returns:
		The centroid value
*/
int *getClusterValue(clusters cl, int id){
	int *ret = cl->clusters[id];
	return ret;
}

/*
	Function: delCluster
	Free a cluster slot

	Parameters:
		cl - Clusters structure
		id - Cluster id

	Returns:
		The updated clusters structure
*/
clusters delCluster(clusters cl, int id){
	if (cl->clusters[id] != NULL){
		free(cl->clusters[id]);
		free(cl->sd[id]);
		free(cl->means[id]);
		cl->clusters[id] = NULL;
		cl->sd[id] = NULL;
		cl->means[id] = NULL;
		cl->elems[id] = 0;
		cl->used--;
	}
	return cl;
}

/*
	Function: addValueToCluster
	Add a value to the cluster with the given id; cluster info is updated

	Parameters:
		cl - Clusters structure
		id - Cluster id
		value - The value to add
	
	Returns:
		The updated clusters structure
*/
int addValueToCluster(clusters cl, int id, int *value){
	int i = 0;
	if (cl->clusters[id] != NULL){
		for (i = 0; i < cl->depth; i++){
			float old_mean = cl->means[id][i];
			cl->means[id][i] = mean_it(old_mean, cl->elems[id], value[i]);
			cl->sd[id][i] = sd_it(cl->sd[id][i], cl->elems[id], value[i], old_mean, cl->means[id][i]);
		}
		cl->elems[id]++;
	}
	return 1;
}

/*
	Function: restartClusters
	Update the centroids from the mean values and restart clusters info

	Parameters:
		cl - Clusters structure
	
	Returns:
		The updated clusters structure
*/
clusters restartClusters(clusters cl){
	int i = 0, j = 0, count = 0;
	for (i = 0; i < cl->len; i++){
		if (cl->clusters[i] != NULL){
			for (j = 0; j < cl->depth; j++){
				cl->clusters[i][j] = (int) cl->means[i][j];
				cl->sd[i][j] = 0;
				cl->means[i][j] = 0;
			}
			cl->elems[i] = 0;
			count++;
		}
		if (count == cl->used)
			break;
	}
	return cl;
}

/*
	Function: changedClusters
	Return true if the centroid values and current means differ

	Parameters:
		cl - Clusters structure
	
	Returns:
		True if values differ
*/
int changedClusters(clusters cl){
	int i = 0, j = 0, count = 0, ret = 0;
	for (i = 0; i < cl->len; i++){
		if (cl->clusters[i] != NULL){
			for (j = 0; j < cl->depth; j++){
				if (cl->clusters[i][j] != (int) cl->means[i][j])
					ret = 1;
			}
			count++;
		}
		if (count == cl->used)
			break;
	}
	return ret;
}

/*
	Function: getClusterMean
	Return the current mean value of the cluster with the given id

	Parameters:
		cl - Clusters structure
		id - Cluster id
	
	Returns:
		Mean of the cluster
*/
float *getClusterMean(clusters cl, int id){
	float *ret = cl->means[id];
	return ret;
}

/*
	Function: getClusterSD
	Return the current standard deviation value of the cluster with the given id

	Parameters:
		cl - Clusters structure
		id - Cluster id
	
	Returns:
		Standard deviation of the cluster
*/
float *getClusterSD(clusters cl, int id){
	float *ret = cl->sd[id];
	return ret;
}

/*
	Function: getClusterLength
	Return the number of associated elements of the cluster with the given id

	Parameters:
		cl - Clusters structure
		id - Cluster id
	
	Returns:
		Number of elements of the cluster
*/
int getClusterLength(clusters cl, int id){
	int ret = cl->elems[id];
	return ret;
}

/*
	Function: getClusterCount
	Return the number of used slots

	Parameters:
		cl - Clusters structure

	Returns:
		Used slots
*/
int getClusterCount(clusters cl){
	int ret = cl->used;
	return ret;
}

/*
	Function: getValidIds
	Return the ids of the used slots

	Parameters:
		cl - Clusters structure

	Returns:
		Array of used slot ids
*/
int *getValidIds(clusters cl){
	int i = 0, count = 0;
	int *ret = malloc(cl->used * sizeof(int));
	for (i = 0; i < cl->len; i++){
		if (cl->clusters[i] != NULL){
			ret[count] = i;
			count++;
		}
		if (count == cl->used)
			break;
	}
	return ret;
}

/*
	Function: clusters_free
	Destroy and free the clusters structure

	Parameters:
		cl - Clusters structure

	Returns:
		NULL
*/
clusters clusters_free(clusters cl){
	int i = 0;
	for (i = 0; i < cl->len; i++){
		if (cl->clusters[i] != NULL){
			free(cl->clusters[i]);
			free(cl->sd[i]);
			free(cl->means[i]);
		}
	}
	free(cl->clusters);
	free(cl->sd);
	free(cl->means);
	free(cl->elems);
	free(cl);

	cl = NULL;
	return cl;
}
