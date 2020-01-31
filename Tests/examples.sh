#!/bin/bash

# This software is covered by the GNU General Public License 3.
# Copyright (C) 2017-2020 Christoph Meyer
# Copyright (C) 2019-2020 Vladyslav Shtabovenko

# Description:

# Checks CANONICA using real-life calculations.

# Usage examples:

# Tests/examples.sh math

# Tests/examples.sh math "verbosity=0"

# Tests/examples.sh math "secEnd=10"

# Tests/examples.sh math "secEnd=10;verbosity=6;computeParallel=True;nParallelKernels=4"

# Tests/examples.sh math "skip={K4Integral,SingleTopT1,SingleTopT2,VVT2,VVT1};"

# Stop if any of the examples fails
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

MATH=$1

for exName in 'MasslessdBox' 'MasslessdBoxNonPlanar' 'DrellYanOneMass' 'TripleBox' \
'K4Integral' 'SingleTopT1' 'SingleTopT2' 'VVT2' 'VVT1' 

do
  echo
  echo -e "* \c"
  $MATH -nopromt -script ../examples/"$exName"/RunExample.m -run extraArgs=\"$2\"
done


# If we have notify-send installed, generate a notification once the test run finishes.
if [ -x "$(command -v notify-send)" ]; then
  notify-send --urgency=low -i "$([ $? = 0 ] && echo sunny || echo error)" "Finished running examples for CANONICA."
fi



