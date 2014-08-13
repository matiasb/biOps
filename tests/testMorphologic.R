# Tests setup

matrix1 <- array(c(255, 0, 255, 0, 255, 255, 255, 0, 0), dim=c(3,3))
matrix2 <- array(c(114, 0, 210, 13, 120, 63, 255, 99, 127), dim=c(3,3))
mask <- imagedata(array(c(0, 255, 255, 255, 0, 0, 255, 255, 255), dim=c(3,3)), "grey")
mask2 <- imagedata(array(c(255, 0, 255, 0, 255, 255, 255, 0, 0), dim=c(3,3)), "grey")
mask3 <- imagedata(array(c(120, 120, 90, 90, 90, 90, 90, 120, 120), dim=c(3,3)), "grey")
img1 <- imagedata(matrix1)
img2 <- imagedata(matrix2)


# Test functions

testBinaryDilation <- function(){
	res <- imgBinaryDilation (img1, mask)
	expected <- array(c(255, 0, 0, 0, 0, 255, 255, 0, 0), dim=c(3,3))
	checkEqual(res, expected)
}

testGrayScaleDilation <- function(){
	res <- imgGrayScaleDilation (img2, mask3)
	expected <- array(c(240, 255, 255, 255, 255, 255, 255, 255, 240), dim=c(3,3))
	checkEqual(res, expected)
}

testBinaryErosion <- function(){
	res <- imgBinaryErosion (img1, mask2)
	expected <- array(c(255, 255, 255, 255, 0, 255, 255, 255, 255), dim=c(3,3))
	checkEqual(res, expected)
}

testGrayScaleErosion <- function(){
	res <- imgGrayScaleErosion (img2, mask3)
	expected <- array(c(0, 0, 0, 0, 0, 0, 0, 0, 0), dim=c(3,3))
	checkEqual(res, expected)
}

testStdBinaryDilation <- function(){
	res <- imgStdBinaryDilation (img1, 3)
	expected <- array(c(0, 0, 0, 0, 0, 0, 0, 0, 0), dim=c(3,3))
	checkEqual(res, expected)
}

testStdBinaryErosion <- function(){
	res <- imgStdBinaryErosion (img1, 3)
	expected <- array(c(255, 255, 255, 255, 255, 255, 255, 255, 255), dim=c(3,3))
	checkEqual(res, expected)
}

testStdBinaryErosion <- function(){
	res <- imgBinaryOpening (img1, mask)
	expected <- array(c(255, 255, 255, 255, 255, 255, 255, 255, 255), dim=c(3,3))
	checkEqual(res, expected)
}

testGrayScaleOpening <- function(){
	res <- imgGrayScaleOpening (img2, mask3)
	expected <- array(c(120, 120, 120, 120, 120, 120, 120, 120, 120), dim=c(3,3))
	checkEqual(res, expected)
}

testBinaryClosing <- function(){
	res <- imgBinaryClosing (img1, mask2)
	expected <- array(c(255, 255, 255, 255, 255, 255, 255, 255, 255), dim=c(3,3))
	checkEqual(res, expected)
}

testGrayScaleClosing <- function(){
	res <- imgGrayScaleClosing (img2, mask3)
	expected <- array(c(135, 135, 135, 120, 120, 120, 135, 135, 135), dim=c(3,3))
	checkEqual(res, expected)
}

testStdBinaryOpening <- function(){
	res <- imgStdBinaryOpening (img1)
	expected <- array(c(255, 255, 255, 255, 255, 255, 255, 255, 255), dim=c(3,3))
	checkEqual(res, expected)
}

testStdBinaryClosing <- function(){
	res <- imgStdBinaryClosing (img1)
	expected <- array(c(255, 255, 255, 255, 0, 255, 255, 255, 255), dim=c(3,3))
	checkEqual(res, expected)
}

# imgNErosionDilation <- function(imgdata, mask, n){
# imgNDilationErosion <- function(imgdata, mask, n){
# imgStdNErosionDilation <- function (imgdata, n, dim=3){
# imgStdNDilationErosion <- function (imgdata, n, dim=3){
