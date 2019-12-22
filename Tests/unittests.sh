#!/bin/bash

# This software is covered by the GNU General Public License 3.
# Copyright (C) 2017-2020 Christoph Meyer
# Copyright (C) 2019-2020 Vladyslav Shtabovenko

# Description:

# Runs CANONICA on a set of unit tests.
# The first argument specifies the command-line Mathematica binary
# The second (optional) argument selects a particular set of tests
# The third (optional) argument selects tests within the specificed set of tests

# Examples

# "./unittests.sh math11.0" will run all the tests on Mathematica 11.0
# "./unittests.sh math10.4" Shared will run only tests from Shared.mt on Mathematica 10.4

set -o pipefail
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

$1 -nopromt -script TestSuite.m -run testType=1 -run onlyTest=\"$2\"  -run onlySubTest=\"$3\"

# If we have notify-send installed, generate a notification once the test run finishes.
if [ -x "$(command -v notify-send)" ]; then
  if [ -z "$2" ]; then
    outtxt="Finished running unit tests for CANONICA."
    else
    outtxt="Finished running unit tests for CANONICA ($2)."
  fi
  notify-send --urgency=low -i "$([ $? = 0 ] && echo sunny || echo error)" "$outtxt"
fi
