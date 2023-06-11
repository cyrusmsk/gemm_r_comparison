// [[Rcpp::depends(RcppArmadillo)]]
// [[Rcpp::plugins(openmp)]]

#include <omp.h>
#include <RcppArmadillo.h>

// [[Rcpp::export]]
SEXP armaMatMult(arma::mat A, arma::mat B){
  arma::mat C = A * B;
  
  return Rcpp::wrap(C);
}
