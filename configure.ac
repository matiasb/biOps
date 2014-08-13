AC_PREREQ(2.50)
AC_INIT([biOps], [0.2], [mbordese@gmail.com])
AC_CONFIG_HEADER([src/config.h])
AC_CONFIG_SRCDIR([src/jpegio.c])

: ${R_HOME=`R RHOME`}
if test -z "${R_HOME}"; then
 echo "could not determine R_HOME"
 exit 1
fi
CC=`"${R_HOME}/bin/R" CMD config CC`

# Checks for programs.
AC_PROG_CC


# Checks for libraries.
AC_CHECK_LIB([tiff], [TIFFOpen],
            [have_tiff=-ltiff], [have_tiff=])
AC_CHECK_LIB([jpeg], [jpeg_destroy_compress],
            [have_jpeg=-ljpeg], [have_jpeg=])
AC_CHECK_LIB([fftw3], [fftw_plan_dft],
            [have_fftw=-lfftw3], [have_fftw=])


# Checks for header files.
AC_HEADER_STDC

AC_CHECK_HEADERS([fftw3.h], [HAVE_FFTW_H=TRUE],
                 [HAVE_FFTW_H=FALSE; AC_MSG_WARN([Can't find fftw3 header])])

AC_CHECK_HEADERS([jpeglib.h], [HAVE_JPEG_H=TRUE],
                 [HAVE_JPEG_H=FALSE; AC_MSG_WARN([Can't find libjpeg header])])

AC_CHECK_HEADERS([tiff.h], [HAVE_TIFF_H=TRUE],
                 [HAVE_TIFF_H=FALSE; AC_MSG_WARN([Can't find libtiff header])])

if test "${have_tiff}${have_jpeg}" = ""; then
 echo "Error: libjpeg or libtiff required"
 exit 1
fi

PKG_LIBS="-lm ${have_tiff} ${have_jpeg} ${have_fftw}"

AC_SUBST(PKG_LIBS)
AC_SUBST(HAVE_FFTW_H)
AC_SUBST(HAVE_JPEG_H)
AC_SUBST(HAVE_TIFF_H)

AC_CONFIG_FILES([src/Makevars R/fft_filters.R R/fft_funcs.R R/tiff.R R/jpeg.R])
AC_OUTPUT
