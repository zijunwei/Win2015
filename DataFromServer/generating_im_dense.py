#! /usr/bin/python
import os
from os.path import *
import time
import sys

#was 11 3  4
for i in range (0,15):
			cmd = 'qsub  -cwd -N x_im_dense   matlab.pbs '
			#print cmd
			os.system(cmd)
			time.sleep(2)
            


