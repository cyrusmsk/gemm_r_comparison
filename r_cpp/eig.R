library(Rcpp)
sourceCpp("eig.cpp")

N <- 3000

zz <- file("/tmp/matmul", "rb")

A <- matrix(readBin(zz, "double", N*N, size = 4), nrow = N, ncol = N, byrow = TRUE)
B <- matrix(readBin(zz, "double", N*N, size = 4), nrow = N, ncol = N, byrow = TRUE)
C <- matrix(readBin(zz, "double", N*N, size = 4), nrow = N, ncol = N, byrow = TRUE)

close(zz)
gflop <- 2.0*N*N*N*1e-9

Bt = t(B)
for(i in 1:20) {
  start <- Sys.time()
  check <- eigenMapMatMult(A, B, 8)
  end <- Sys.time()
  s = (end - start)
  out <- paste0(format(gflop/as.numeric(s), digits = 3)," GFLOP/S -- ", format(as.numeric(s)*1e3, digits = 3), " ms\n")
  print(out)
}
