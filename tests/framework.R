
pkg <- 'biOps'

#load packages
library(package=pkg, character.only=TRUE)

#common functions
checkEqual <- function(a, b){
	res <- TRUE
	c <- a - b
	for (i in c){
		if (i != 0){
			res <- FALSE
			break
		}
	}
	res
}

checkNear <- function(a, b, max_differ){
	res <- TRUE
	c <- a - b
	for (i in c){
		if (i > max_differ){
			res <- FALSE
			break
		}
	}
	res
}


######### ignore from here
######### internal functions

#load tests files
files = dir(path = '.', pattern = 'test*')

# print (files)

for (f in files){
	ev_env <- new.env(parent = environment())
	sys.source(f, envir=ev_env)
	tests <- ls(ev_env, pat="test*")

# 	print (tests)

	for (t in tests){
		res <- eval (call (t), envir=ev_env)
		if (res){
			cat ('.')
		}else{
			cat ('F\n')
			cat (t)
			cat('\n')
		}
	}
	gc()
}
cat('\n')
