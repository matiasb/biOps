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


/***************************************************
 *
 *  Tiff Read Write Functions
 *
 ***************************************************/

#include <stdlib.h>
#include <stdio.h>
#include "config.h"

/*
	Title: Tiff Read/Write Functions (C code)
*/

#ifdef HAVE_TIFF_H
#include <tiffio.h>
/*
	Function: read_tiff_img_info
	Read the image info: width, height and depth.

	Parameters:
		filename - The file path of the image.

	Returns:
		width - The width of the image.
		height - Its height.
		depth - Its color depth.
		ret - -1 if there is an error, 1 if success.
*/
void read_tiff_img_info(char **filename, int *width, int *height, int *depth, int *ret){
	char *fname = *filename;
	TIFF *image;
	
	if ((image = TIFFOpen(fname, "r")) == NULL) {
		*ret = -1;    /* couldn't open file */
		return;
	}

	TIFFGetField(image, TIFFTAG_IMAGEWIDTH, width);
	TIFFGetField(image, TIFFTAG_IMAGELENGTH, height);
	*depth = 3;

	TIFFClose(image);
	*ret = 1;
}

/*
	Image data format:
	[[R] [G] [B]] where [X] = [[col_1] ... [col_width]] where [col_i] = [row_1 ... row_height]
*/

/*
	Function: read_tiff_img
	Read the image data.

	Parameters:
		filename - The file path of the image.

	Returns:
		image - The image data.
		ret - -1 if there is an error, 1 if success.
*/
void read_tiff_img (char **filename, int *image, int *ret){
	char *fname = *filename;
	TIFF *tiff_image;
	uint32 width, height, *raster;
	unsigned long imagesize, i, j, line, plane_size;

	if ((tiff_image = TIFFOpen(fname, "r")) == NULL) {
		*ret = -1;    /* couldn't open file */
		return;
	}

	/* Find the width and height of the image */
	TIFFGetField(tiff_image, TIFFTAG_IMAGEWIDTH, &width);
	TIFFGetField(tiff_image, TIFFTAG_IMAGELENGTH, &height);
	imagesize = height * width + 1;

	if ((raster = (uint32 *) malloc(sizeof(uint32) * imagesize)) == NULL){
		fprintf(stderr, "Could not allocate enough memory\n");
		*ret = -1;
		return;
	}

	/* Read the image into the memory buffer */
	if (TIFFReadRGBAImage(tiff_image, width, height, raster, 0) == 0){
		fprintf(stderr, "Could not read image\n");
		*ret = -1;
		return;
	}

	line = 0;
	plane_size = width * height;
	for (i = height - 1; i != -1; i--){
		for (j = 0; j < width; j++){
			image[line + height * j] = (unsigned char) TIFFGetR(raster[i * width + j]);
			image[line + height * j + plane_size] = (unsigned char) TIFFGetG(raster[i * width + j]);
			image[line + height * j + plane_size * 2] = (unsigned char) TIFFGetB(raster[i * width + j]);
		}
		line++;
	}

	free(raster);
	TIFFClose(tiff_image);
	*ret = 1;
	return;
}

/*
	Function: write_tiff_img
	Write the image data.

	Parameters:
		filename - The file path of the image to be written.
		image - The image data.
		width - The width of the image.
		height - Its height.
		depth - Its color depth.

	Returns:
		ret - -1 if there is an error, 1 if success.
*/
void write_tiff_img (char **filename, int *image, int *width, int *height, int *depth, int *ret){
	char *fname = *filename;
	TIFF *output;
	unsigned char *raster;
	int plane_size, w = *width, h = *height, d = *depth;
	int i, j, c, pos;

	/* Open the output image */
	if ((output = TIFFOpen(fname, "w")) == NULL){
		fprintf(stderr, "Could not open outgoing image\n");
		*ret = -1;   /* couldn't open file */
		return;
	}

	if ((raster = (unsigned char *) malloc(sizeof(char) * w * h * d)) == NULL){
		fprintf(stderr, "Could not allocate enough memory\n");
		*ret = -1;   /* couldn't open file */
		return;
	}

	pos = 0;
	plane_size = w * h;
	for (i = 0; i < h; i++){
		for (j = 0; j < w; j++){
			for (c = 0; c < d; c++){
				raster[pos] = image[i + j * h + c * plane_size];
				pos++;
			}
		}
	}

	/* Write the tiff tags to the file */
	TIFFSetField(output, TIFFTAG_IMAGEWIDTH, w);
	TIFFSetField(output, TIFFTAG_IMAGELENGTH, h);
	TIFFSetField(output, TIFFTAG_COMPRESSION, COMPRESSION_DEFLATE);
	TIFFSetField(output, TIFFTAG_PLANARCONFIG, PLANARCONFIG_CONTIG);
	TIFFSetField(output, TIFFTAG_PHOTOMETRIC, (d==1) ? PHOTOMETRIC_MINISBLACK : PHOTOMETRIC_RGB);
	TIFFSetField(output, TIFFTAG_BITSPERSAMPLE, 8);
	TIFFSetField(output, TIFFTAG_SAMPLESPERPIXEL, d);

	/* Actually write the image */
	if (TIFFWriteEncodedStrip(output, 0, raster, w * h * d) == 0){
		fprintf(stderr, "Could not write image\n");
		*ret = -1;
		return;
	}

	TIFFClose(output);

	*ret = 1;
	return;
}

#endif
