
# Tests setup

matrix1 <- array(c(34, 123, 233, 175, 0, 85, 166, 15, 255), dim=c(3,3))
img1 <- imagedata(matrix1)


# Test functions

testNegative <- function(){
	res <- imgNegative (img1)
	expected <- array(c(221, 132, 22, 80, 255, 170, 89, 240, 0), dim=c(3,3))
	checkEqual(res, expected)
}

testr_negative <- function(){
	res <- r_negative (img1)
	expected <- array(c(221, 132, 22, 80, 255, 170, 89, 240, 0), dim=c(3,3))
	checkEqual(res, expected)
}

testr_negative_lut <- function(){
	res <- r_negative_lut (img1)
	expected <- array(c(221, 132, 22, 80, 255, 170, 89, 240, 0), dim=c(3,3))
	checkEqual(res, expected)
}

testIncreaseIntensity <- function(){
	res <- imgIncreaseIntensity (img1, 0.1)
	expected <- array(c(37, 135, 255, 192, 0, 93, 182, 16, 255), dim=c(3,3))
	checkEqual(res, expected)
}

testr_inc_intensity <- function(){
	res <- r_inc_intensity (img1, 0.1)
	expected <- array(c(37, 135, 255, 192, 0, 93, 182, 16, 255), dim=c(3,3))
	checkEqual(res, expected)
}

testDecreaseIntensity <- function(){
	res <- imgDecreaseIntensity (img1, 0.1)
	expected <- array(c(30, 110, 209, 157, 0, 76, 149, 13, 229), dim=c(3,3))
	checkEqual(res, expected)
}

testr_dec_intensity <- function(){
	res <- r_dec_intensity (img1, 0.1)
	expected <- array(c(30, 110, 209, 157, 0, 76, 149, 13, 229), dim=c(3,3))
	checkEqual(res, expected)
}

testIncreaseContrast <- function(){
	res <- imgIncreaseContrast (img1, 70, 150)
	expected <- array(c(0, 168, 255, 255, 0, 47, 255, 0, 255), dim=c(3,3))
	checkEqual(res, expected)
}

testr_inc_contrast <- function(){
	res <- r_inc_contrast (img1, 70, 150)
	expected <- array(c(0, 168, 255, 255, 0, 47, 255, 0, 255), dim=c(3,3))
	checkEqual(res, expected)
}

testDecreaseContrast <- function(){
	res <- imgDecreaseContrast (img1, 70, 150)
	expected <- array(c(80, 108, 143, 124, 70, 96, 122, 74, 150), dim=c(3,3))
	checkEqual(res, expected)
}

testr_dec_contrast <- function(){
	res <- r_dec_contrast (img1, 70, 150)
	expected <- array(c(80, 108, 143, 124, 70, 96, 122, 74, 150), dim=c(3,3))
	checkNear(res, expected, 0.999)
}

testThreshold <- function(){
	res <- imgThreshold (img1, 175)
	expected <- array(c(0, 0, 255, 255, 0, 0, 0, 0, 255), dim=c(3,3))
	checkEqual(res, expected)
}

testr_threshold <- function(){
	res <- r_threshold (img1, 175)
	expected <- array(c(0, 0, 255, 255, 0, 0, 0, 0, 255), dim=c(3,3))
	checkEqual(res, expected)
}

# matrix1 <- array(c(34, 123, 233, 175, 0, 85, 166, 15, 255), dim=c(3,3))
testGamma <- function(){
	res <- imgGamma (img1, 0.5)
	expected <- array(c(4, 59, 212, 120, 0, 28, 108, 0, 255), dim=c(3,3))
	checkEqual(res, expected)
}

testr_gamma <- function(){
	res <- r_gamma (img1, 0.5)
	expected <- array(c(4, 59, 212, 120, 0, 28, 108, 0, 255), dim=c(3,3))
	checkEqual(res, expected)
}
