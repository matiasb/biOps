
# Tests setup

matrix1 <- array(c(1, 4, 3, 7, 2, 8, 2, 5, 6), dim=c(3,3))
matrix2 <- array(c(3, 2, 3, 5, 0, 5, 6, 1, 4), dim=c(3,3))
img1 <- imagedata(matrix1)
img2 <- imagedata(matrix2)


# Test functions

testAnd <- function(){
	res <- imgAND(img1, img2)
	expected <- array(c(1, 0, 3, 5, 0, 0, 2, 1, 4), dim=c(3,3))
	checkEqual(res, expected)
}

testOr <- function(){
	res <- imgOR(img1, img2)
	expected <- array(c(3, 6, 3, 7, 2, 13, 6, 5, 6), dim=c(3,3))
	checkEqual(res, expected)
}

testXor <- function(){
	res <- imgXOR(img1, img2)
	expected <- array(c(2, 6, 0, 2, 2, 13, 4, 4, 2), dim=c(3,3))
	checkEqual(res, expected)
}
