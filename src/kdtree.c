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
	Title: kd-trees data structure implementation
*/


#include <stdlib.h>
#include "utils.h"
#include "kdtree.h"

#define MIN(a, b) (a) >= (b) || (a) < 0 ? (b) : (a)

struct st_kdtree{
	int k; /* dim of the tree */
	kdnode root; /* root node */
	int *hr_min;
	int *hr_max;
};

struct st_kdnode{
	int id; /* unique identifier for the node (hack for kmeans) */
	int *value; /* node value (k values) */
	int split; /* split index */
	kdnode left; /* left subtree */
	kdnode right; /* right subtree */
};


/*
	Function: pivot
	Given hyperrectangle limits return the index of widest dimension

	Parameters:
		k - The dimension of the hyperrectangle
		min - Min limits on each dimension
		max - Max limits on each dimension

	Returns:
		The index of the widest dimension
*/
int pivot(int k, int *min, int *max){
	int i = 0, max_dist = max[i] - min[i], ret = 0;
	for (i = 1; i < k; i++){
		int dist = max[i] - min[i];
		if (dist > max_dist){
			max_dist = dist;
			ret = i;
		}
	}
	return ret;
}

/*
	Function: new_kdnode
	Create and return an initialized kdnode

	Parameters:
		id - Id for the node
		value - Node value
		split - The split coord
		left - Left child
		right - Right child

	Returns:
		The created kdnode
*/
kdnode new_kdnode(int id, int *value, int split, kdnode left, kdnode right){
	kdnode n = calloc(1, sizeof(struct st_kdnode));
	n->id = id;
	n->value = value;
	n->split = split;
	n->left = left;
	n->right = right;

	return n;
}

/*
	Function: kdtree_create
	Create and return an empty kdtree of dim k on the hyperrectangle given by min/max points
	Hyperrectangle limits are not copied; when destroying the kdtree remember to free the associated memory

	Parameters:
		k - Dimension of the tree
		hr_min - Min limits of the initial hyperrectangle
		hr_max - Max limits of the initial hyperrectangle

	Returns:
		The created empty kdtree
*/
kdtree kdtree_create(int k, int *hr_min, int *hr_max){
	kdtree ret = calloc(1, sizeof(struct st_kdtree));
	ret->k = k;
	ret->hr_min = hr_min;
	ret->hr_max = hr_max;
	return ret;
}


/*
	Function: kdtree_create
	Add value as a new node to the given kdtree and return the updated tree
	The given value is pointed in the node structure (ie it is not copied,
	be careful when freeing its memory); you should keep a pointer to value
	and free it after destroying the tree. Note that keeping pointers to
	the values in the tree could be useful to identify the value by the id
	given when you add the value to the tree (see kmeans_kdtree).

	Parameters:
		t - Kdtree
		id - Id of the node to add
		value - Value of the node
		hr_min - Min limits hyperrectangle (initial)
		hr_max - Max limits hyperrectangle (initial)

	Returns:
		The updated kdtree
*/
kdtree kdtree_add(kdtree t, int id, int *value, int *hr_min, int *hr_max){
	if (t->root == NULL){
		/* Add the root node to the empty kdtree */
		int split = pivot(t->k, hr_min, hr_max); /* split dimension */
		t->root = new_kdnode(id, value, split, NULL, NULL); /* add the node */
	}else{
		/* The kdtree is not empty */
		kdnode next = t->root, parent = t->root;
		kdnode *new_node = &(t->root); /* pointer to the branch where the new node should be added */
		int split = 0;

		while (next != NULL){
			/* find the position to update the tree */
			int s = next->split;
			parent = next;
			if (value[s] <= next->value[s]){
				/* left */
				new_node = &next->left;
				next = next->left;
				hr_max[parent->split] = parent->value[parent->split]; /* updates the hyperrectangle dims */
			}else{
				/* right */
				new_node = &next->right;
				next = next->right;
				hr_min[parent->split] = parent->value[parent->split]; /* updates the hyperrectangle dims */
			}
		}

		split = pivot(t->k, hr_min, hr_max); /* split dimension for future children */

		*new_node = new_kdnode(id, value, split, NULL, NULL); /* add the node */
	}
	return t;
}

/*
	Function: kdnode_destroy
	Remove and free a kdnode

	Parameters:
		n - Node to destroy

	Returns:
		NULL
*/
kdnode kdnode_destroy(kdnode n){
/* 	free(n->value); */
	if (n->left)
		n->left = kdnode_destroy(n->left);
	if (n->right)
		n->right = kdnode_destroy(n->right);
	free(n);
	n = NULL;
	return n;
}

