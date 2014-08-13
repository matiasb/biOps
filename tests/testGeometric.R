
# Tests setup

matrix1 <- array(c(34, 123, 233, 175, 0, 85, 166, 15, 255), dim=c(3,3))
matrix2 <- array(c(34, 123, 233, 175, 0, 85, 166, 15, 255, 28, 77, 130, 44, 201, 3, 29), dim=c(4,4))
img1 <- imagedata(matrix1)
img2 <- imagedata(matrix2)

# Test functions

testTranslate <- function(){
	res <- imgTranslate (img1, 1, 0, 1, 1, 2, 2)
	expected <- array(c(34, 123, 233, 175, 175, 0, 166, 166, 15), dim=c(3,3))
	checkEqual(res, expected)
}

testRotate90Clockwise <- function(){
	res <- imgRotate90Clockwise (img1)
	expected <- array(c(233, 85, 255, 123, 0, 15, 34, 175, 166), dim=c(3,3))
	checkEqual(res, expected)
}

testRotate90CounterClockwise <- function(){
	res <- imgRotate90CounterClockwise (img1)
	expected <- array(c(166, 175, 34, 15, 0, 123, 255, 85, 233), dim=c(3,3))
	checkEqual(res, expected)
}

testNearestNeighborRotate <- function(){
	res <- imgNearestNeighborRotate (img1, 30)
	expected <- array(c(123, 123, 85, 0, 175, 0, 85, 0, 175, 15, 15, 0, 166, 0, 0, 0), dim=c(4,4))
	checkEqual(res, expected)
}

testBilinearRotate <- function(){
	res <- imgBilinearRotate (img1, 30)
	expected <- array(c(0, 159, 173, 0, 98, 0, 148, 130, 0, 90, 70, 255, 0, 165, 0, 0), dim=c(4,4))
	checkEqual(res, expected)
}

testCubicRotate <- function(){
	res <- imgCubicRotate (img1, 30)
	expected <- array(c(0, 184, 169, 0, 106, 0, 173, 143, 0, 50, 82, 255, 0, 165, 0, 0), dim=c(4,4))
	checkEqual(res, expected)
}

testSplineRotate <- function(){
	res <- imgSplineRotate (img1, 30)
	expected <- array(c(0, 137, 179, 0, 86, 0, 111, 121, 0, 102, 72, 250, 0, 157, 0, 0), dim=c(4,4))
	checkEqual(res, expected)
}

testNearestNeighborScale <- function(){
	res <- imgNearestNeighborScale (img1, 1.5, 1.5)
	expected <- array(c(34, 123, 123, 233, 175, 0, 0, 85, 175, 0, 0, 85, 166, 15, 15, 255), dim=c(4,4))
	checkEqual(res, expected)
}

testBilinearScale <- function(){
	res <- imgBilinearScale (img1, 1.5, 1.5)
	expected <- array(c(34, 93, 159, 233, 127, 70, 72, 134, 172, 60, 50, 141, 166, 65, 94, 255), dim=c(4,4))
	checkEqual(res, expected)
}

testSplineScale <- function(){
	res <- imgSplineScale (img1, 1.5, 1.5)
	expected <- array(c(34, 94, 159, 233, 121, 79, 88, 149, 164, 77, 72, 155, 166, 83, 111, 255), dim=c(4,4))
	checkEqual(res, expected)
}

testCubicScale <- function(){
	res <- imgCubicScale (img1, 1.5, 1.5)
	expected <- array(c(34, 77, 180, 233, 129, 68, 52, 109, 192, 26, 16, 132, 166, 29, 90, 255), dim=c(4,4))
	checkEqual(res, expected)
}

testHorizontalMirroring <- function(){
	res <- imgHorizontalMirroring (img1)
	expected <- array(c(166, 15, 255, 175, 0, 85, 34, 123, 233), dim=c(3,3))
	checkEqual(res, expected)
}

testVerticalMirroring <- function(){
	res <- imgVerticalMirroring (img1)
	expected <- array(c(233, 123, 34, 85, 0, 175, 255, 15, 166), dim=c(3,3))
	checkEqual(res, expected)
}

testMedianShrink <- function(){
	res <- imgMedianShrink (img2, 0.5, 0.5)
	expected <- array(c(34, 166, 44, 29), dim=c(2,2))
	checkEqual(res, expected)
}

testAverageShrink <- function(){
	res <- imgAverageShrink (img2, 0.5, 0.5)
	expected <- array(c(60, 147, 132, 59), dim=c(2,2))
	checkEqual(res, expected)
}

testCrop <- function(){
	res <- imgCrop (img2, 1, 1, 2, 2)
	expected <- array(c(85, 166, 28, 77), dim=c(2,2))
	checkEqual(res, expected)
}
