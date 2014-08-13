
# Tests setup

matrix <- array(c(106, 79, 108, 105, 103, 102, 145, 70, 82), dim=c(3,3))
mask <- array(c(-1,-1,-1,-1,9,-1,-1,-1,-1), dim=c(3,3))
img <- imagedata(matrix)


# Test functions

testConvolve <- function(){
	res <- imgConvolve(img, mask)
	expected <- array(c(165, 0, 183, 86, 130, 184, 255, 0, 45), dim=c(3,3))
	checkEqual(res, expected)
}

testConvolveBias <- function(){
	res <- imgConvolve(img, mask, 110)
	expected <- array(c(255, 4, 255, 196, 240, 255, 255, 0, 155), dim=c(3,3))
	checkEqual(res, expected)
}
