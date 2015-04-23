#!/bin/bash

# Generate DSSCOMMaster/DSSCOMMaster_i.h
echo "========================================="
echo "Generate Header Files"
echo "========================================="

cd /home/cp2/views/cp2_DDA_lnx_dbg_view/COM/IDL
../../BuildScripts/one.pl -one -notest
make -f MakefileLinux -B

echo "========================================="
echo "Build ObjectServer Project"
echo "========================================="

cd /home/cp2/views/cp2_DDA_lnx_dbg_view/COM/Projects/ObjectServer/
../../../BuildScripts/one.pl -one -notest
make -f MakefileLinux
