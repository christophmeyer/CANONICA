#!/bin/bash

# This software is covered by the GNU General Public License 3.
# Copyright (C) 2017-2020 Christoph Meyer
# Copyright (C) 2019-2020 Vladyslav Shtabovenko

# Description:

# Checks CANONICA using real-life calculations.

# Stop if any of the examples fails
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR



MATH=$1

# Notice that exFile can contain more elements to check different modes/sector/etc.
# of the same example

#DrellYanOneMass
#-------------------------------------------------------------------------------
for exFile in 'RunExample.m'

do
  echo
  echo -e "* \c"
  $MATH -nopromt -script ../examples/DrellYanOneMass/$exFile -run extraArgs=\"$2\"
done

##K4Integral
##-------------------------------------------------------------------------------
#for exFile in 'RunExample.m'

#do
#  echo
#  echo -e "* \c"
#  $MATH -nopromt -script ../examples/K4Integral/$exFile
#done

##MasslessdBox
##-------------------------------------------------------------------------------
#for exFile in 'RunExample.m'

#do
#  echo
#  echo -e "* \c"
#  $MATH -nopromt -script ../examples/MasslessdBox/$exFile
#done

##MasslessdBoxNonPlanar
##-------------------------------------------------------------------------------
#for exFile in 'RunExample.m'

#do
#  echo
#  echo -e "* \c"
#  $MATH -nopromt -script ../examples/MasslessdBoxNonPlanar/$exFile
#done

##SingleTopT1
##-------------------------------------------------------------------------------
#for exFile in 'RunExample.m'

#do
#  echo
#  echo -e "* \c"
#  $MATH -nopromt -script ../examples/SingleTopT1/$exFile
#done

##SingleTopT2
##-------------------------------------------------------------------------------
#for exFile in 'RunExample.m'

#do
#  echo
#  echo -e "* \c"
#  $MATH -nopromt -script ../examples/SingleTopT2/$exFile
#done

##TripleBox
##-------------------------------------------------------------------------------
#for exFile in 'RunExample.m'

#do
#  echo
#  echo -e "* \c"
#  $MATH -nopromt -script ../examples/TripleBox/$exFile
#done
##-------------------------------------------------------------------------------

##VVT1
##-------------------------------------------------------------------------------
#for exFile in 'RunExample.m'

#do
#  echo
#  echo -e "* \c"
#  $MATH -nopromt -script ../examples/VVT1/$exFile
#done
##-------------------------------------------------------------------------------

##VVT2
##-------------------------------------------------------------------------------
#for exFile in 'RunExample.m'

#do
#  echo
#  echo -e "* \c"
#  $MATH -nopromt -script ../examples/VVT2/$exFile
#done
##-------------------------------------------------------------------------------

# If we have notify-send installed, generate a notification once the test run finishes.
if [ -x "$(command -v notify-send)" ]; then
  notify-send --urgency=low -i "$([ $? = 0 ] && echo sunny || echo error)" "Finished running examples for CANONICA."
fi



