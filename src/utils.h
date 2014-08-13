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

float mean_it(float m, int t, int v);
float sd_it(float sd, int t, int v, float m, float mnext);
int *rand_pixel(int width, int height);
int **clusters_init(int *image, int width, int height, int depth, int k);
int **clusters_destroy(int **clusters, int k);
int sqd_distance(int *p1, int *p2, int k);
int int_distance(int *p1, int *p2, int k);
float float_distance(float *p1, float *p2, int k);
