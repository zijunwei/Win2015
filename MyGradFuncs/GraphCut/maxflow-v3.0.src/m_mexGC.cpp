/* m_mexGC.cpp
 * Matlab interface for graph cut maxflow algorithm.
 * By: Minh Hoai Nguyen
 * Date: 26 July 07
 */

#include "mex.h"
#include <stdio.h>
#include "graph.h"
#include <map>

using namespace std;

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]){
    /* check for the proper no. of input and outputs */
    if (nrhs != 2)
        mexErrMsgTxt("2 input arguments are required");
    if (nlhs>2)
        mexErrMsgTxt("Too many outputs");
    
    int nNodes = mxGetM(prhs[0]);
    int nEdges = mxGetM(prhs[1]);

    double *nodeData = mxGetPr(prhs[0]);
    double *edgeData = mxGetPr(prhs[1]);
    
    map<int, int> nodeIDs;
    
    typedef Graph<double,double,double> GraphType;
	GraphType *g = new GraphType(nNodes, nEdges); 


    //Adding nodes and capacities to  the SOURCE and SINK
    for (int i=0; i < nNodes; i++){
        g->add_node(); 
        g->add_tweights(i, nodeData[i+nNodes], nodeData[i+2*nNodes]);
        nodeIDs[nodeData[i]] = i;
    }
    
    //Adding edges and their associated capacities 
    for (int i=0; i < nEdges; i++){
        int node1 = nodeIDs[edgeData[i]];
        int node2 = nodeIDs[edgeData[i+nEdges]];
        g -> add_edge(node1, node2, edgeData[i+2*nEdges], edgeData[i+3*nEdges]);        
    }
    
	plhs[0] = mxCreateDoubleMatrix(nNodes, 1, mxREAL);
    plhs[1] = mxCreateDoubleMatrix(1,1,mxREAL);
    double *flow = mxGetPr(plhs[1]);
    flow[0] = g->maxflow();

   
    double *output = mxGetPr(plhs[0]);    
    for (int i=0; i < nNodes; i++){
        if (g->what_segment(i) == GraphType::SOURCE) output[i] = 1;        
        else output[i] = 0;
    }
	delete g;   
}
    
    
