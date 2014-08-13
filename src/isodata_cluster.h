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

typedef struct st_cluster *clusters;

clusters clusters_create(int k, int depth);
int getNextId(clusters cl);
clusters addCluster(clusters cl, int id, int *value);
int *getClusterValue(clusters cl, int id);
clusters delCluster(clusters cl, int id);
int addValueToCluster(clusters cl, int id, int *value);
float *getClusterMean(clusters cl, int id);
float *getClusterSD(clusters cl, int id);
int getClusterLength(clusters cl, int id);
int getClusterCount(clusters cl);
int *getValidIds(clusters cl);
clusters restartClusters(clusters cl);
int changedClusters(clusters cl);
clusters clusters_free(clusters cl);
