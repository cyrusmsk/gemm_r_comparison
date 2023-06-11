library(microbenchmark)
library(Rcpp)
sourceCpp("matmul.cpp")

# Benchmark 1: N = k = 100

N <- 2048
k <- 2048

A <- matrix(rnorm(N*k), N, k)
B <- matrix(rnorm(N*k), k, N)

microbenchmark(A%*%B, 
               crossprod(A,B),
               armaMatMult(A, B),
               #eigenMatMult(A, B, n_cores = 1),
               #eigenMatMult(A, B, n_cores = 4),
               eigenMatMult(A, B, n_cores = 8),
               #eigenMapMatMult(A, B, n_cores = 1),
               #eigenMapMatMult(A, B, n_cores = 4), 
               eigenMapMatMult(A, B, n_cores = 8), 
               times = 100)