/*
	Function: intersect
	Decides if the hyperrectangle defined by hr_min and hr_max intersects
	an hypersphere of radius sqrt(sqd_r) and origin t

	Parameters:
		hr_min - Min limits hyperrectangle
		hr_max - Max limits hyperrectangle
		sqd_r - Radius of the hypersphere
		t - Value of the origin point (hypersphere)
		k - Dimension

	Returns:
		Not zero if true
*/
int intersect(int *hr_min, int *hr_max, int sqd_r, int *t, int k){
	int *p = calloc(k, sizeof(int)), i = 0;
	int ret = 0;

	for (i = 0; i < k; i++){
		if (t[i] <= hr_min[i])
			p[i] = hr_min[i];
		else if (t[i] >= hr_max[i])
			p[i] = hr_max[i];
		else
			p[i] = t[i];
	}
	ret = sqd_distance(p, t, k) <= sqd_r;
	return ret;
}

/*
	Function: kdtree_destroy
	Free the memory used by the structures

	Parameters:
		t - Tree to destroy
	
	Returns:
		NULL
*/
kdtree kdtree_destroy(kdtree t){
	t->root = kdnode_destroy(t->root);
	free(t);
	t = NULL;
	return t;
}

/*
	Function: nearestneighbor_aux
	Auxiliar function for nearest neighbor search.
	It does the specific search.

	Parameters:
		n - Tree to destroy
		target - Point that searches for its nearest neighbor
		max_dist - Maximum distance to look for
		dist - Current distance
		k - Dimension
		hr_min - Min limits hyperrectangle looking in
		hr_max - Max limits hyperrectangle looking in
	
	Returns:
		NULL
*/
kdnode nearestneighbor_aux(kdnode n, int *target, int *max_dist, int *dist, int k, int *hr_min, int *hr_max){
	kdnode near, far;
	kdnode ret = NULL;
	int s = n->split, further = 0;
	int *pivot = n->value;
	int temp_dist = sqd_distance(target, pivot, k);

	if (target[s] <= pivot[s]){
		near = n->left;
		far = n->right;
		hr_max[n->split] = n->value[n->split];
	}else{
		near = n->right;
		far = n->left;
		hr_min[n->split] = n->value[n->split];
	}

	if (near == NULL){
		ret = n;
		*dist = temp_dist;
	}else{
		ret = nearestneighbor_aux(near, target, max_dist, dist, k, hr_min, hr_max);
	}

	*max_dist = MIN(*max_dist, *dist);

	if (far != NULL){
		kdnode temp_value;
		if (far == n->left){
			hr_max[n->split] = n->value[n->split];
		}else{
			hr_min[n->split] = n->value[n->split];
		}
		further = intersect(hr_min, hr_max, *max_dist, target, k);

		if (further){
			int temp_dist;
			temp_value = nearestneighbor_aux(far, target, max_dist, &temp_dist, k, hr_min, hr_max);
			if (*dist < 0 || temp_dist < *dist){
				ret = temp_value;
				*dist = temp_dist;
			}
		}
	}

	if (*dist < 0 || temp_dist < *dist){
		ret = n;
		*dist = temp_dist;
		*max_dist = *dist;
	}

	return ret;
}

/*
	Function: kdtree_nearestneighbor
	Return the nearest neighbor node value in t for the given value

	Parameters:
		t - Tree
		value - Point that searches for its nearest neighbor
	
	Returns:
		The value of the node that corresponds to the nearest neighbor
*/
int *kdtree_nearestneighbor(kdtree t, int *value){
	int *ret = NULL, i = 0;
	kdnode nearest = NULL;
	int max_dist = -1, dist = -1;
	int *hr_min = calloc(t->k, sizeof(int)), *hr_max = calloc(t->k, sizeof(int));

	for (i = 0; i < t->k; i++){
		hr_min[i] = t->hr_min[i];
		hr_max[i] = t->hr_max[i];
	}

	if (t->root != NULL){
		nearest = nearestneighbor_aux(t->root, value, &max_dist, &dist, t->k, hr_min, hr_max);
		ret = nearest->value;
	}

	free(hr_min);
	free(hr_max);

	return ret;
}

/*
	Function: kdtree_nearestneighbor_id
	Return the nearest neighbor node id in t for the given value

	Parameters:
		t - Tree
		value - Point that searches for its nearest neighbor
	
	Returns:
		The id of the node that corresponds to the nearest neighbor
*/
int kdtree_nearestneighbor_id(kdtree t, int *value){
	int ret = -1, i = 0;
	kdnode nearest = NULL;
	int max_dist = -1, dist = -1;
	int *hr_min = calloc(t->k, sizeof(int)), *hr_max = calloc(t->k, sizeof(int));

	for (i = 0; i < t->k; i++){
		hr_min[i] = t->hr_min[i];
		hr_max[i] = t->hr_max[i];
	}

	if (t->root != NULL){
		nearest = nearestneighbor_aux(t->root, value, &max_dist, &dist, t->k, hr_min, hr_max);
		ret = nearest->id;
	}

	free(hr_min);
	free(hr_max);

	return ret;
}
