#!/bin/bash
#$ -cwd

# Put libary paths here,e.g.
#export LD_LIBRARY_PATH=/home/minhhoai/Study/Libs/vlfeat-0.9.17/bin/glnxa64/:/users/omkar/arnie/lib/:/users/minhhoai/local/lib/opencv_old/:/opt/gridware/pkg/compilers/gcc/4.7.1/lib64/:/users/minhhoai/local/openblas/lib/:/users/omkar/local_new/lib:/users/omkar/local_new/lib/boost:/users/alonso/local/lib/

/usr/local/bin/matlab -singleCompThread -nosplash -nodisplay -nodesktop -r $1

