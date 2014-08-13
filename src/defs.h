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

#define MAX_PIXEL_VALUE 255
#define MAX_PIXEL_VALUE_PLUS_1 256
#define MIN_PIXEL_VALUE 0
#define MIN_PIXEL_VALUE_PLUS_1 1

/* get lineal pos from x,y,c(hannel),w(idth),h(eight) */
#define IMGPOS(x,y,c,w,h)     ((h)*(x) + (y) + (w)*(h)*(c))
#define MSKPOS(x,y,w,h)       IMGPOS(x,y,0,w,h)

/* min and max macros */
#define MIN(a, b) (a) >= (b) ? (b) : (a)
#define MAX(a, b) (a) >= (b) ? (a) : (b)

/* clipping macro */
#define CLIP(x,y,z) ((x) < (y)) ? (y) : (((x) > (z)) ? (z) : (x))

#define PI 3.141593
#define TWO_PI 6.283186

