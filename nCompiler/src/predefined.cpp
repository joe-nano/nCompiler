//GENERATED BY generatedPredefinedCpp.R. DO NOT EDIT BY HAND
//--------------------------------------
//--------------------------------------
// test_predefined
//--------------------------------------
#ifndef __test_predefined_CPP
#define __test_predefined_CPP
#include <RcppEigen.h>
#include <Rcpp.h>


#ifndef BEGIN_RCPP
#define BEGIN_RCPP
#endif

#ifndef END_RCPP
#define END_RCPP
#endif

using namespace Rcpp;
#ifndef R_NO_REMAP
#define R_NO_REMAP
#endif
#include <iostream>
#include "predefined.h"
using namespace Rcpp;
// [[Rcpp::plugins(nCompiler_Eigen_plugin)]]
// [[Rcpp::depends(RcppEigenAD)]]
// [[Rcpp::depends(RcppParallel)]]

// [[Rcpp::depends(Rcereal)]]



// [[Rcpp::export]]
SEXP  new_test_predefined (  )  {
return(loadedObjectEnv(new_nCompiler_object<test_predefined>()));
}

NCOMPILER_INTERFACE(
test_predefined,
NCOMPILER_FIELDS(
field("a", &test_predefined::a)
),
NCOMPILER_METHODS()
)
#endif
//--------------------------------------
//--------------------------------------
// nC_derivClass
//--------------------------------------
#ifndef __nC_derivClass_CPP
#define __nC_derivClass_CPP
#include <RcppEigen.h>
#include <Rcpp.h>


#ifndef BEGIN_RCPP
#define BEGIN_RCPP
#endif

#ifndef END_RCPP
#define END_RCPP
#endif

using namespace Rcpp;
#ifndef R_NO_REMAP
#define R_NO_REMAP
#endif
#include <iostream>
#include "predefined.h"
using namespace Rcpp;
// [[Rcpp::plugins(nCompiler_Eigen_plugin)]]
// [[Rcpp::depends(RcppEigenAD)]]
// [[Rcpp::depends(RcppParallel)]]

// [[Rcpp::depends(Rcereal)]]



// [[Rcpp::export]]
SEXP  new_nC_derivClass (  )  {
return(loadedObjectEnv(new_nCompiler_object<nC_derivClass>()));
}

NCOMPILER_INTERFACE(
nC_derivClass,
NCOMPILER_FIELDS(
field("value", &nC_derivClass::value),
field("gradient", &nC_derivClass::gradient),
field("hessian", &nC_derivClass::hessian)
),
NCOMPILER_METHODS()
)
#endif
