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

#include <math.h>
#include "defs.h"
#include "gaussian.h"

float norm(float x, float y){
	return (float) sqrt((double) (x*x + y*y));
}

float distance(float a, float b, float c, float d){
	return norm((a - c), (b - d));
}

float gauss(float x, float sigma){
	return (float) exp((double) ((-x*x)/(2*sigma*sigma)));
}

float LoG(float x, float sigma){
	float x1 = gauss(x, sigma);
	return (x * x - 2 * sigma * sigma) / (sigma * sigma * sigma * sigma) * x1;
}

float meanGauss(float x, double sigma){
	float z = (gauss(x, sigma) + gauss(x + 0.5, sigma) + gauss(x - 0.5, sigma)) / 3.0;
	z = z / (PI * 2.0 * sigma * sigma);
	return z;
}

/* First derivative of Gaussian */
float dGauss(float x, double sigma){
	return -x / (sigma * sigma) * gauss(x, sigma);
}
