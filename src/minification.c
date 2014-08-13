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
	Title: Minification Operations (C code)
*/

#include <stdlib.h>
#include "defs.h"

#define ELEM_SWAP(a,b) { register int t=(a);(a)=(b);(b)=t; }

int quick_select(int *arr, int n){
	int low = 0, high = n - 1;
	int median = (low + high) / 2;
	int middle, ll, hh;

	while (1){
		if (high <= low)
			return arr[median]; /* One element only */
		if (high == low + 1){
			if (arr[low] > arr[high])
				ELEM_SWAP(arr[low], arr[high]);
			return arr[median];
		}

		/* Find median of low, middle and high items; swap into position low */
		middle = (low + high) / 2;
		if (arr[middle] > arr[high])
			ELEM_SWAP(arr[middle], arr[high]) ;
		if (arr[low] > arr[high])
			ELEM_SWAP(arr[low], arr[high]) ;
		if (arr[middle] > arr[low])
			ELEM_SWAP(arr[middle], arr[low]) ;

		/* Swap low item (now in position middle) into position (low+1) */
		ELEM_SWAP(arr[middle], arr[low+1]) ;

		/* Nibble from each end towards middle, swapping items when stuck */
		ll = low + 1;
		hh = high;
		while (1){
			do ll++;
			while (arr[low] > arr[ll]);
			do hh--;
			while (arr[hh]  > arr[low]);

			if (hh < ll)
				break;

			ELEM_SWAP(arr[ll], arr[hh]) ;
		}

		/* Swap middle item (in position low) back into correct position */
		ELEM_SWAP(arr[low], arr[hh]) ;

		/* Re-set active partition */
		if (hh <= median)
			low = ll;
		if (hh >= median)
			high = hh - 1;
	}
}


double window_average(int arr[], int n){
	int i;
	double ret = 0;

	for(i = 0; i < n; i++){
		ret = ret + arr[i];
	}

	return (ret/n);
}


/*
	Function: medianShrink
	Performs a shrink operation using median representation

	Parameters:
		image - The input image
		width - The image width
		height - Its height
		depth - Its color depth
		ret - The result reduced image
		new_width - The width of the reduced image
		new_height - The height

	Returns:
		The reduced image
*/
void medianShrink(int *image, int *width, int *height, int *depth, int *ret, int *new_width, int *new_height){
	int new_rows = *new_height, new_cols = *new_width;
	int x_side = *width / new_cols, y_side = (*height / new_rows), wsize = x_side * y_side;
	int *window = calloc(wsize, sizeof(double));
	int x, y, d, winx, winy;
	double value;

	for (y = 0; y < new_rows; y++){
		for (x = 0; x < new_cols; x++){
			for (d = 0; d < *depth; d++){
				int windex = 0;
				for (winy = 0; winy < y_side; winy++){
					for (winx = 0; winx < x_side; winx++){
						window[windex] = image[IMGPOS(x * x_side + winx, y * y_side + winy, d, *width, *height)];
						windex++;
					}
				}
				value = quick_select(window, windex);
				ret[IMGPOS(x, y, d, new_cols, new_rows)] = (int) value;
			}
		}
	}

	free(window);
}

/*
	Function: averageShrink
	Performs a shrink operation using average representation

	Parameters:
		image - The input image
		width - The image width
		height - Its height
		depth - Its color depth
		ret - The result reduced image
		new_width - The width of the reduced image
		new_height - The height

	Returns:
		The reduced image
*/
void averageShrink(int *image, int *width, int *height, int *depth, int *ret, int *new_width, int *new_height){
	int new_rows = *new_height, new_cols = *new_width;
	int x_side = *width / new_cols, y_side = (*height / new_rows), wsize = x_side * y_side;
	int *window = calloc(wsize, sizeof(double));
	int x, y, d, winx, winy;
	double value;

	for (y = 0; y < new_rows; y++){
		for (x = 0; x < new_cols; x++){
			for (d = 0; d < *depth; d++){
				int windex = 0;
				for (winy = 0; winy < y_side; winy++){
					for (winx = 0; winx < x_side; winx++){
						window[windex] = image[IMGPOS(x * x_side + winx, y * y_side + winy, d, *width, *height)];
						windex++;
					}
				}
				value = window_average(window, windex);
				ret[IMGPOS(x, y, d, new_cols, new_rows)] = (int) value;
			}
		}
	}

	free(window);
}
