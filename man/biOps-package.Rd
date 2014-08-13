\name{biOps-package}
\alias{biOps-package}
\alias{biOps}
\docType{package}
\title{
Basic image operations and image processing
}
\description{
This package includes arithmetic, logic, look up table and
geometric operations. Some image processing functions, for edge
detection (several algorithms including roberts, sobel, kirsch,
marr-hildreth, canny) and operations by convolution masks (with
predefined as well as user defined masks) are provided.
Supported file formats are jpeg and tiff (it requires libtiff
and libjpeg libraries installed).
}
\details{
\tabular{ll}{
Package: \tab biOps\cr
Type: \tab Package\cr
Version: \tab 0.2\cr
Date: \tab 2007-08-02\cr
Encoding: \tab UTF-8\cr
SystemRequirements: \tab libtiff, libjpeg\cr
License: \tab GPL\cr
Built: \tab R 2.5.1; i486-pc-linux-gnu; 2007-10-10 23:35:42; unix\cr
}

Index:
\preformatted{
biOps-package           Basic image operations
imageType               Get information on color type of imagedata
imagedata               Generate an imagedata
imgAND                  And two images
imgAdd                  Add two images
imgAverage              Average images
imgAverageShrink        Shrink an image
imgBilinearRotate       Rotate an image
imgBilinearScale        Scale an image
imgBinaryClosing        Applies a "closing" to an image
imgBinaryDilation       Dilation of a binary image
imgBinaryErosion        Erosion of a binary image
imgBinaryOpening        Applies an "opening" to an image
imgBlockMedianFilter    Filters an image
imgBlueBand             Return the image blue band
imgBlur                 Blurs an image
imgBoost                High Boosts an image
imgCanny                Canny Edge Detection Method
imgConvolve             Performs an image convolution
imgCrop                 Crops an image
imgCubicRotate          Rotate an image
imgCubicScale           Scale an image
imgDecreaseContrast     Decrease contrast
imgDecreaseIntensity    Decrease intensity
imgDiffer               Substract two images
imgDifferenceEdgeDetection
                        Enhaces image edges
imgDivide               Divide two images
imgEKMeans              Image clustering
imgFFT                  Fast Fourier Transformation of an image
imgFFTBandPass          Apply a band pass filter on a fft matrix
imgFFTBandStop          Apply a band stop filter on a fft matrix
imgFFTConvolve          Apply a convolution filter on an imagedata
                        through fft transformation
imgFFTHighPass          Apply a high pass filter on a fft matrix
imgFFTInv               Fast Fourier Inverse Transformation to an image
imgFFTLowPass           Apply a low pass filter on a fft matrix
imgFFTPhase             Image representation of the fft matrix phase
imgFFTShift             Shift a matrix and leave top-left value in the
                        center
imgFFTSpectrum          Image representation of the fft matrix spectrum
imgFFTiShift            Inverse of the imgFFTShift
imgFreiChen             Frei-Chen Edge Detection Method
imgGamma                Gamma correct an image
imgGaussianNoise        Add gaussian noise
imgGetRGBFromBands      Return an RGB image
imgGrayScaleClosing     Applies a "closing" to an image
imgGrayScaleDilation    Dilation of a gray scale image
imgGrayScaleErosion     Erosion of a gray scale image
imgGrayScaleOpening     Applies an "opening" to an image
imgGreenBand            Return the image green band
imgHighPassFilter       Sharpens an image
imgHistogram            Return the image histogram
imgHomogeneityEdgeDetection
                        Enhaces image edges
imgHorizontalMirroring
                        Horizontal mirror an image
imgIncreaseContrast     Increase contrast
imgIncreaseIntensity    Increase intensity
imgIsoData              Image clustering
imgKDKMeans             Image clustering
imgKMeans               Image clustering
imgKirsch               Kirsch Edge Detection Method
imgMarrHildreth         Marr-Hildreth Edge Detection Method
imgMaximum              Calculates image maximum
imgMaximumFilter        Filters an image
imgMedianShrink         Shrink an image
imgMinimumFilter        Filters an image
imgMultiply             Multiply two images
imgNDilationErosion     Dilation/Erosion multiple apply
imgNErosionDilation     Erosion/Dilation multiple apply
imgNearestNeighborRotate
                        Rotate an image
imgNearestNeighborScale
                        Scale an image
imgNegative             Negate an image
imgNormalize            Normalization for vector and matrix
imgOR                   Or two images
imgPadding              Pad an image to the given dimensions
imgPrewitt              Prewitt Edge Detection Method
imgPrewittCompassGradient
                        Prewitt Compass Gradient Edge Detection Method
imgRGB2Grey             Convert color imagedata to grey imagedata
imgRedBand              Return the image red band
imgRoberts              Roberts Edge Detection Method
imgRobinson3Level       Robinson 3-level Edge Detection Method
imgRobinson5Level       Robinson 5-level Edge Detection Method
imgRotate               Rotate an image
imgRotate90Clockwise    Rotate an image
imgRotate90CounterClockwise
                        Rotate an image
imgSaltPepperNoise      Add salt and pepper noise
imgScale                Scale an image
imgSharpen              Sharpens an image with selected mask
imgShenCastan           Shen-Castan Edge Detection Method
imgSobel                Sobel Edge Detection Method
imgSplineRotate         Rotate an image
imgSplineScale          Scale an image
imgStdBinaryClosing     Fixed mask binary closing
imgStdBinaryDilation    Fixed mask binary dilation
imgStdBinaryErosion     Fixed mask binary erosion
imgStdBinaryOpening     Fixed mask binary opening
imgStdBlur              Blurs an image
imgStdNDilationErosion
                        Fixed mask NDilationErosion
imgStdNErosionDilation
                        Fixed mask NErosionDilation
imgThreshold            Threshold an image
imgTranslate            Translate an image block
imgUnsharpen            Unsharpens an image with selected mask
imgVerticalMirroring    Vertical mirror an image
imgXOR                  Xor two images
logo                    R logo imagedata
plot.imagedata          Plotting an imagedata object
print.imagedata         Print information on a given imagedata object
r_dec_contrast          Decrease contrast
r_dec_intensity         Decrease intensity
r_gamma                 Gamma correct an image
r_imgAdd                Add two images
r_imgAverage            Average images
r_imgDiffer             Substract two images
r_imgMaximum            Images maximum
r_inc_contrast          Increase contrast
r_inc_intensity         Increase intensity
r_look_up_table         Transforms an image by a given look-up table
r_negative              Negate an image
r_negative_lut          Negate an image
r_threshold             Threshold an image
readJpeg                Read jpeg file
readTiff                Read tiff file
writeJpeg               Write jpeg file
writeTiff               Write tiff file
}
}
\author{
Matias Bordese, Walter Alini

Maintainer: Matias Bordese <mbordese@gmail.com>
}
\keyword{ package }
