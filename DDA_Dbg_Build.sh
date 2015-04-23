#!/bin/bash

# This scripts is used to compile target project /COM/Projects/ObjectServer/
# But before doing that we need to compile /COM/IDL first to generate some header files.

# Generate DSSCOMMaster/DSSCOMMaster_i.h
echo "========================================="
echo "Generate Header Files"
echo "========================================="

cd /home/cp2/views/cp2_DDA_lnx_dbg_view/COM/IDL
../../BuildScripts/one.pl -one -notest
make -f MakefileLinux -B

# Compile target project.
echo "========================================="
echo "Build ObjectServer Project"
echo "========================================="

cd /home/cp2/views/cp2_DDA_lnx_dbg_view/COM/Projects/ObjectServer/
../../../BuildScripts/one.pl -one -notest
make -f MakefileLinux
