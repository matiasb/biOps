
# Tests setup

matrix1 <- array(c(0, 25, 50, 75, 100, 125, 150, 200, 225), dim=c(3,3))
matrix2 <- array(c(34, 123, 233, 175, 0, 85, 165, 15, 100), dim=c(3,3))
img1 <- imagedata(matrix1)
img2 <- imagedata(matrix2)


# Test functions

testAdd <- function(){
	res <- imgAdd(img1, img2)
	expected <- array(c(34, 148, 255, 250, 100, 210, 255, 215, 255), dim=c(3,3))
	checkEqual(res, expected)
}

testDiffer <- function(){
	res <- imgDiffer(img2, img1)
	expected <- array(c(34, 98, 183, 100, 0, 0, 15, 0, 0), dim=c(3,3))
	checkEqual(res, expected)
}

testMultiply <- function(){
	res <- imgMultiply(img2, img1)
	expected <- array(c(0, 255, 255, 255, 0, 255, 255, 255, 255), dim=c(3,3))
	checkEqual(res, expected)
}

testDivide <- function(){
	res <- imgDivide(img2, img1)
	expected <- array(c(0, 4, 4, 2, 0, 0, 1, 0, 0), dim=c(3,3))
	checkEqual(res, expected)
}

testAverage <- function(){
	res <- imgAverage(list(img2, img1))
	expected <- array(c(17, 74, 141.5, 125, 50, 105, 157.5, 107.5, 162.5), dim=c(3,3))
	checkEqual(res, expected)
}

testMaximum <- function(){
	res <- imgMaximum(list(img2, img1))
	expected <- array(c(34, 123, 233, 175, 100, 125, 165, 200, 225), dim=c(3,3))
	checkEqual(res, expected)
}
