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

typedef struct st_kdtree *kdtree;
typedef struct st_kdnode *kdnode;

kdtree kdtree_create(int k, int *hr_min, int *hr_max);
kdtree kdtree_add(kdtree t, int id, int *value, int *hr_min, int *hr_max);
int *kdtree_nearestneighbor(kdtree t, int *value);
int kdtree_nearestneighbor_id(kdtree t, int *value);
kdtree kdtree_destroy(kdtree t);

