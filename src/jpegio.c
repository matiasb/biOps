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
 *  Jpeg Read Write Functions
 *
 ***************************************************/

#include <stdio.h>
#include "config.h"

/*
	Title: Jpeg Read/Write Functions (C code)
*/

#ifdef HAVE_JPEGLIB_H
#include <jpeglib.h>
/*
	Function: read_jpg_img_info
	Read the image info: width, height and depth.

	Parameters:
		filename - The file path of the image.

	Returns:
		width - The width of the image.
		height - Its height.
		depth - Its color depth.
		ret - -1 if there is an error, 1 if success.
*/
void read_jpg_img_info(char **filename, int *width, int *height, int *depth, int *ret){
	char *fname = *filename;
	struct jpeg_decompress_struct cinfo;
	struct jpeg_error_mgr jerr;
	FILE *infile;
	
	cinfo.err = jpeg_std_error(&jerr);
	jpeg_create_decompress(&cinfo);
	
	if ((infile = fopen(fname, "rb")) == NULL) {
		*ret = -1;    /* couldn't open file */
		return;
	}

	jpeg_stdio_src(&cinfo, infile);
	jpeg_read_header(&cinfo, TRUE);

	*width = cinfo.image_width;
	*height = cinfo.image_height;
	*depth = cinfo.num_components;

	jpeg_destroy_decompress(&cinfo);
	fclose(infile);
	*ret = 1;
}

/*
	Image data format:
	[[R] [G] [B]] where [X] = [[col_1] ... [col_width]] where [col_i] = [row_1 ... row_height]
*/

/*
	Function: read_jpg_img
	Read the image data.

	Parameters:
		filename - The file path of the image.

	Returns:
		image - The image data.
		ret - -1 if there is an error, 1 if success.
*/
void read_jpg_img(char **filename, int *image, int *ret){
	char *fname = *filename;
	struct jpeg_decompress_struct cinfo;
	struct jpeg_error_mgr jerr;
	FILE *infile;		/* source file */
	JSAMPARRAY buffer;	/* Output row buffer */
	int row_stride;		/* physical row width in output buffer */
	int plane_size;
	int i, j;
	int line;
	unsigned char *p;
	
	if ((infile = fopen(fname, "rb")) == NULL) {
		*ret = -1;   /* couldn't open file */
		return;
	}

	cinfo.err = jpeg_std_error(&jerr);
	jpeg_create_decompress(&cinfo);
	jpeg_stdio_src(&cinfo, infile);

	jpeg_read_header(&cinfo, TRUE);
	jpeg_start_decompress(&cinfo);
	row_stride = cinfo.output_width * cinfo.output_components;
	plane_size = cinfo.output_width * cinfo.output_height;
	buffer = (*cinfo.mem->alloc_sarray) ((j_common_ptr) &cinfo, JPOOL_IMAGE, row_stride, 1);
	
	while (cinfo.output_scanline < cinfo.output_height) {
		line = cinfo.output_scanline;  /* preserve current scanline */
		jpeg_read_scanlines(&cinfo, buffer, 1);
		p = buffer[0];
		for (i = 0; i < cinfo.output_width; i++) {
			for (j = 0; j < cinfo.output_components; j++) {
				image[line + cinfo.output_height * i + j * plane_size] = (unsigned char) *p++;
			}
		}
	}

	jpeg_finish_decompress(&cinfo);
	jpeg_destroy_decompress(&cinfo);
	fclose(infile);
	*ret = 1;
	return;
}

/*
	Function: write_jpg_img
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
void write_jpg_img(char **filename, int *image, int *width, int *height, int *depth, int *ret){
	char *fname = *filename;
	struct jpeg_compress_struct cinfo;
	struct jpeg_error_mgr jerr;
	FILE *outfile;		/* source file */
	int row_stride;		/* physical row width in output buffer */
	JSAMPARRAY buffer;	/* Output row buffer */
	int plane_size;
	int i, j;

	if ((outfile = fopen(fname, "wb")) == NULL) {
		*ret = -1;   /* couldn't open file */
		return;
	}

	cinfo.err = jpeg_std_error(&jerr);
	jpeg_create_compress(&cinfo);
	jpeg_stdio_dest(&cinfo, outfile);

	cinfo.image_width = *width;
	cinfo.image_height = *height;
	cinfo.input_components = *depth;
	cinfo.in_color_space = (*depth == 3) ? JCS_RGB : JCS_GRAYSCALE;

	jpeg_set_defaults(&cinfo);

	jpeg_start_compress(&cinfo, TRUE);
	row_stride = cinfo.image_width * cinfo.input_components;
	plane_size = cinfo.image_width * cinfo.image_height;

	buffer = (*cinfo.mem->alloc_sarray) ((j_common_ptr) &cinfo, JPOOL_IMAGE, row_stride, 1);

	while (cinfo.next_scanline < cinfo.image_height) {
		int line = cinfo.next_scanline;  /* preserve current scanline */
		for (i = 0; i < cinfo.image_width; i++) {
			for (j = 0; j < cinfo.input_components; j++) {
				buffer[0][i * cinfo.input_components + j] = (unsigned char) image[line + i * cinfo.image_height + j * plane_size];
			}
		}
		jpeg_write_scanlines(&cinfo, buffer, 1);
	}

	jpeg_finish_compress(&cinfo);
	jpeg_destroy_compress(&cinfo);
	fclose(outfile);
	*ret = 1;
	return;
}

#endif
