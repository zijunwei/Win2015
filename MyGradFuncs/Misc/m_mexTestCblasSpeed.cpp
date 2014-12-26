/*
 * m_mexTestCblasSpeed.cpp
 *
 * Created on: May 20, 2012
 * Author: Minh Hoai Nguyen, University of Oxford
 * Email:  minhhoai@robots.ox.ac.uk
 */

#include <stdlib.h>
#include <math.h>
#include <mex.h>
#include <vector>
#include <limits>
#include <algorithm>
#include<gsl/gsl_cblas.h>
//#include<cblas.h>

using namespace std;

// dot product
double vec_xty(double *vec1, double *vec2, int d){
   double rslt = 0;
   for (int i=0; i < d; i++) rslt += vec1[i]*vec2[i];
   return rslt;
}


/**
 * Simple function to test Cblas speed computing: W'*x + b.
 */
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {
   enum{
      W_IN = 0,  // positive training data
      B_IN,      // negative training data
      X_IN,
      NREPEAT_IN,
      SHLDUSECBLAS_IN
   };

   bool shldUseCblas  = (bool) mxGetScalar(prhs[SHLDUSECBLAS_IN]);
   double *W = mxGetPr(prhs[W_IN]);
   double *b = mxGetPr(prhs[B_IN]);
   double *x = mxGetPr(prhs[X_IN]);
   int nRepeat = (int) mxGetScalar(prhs[NREPEAT_IN]);

   int d = mxGetM(prhs[W_IN]);
   int k = mxGetN(prhs[W_IN]);


   double *rslt = new double[k];
   if (shldUseCblas){
//      mexPrintf("Using Cblas\n");
      for (int i=0; i < nRepeat; i++){
         memcpy(rslt, b, k*sizeof(double)); // rslt = b;
         cblas_dgemv(CblasColMajor, CblasTrans, d, k, 1, W, d, x, 1, 1, rslt, 1); // score = Ws'*vec + b
      }
   } else {
//      mexPrintf("Not using Cblas\n");
      for (int i=0; i < nRepeat; i++){
         for (int j=0; j < k; j++){
            rslt[j] = vec_xty(x, W + d*j, d) + b[j];
         }
      }
   }
	plhs[0] = mxCreateDoubleMatrix(k,1, mxREAL);
	double *out  = mxGetPr(plhs[0]);
	memcpy(out, rslt, k*sizeof(double));

   delete [] rslt;
}
