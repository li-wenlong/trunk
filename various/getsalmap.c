#include <math.h>
#include "string.h"
#include "mex.h"

/* Input Arguments */

#define	l           prhs[0]
#define	a	        prhs[1]
#define b           prhs[2]

/* Output Arguments */
#define	sm	plhs[0]

#if !defined(MAX)
#define	MAX(A, B)	((A) > (B) ? (A) : (B))
#endif

#if !defined(MIN)
#define	MIN(A, B)	((A) < (B) ? (A) : (B))
#endif


double getmean( double *arrayptr, int *dims, int y1, int y2, int x1, int x2 )
{
    double av = 0.0;
    int j,k;
    int ind;
    for( j = y1; j <= y2; j++){
        for( k= x1; k<= x2; k++){
            ind = j + (dims[0])*k;
            av += arrayptr[ind];            
        }
    }
    return av/((y2-y1+1)*(x2-x1+1));
}

void mexFunction( int nlhs, mxArray *plhs[], 
		  int nrhs, const mxArray *prhs[] )
{
    mxArray *target;
    mwSize *dims_l, numDims_l, *dims_a, numDims_a, *dims_b, numDims_b;
    int i,j,k;
    int x11,x12,x21,x22,x31,x32;
    int y11,y12,y21,y22,y31,y32;
    int off1, off2, off3;
    int mind;
    int ind;
    double lm1,lm2,lm3,am1,am2,am3,bm1,bm2,bm3;
    double cv1, cv2, cv3;
    double *array_a, *array_b, *array_l, *target_array;
    
    
    if (nrhs != 3){
       mexErrMsgTxt("Please provide 3 input specifying the LAB image.");  
    }
    
    
    dims_l = mxGetDimensions( l );
    numDims_l = mxGetNumberOfDimensions( l );
    dims_a = mxGetDimensions( a );
    numDims_a = mxGetNumberOfDimensions( a );
    dims_b = mxGetDimensions( b );
    numDims_b = mxGetNumberOfDimensions( b );
    
    if ( (numDims_l != 2 ) || (numDims_a != 2 ) || (numDims_b != 2 ) ){
        mexErrMsgTxt("The input arrays should be 2-dimensional!");  
    }
    
     for( i=0; i< numDims_l; i++ ){
        if ( ( dims_l[i] != dims_a[i] ) || ( dims_l[i] != dims_b[i] ) || ( dims_a[i] != dims_b[i] ) ) {
            mexErrMsgTxt("The sizes of the input arrays mismatch!"); 
        }
        
     }
    
    /* allocate memory for the target array, same with the inputs */
    target = mxCreateNumericArray( numDims_l, dims_l,
    mxGetClassID( l ), mxREAL  );
    
    target_array = mxGetPr( target );
    
    array_l = mxGetPr( l );
    array_a = mxGetPr( a );
    array_b = mxGetPr( b );
    
    mind = MIN( dims_l[0], dims_l[1] );
    off1 = (int) ceil( ((double)mind )/8 ); 
    off2 = (int) ceil( ((double)off1)/2 ); 
    off3 = (int) ceil( ((double)off2)/2 );
    
    for( j=0; j< dims_l[0]; j ++){
        y11 = MAX(0,j-off1);
        y12 = MIN(j + off1, dims_l[0] -1 );
        y21 = MAX(0, j-off2 );
        y22 = MIN( j + off2, dims_l[0] -1 );
        y31 = MAX(0, j-off3);
        y32 = MIN( j + off3, dims_l[0] -1 );
        
        for( k=0; k< dims_l[1]; k++){
         /* j th row, k th col */
            x11 = MAX(0, k-off1 );
            x12 = MIN(k+off1, dims_l[1] -1 );
            x21 = MAX(0,k-off2);
            x22 = MIN( k+off2, dims_l[1] -1 );
            x31 = MAX(0, k-off3 );
            x32 = MIN( k+off3,  dims_l[1] -1 );
            
            
            lm1 = getmean( array_l, dims_l, y11, y12, x11, x12 );
            lm2 = getmean( array_l, dims_l, y21, y22, x21, x22 );
            lm3 = getmean( array_l, dims_l, y31, y32, x31, x32 );
            
            am1 = getmean( array_a, dims_l, y11, y12, x11, x12 );
            am2 = getmean( array_a, dims_l, y21, y22, x21, x22 );
            am3 = getmean( array_a, dims_l, y31, y32, x31, x32 );
            
            bm1 = getmean( array_b, dims_l, y11, y12, x11, x12 );
            bm2 = getmean( array_b, dims_l, y21, y22, x21, x22 );
            bm3 = getmean( array_b, dims_l, y31, y32, x31, x32 );
            
            ind = j + (dims_l[0])*k ;
             
            cv1 = (array_l[ind]-lm1)*(array_l[ind]-lm1) + (array_a[ind]-am1)*(array_a[ind]-am1) + (array_b[ind]-bm1)*(array_b[ind]-bm1);
            cv2 = (array_l[ind]-lm2)*(array_l[ind]-lm2) + (array_a[ind]-am2)*(array_a[ind]-am2) + (array_b[ind]-bm2)*(array_b[ind]-bm2);
            cv3 = (array_l[ind]-lm3)*(array_l[ind]-lm3) + (array_a[ind]-am3)*(array_a[ind]-am3) + (array_b[ind]-bm3)*(array_b[ind]-bm3);
            
            target_array[ind] = cv1 + cv2 + cv3;
         
            
        } 
    }
    
    sm = target;
    return;   
}
