#!/bin/bash
# --------------------------------------------------------------------------
# Programmer(s): David J. Gardner @ LLNL
# --------------------------------------------------------------------------
# SUNDIALS Copyright Start
# Copyright (c) 2002-2019, Lawrence Livermore National Security
# and Southern Methodist University.
# All rights reserved.
#
# See the top-level LICENSE and NOTICE files for details.
#
# SPDX-License-Identifier: BSD-3-Clause
# SUNDIALS Copyright End
# --------------------------------------------------------------------------
# Script to build KLU
# --------------------------------------------------------------------------

# set paths
srcdir=${HOME}/SuiteSparse
installdir=${PROJHOME}/${COMPILERNAME}/suitesparse-5.4.0

# ------------------------------------------------------------------------------
# Configure, build, and install
# ------------------------------------------------------------------------------

# return on any error
set -e

# move to source
cd $srcdir

# use external version of metis
\rm -rf metis-*

# comment out all lines containing SPQR (i.e., don't build SPQR)
sed -i "/SPQR/s/^/#/g" Makefile

# displays parameter settings; does not compile
make config \
    CC=${CC} \
    CXX=${CXX} \
    F77=${FC} \
    BLAS=${BLAS_LIB} \
    LAPACK=${LAPACK_LIB} \
    MY_METIS_INC=${METIS_INC_DIR} \
    MY_METIS_LIB=${METIS_LIB} \
    INSTALL="$installdir" \
    JOBS=12 \
    2>&1 | tee configure.log

# compiles SuiteSparse
make library \
    CC=${CC} \
    CXX=${CXX} \
    F77=${FC} \
    BLAS=${BLAS_LIB} \
    LAPACK=${LAPACK_LIB} \
    MY_METIS_INC=${METIS_INC_DIR} \
    MY_METIS_LIB=${METIS_LIB} \
    INSTALL="$installdir" \
    JOBS=12 \
    2>&1 | tee make.log

# create install directory
\rm -rf $installdir
mkdir -p $installdir

# install headers and libraries
cp -r include $installdir
cp -r lib $installdir

# move log files
cp *.log $installdir/.
