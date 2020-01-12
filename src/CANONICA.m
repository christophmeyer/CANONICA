(* ::Package:: *)

(* CANONICA 1.0                                                                *)
(* Transformation of multi-loop Feynman integrals to a canonical basis         *)
(*                                                                             *)
(* Copyright (C) 2017 Christoph Meyer                                          *)
(*                                                                             *)
(*     This program is free software: you can redistribute it and/or modify    *)
(*     it under the terms of the GNU General Public License as published by    *)
(*     the Free Software Foundation, either version 3 of the License, or       *)
(*     (at your option) any later version.                                     *)
(*                                                                             *)
(*     This program is distributed in the hope that it will be useful,         *)
(*     but WITHOUT ANY WARRANTY; without even the implied warranty of          *)
(*     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the           *)
(*     GNU General Public License for more details.                            *)
(*                                                                             *)
(*     You should have received a copy of the GNU General Public License       *)
(*     along with this program.  If not, see <http://www.gnu.org/licenses/>.   *)
(*                                                                             *)
(* To contact the author, please write to                                      *)
(*     christoph.meyer@physik.hu-berlin.de                                     *)
(*                                                                             *)
(* For the latest version, please check the github repository                  *)
(*     https://github.com/christophmeyer/CANONICA                              *)

BeginPackage["CANONICA`"]

Print["CANONICA 1.0"];
Print["Author: Christoph Meyer"];


(*         Usage messages of global variables and protected symbols            *)


$ComputeParallel::usage =
"Global variable that needs to be set to \!\(\*StyleBox[\"True\", \"TI\"]\) to \
enable parallel computations. The number of kernels to be used is controlled by \
\!\(\*StyleBox[\"$NParallelKernels\", \"TI\"]\).";


$NParallelKernels::usage =
"Global variable that sets the number of parallel kernels to be used. Has no \
effect if \!\(\*StyleBox[\"$ComputeParallel\", \"TI\"]\) is not set to \
\!\(\*StyleBox[\"True\", \"TI\"]\). If \!\(\*StyleBox[\"$ComputeParallel\", \
\"TI\"]\) is \!\(\*StyleBox[\"True\", \"TI\"]\) and \
\!\(\*StyleBox[\"$NParallelKernels\", \"TI\"]\) is not assigned a value, then \
all available kernels are used for the computation.";


eps::usage =
"Protected symbol used to represent the dimensional regulator.";
Protect[eps];


(*                   Usage messages of public functions                       *)


CalculateDlogForm::usage =
"\!\(\*RowBox[{\"CalculateDlogForm\", \"[\", RowBox[{StyleBox[\"a\", \"TI\"], \
\",\", StyleBox[\"invariants\", \"TI\"], \",\", StyleBox[\"alphabet\", \
\"TI\"]}], \"]\"}]\) returns a list of matrices of the same dimensions as \
\!\(\*StyleBox[\"a\", \"TI\"]\), where each matrix is the matrix-residue of one \
of the letters. The ordering is the same as the one in \
\!\(\*StyleBox[\"alphabet\", \"TI\"]\). Returns \!\(\*StyleBox[\"False\", \
\"TI\"]\) if \!\(\*StyleBox[\"a\", \"TI\"]\) can not be cast in a dlog-form \
with the given \!\(\*StyleBox[\"alphabet\", \"TI\"]\).";


CalculateNexta::usage =
"\!\(\*RowBox[{\"CalculateNexta\", \"[\", RowBox[{StyleBox[\"aFull\", \"TI\"], \
\",\", StyleBox[\"invariants\", \"TI\"], \",\", StyleBox[\"sectorBoundaries\", \
\"TI\"], \",\", StyleBox[\"trafoPrevious\", \"TI\"], \",\", \
StyleBox[\"aPrevious\", \"TI\"]}], \"]\"}]\) applies \
\!\(\*StyleBox[\"trafoPrevious\", \"TI\"]\) to \!\(\*StyleBox[\"aFull\", \
\"TI\"]\) and returns the differential equation of the next sector. \
\!\(\*StyleBox[\"aPrevious\", \"TI\"]\) is used to recycle the transformation \
of lower sectors.";


CalculateNextSubsectorD::usage =
"\!\(\*RowBox[{\"CalculateNextSubsectorD\", \"[\", RowBox[{StyleBox[\"a\", \
\"TI\"], \",\", StyleBox[\"invariants\", \"TI\"], \",\", \
StyleBox[\"sectorBoundaries\", \"TI\"], \",\", StyleBox[\"previousD\", \
\"TI\"]}], \"]\"}]\) computes the \!\(\*SubscriptBox[\nStyleBox[\"D\", \"TI\"], \
\nStyleBox[\"k\", \"TI\"]]\) of the next sector, prepends it to \
\!\(\*StyleBox[\"previousD\", \"TI\"]\) and returns the result. The ansatz to \
be used can be specified with the optional argument \
\!\(\*StyleBox[\"userProvidedAnsatz\", \"TI\"]\). If no ansatz is provided, an \
ansatz is generated automatically. The size of the automatically generated \
ansatz can be controlled with the option \
\!\(\*StyleBox[\"DDeltaNumeratorDegree\", \"TI\"]\).";


CheckDlogForm::usage =
"\!\(\*RowBox[{\"CheckDlogForm\", \"[\", RowBox[{StyleBox[\"a\", \"TI\"], \
\",\", StyleBox[\"invariants\", \"TI\"], \",\", StyleBox[\"alphabet\", \
\"TI\"]}], \"]\"}]\) tests whether the differential equation \
\!\(\*StyleBox[\"a\", \"TI\"]\) is in dlog-form for the given \
\!\(\*StyleBox[\"alphabet\", \"TI\"]\). Returns either \!\(\*StyleBox[\"True\", \
\"TI\"]\) or \!\(\*StyleBox[\"False\", \"TI\"]\).";


CheckEpsForm::usage =
"\!\(\*RowBox[{\"CheckEpsForm\", \"[\", RowBox[{StyleBox[\"a\", \"TI\"], \",\", \
StyleBox[\"invariants\", \"TI\"], \",\", StyleBox[\"alphabet\", \"TI\"]}], \
\"]\"}]\) tests whether the differential equation \!\(\*StyleBox[\"a\", \
\"TI\"]\) is in epsilon-form with the given \!\(\*StyleBox[\"alphabet\", \
\"TI\"]\). Returns either \!\(\*StyleBox[\"True\", \"TI\"]\) or \
\!\(\*StyleBox[\"False\", \"TI\"]\).";


CheckIntegrability::usage =
"\!\(\*RowBox[{\"CheckIntegrability\", \"[\", RowBox[{StyleBox[\"a\", \"TI\"], \
\",\", StyleBox[\"invariants\", \"TI\"]}], \"]\"}]\) tests whether \
\!\(\*StyleBox[\"a\", \"TI\"]\) satisfies the integrability condition \
\!\(\*StyleBox[\"d\", \"TI\"]\)\!\(\*StyleBox[\"a\", \
\"TI\"]\)\!\(\*StyleBox[\"-\", \"TI\"]\)\!\(\*StyleBox[\"a\", \
\"TI\"]\)\!\(\*StyleBox[\" \[And] \", \"TI\"]\)\!\(\*StyleBox[\"a\", \
\"TI\"]\)\!\(\*StyleBox[\" = \", \"TI\"]\)\!\(\*StyleBox[\"0\", \"TI\"]\) and \
returns either \!\(\*StyleBox[\"True\", \"TI\"]\) or \!\(\*StyleBox[\"False\", \
\"TI\"]\).";


CheckSectorBoundaries::usage =
"\!\(\*RowBox[{\"CheckSectorBoundaries\", \"[\", RowBox[{StyleBox[\"a\", \
\"TI\"], \",\", StyleBox[\"sectorBoundaries\", \"TI\"]}], \"]\"}]\) tests \
whether the \!\(\*StyleBox[\"sectorBoundaries\", \"TI\"]\) are compatible with \
\!\(\*StyleBox[\"a\", \"TI\"]\) and returns either \!\(\*StyleBox[\"True\", \
\"TI\"]\) or \!\(\*StyleBox[\"False\", \"TI\"]\).";


ExtractDiagonalBlock::usage =
"\!\(\*RowBox[{\"ExtractDiagonalBlock\", \"[\", RowBox[{StyleBox[\"a\", \
\"TI\"], \",\", StyleBox[\"boundaries\", \"TI\"]}], \"]\"}]\) returns the \
diagonal block of the differential equation \!\(\*StyleBox[\"a\", \"TI\"]\) \
specified by the \!\(\*StyleBox[\"boundaries\", \"TI\"]\) argument. \
\!\(\*StyleBox[\"boundaries\", \"TI\"]\) is expected to be of the format \
\!\(\*StyleBox[\"{nLowest, nHighest}\", \"TI\"]\), where \
\!\(\*StyleBox[\"nLowest\", \"TI\"]\) and \!\(\*StyleBox[\"nHighest\", \
\"TI\"]\) are positive integers indicating the lowest and highest integrals of \
the diagonal block respectively.";


ExtractIrreducibles::usage =
"\!\(\*RowBox[{\"ExtractIrreducibles\", \"[\", RowBox[{StyleBox[\"a\", \
\"TI\"]}], \"]\"}]\) returns the irreducible denominator factors of \
\!\(\*StyleBox[\"a\", \"TI\"]\) that do not depend on the regulator. The option \
\!\(\*StyleBox[\"AllowEpsDependence->True\", \"TI\"]\) allows the irreducible \
factors to depend on both the invariants and the regulator.";


FindAnsatzSubsectorD::usage =
"\!\(\*RowBox[{\"FindAnsatzSubsectorD\", \"[\", RowBox[{StyleBox[\"a\", \
\"TI\"], \",\", StyleBox[\"invariants\", \"TI\"], \",\", \
StyleBox[\"sectorBoundaries\", \"TI\"], \",\", StyleBox[\"previousD\", \
\"TI\"]}], \"]\"}]\) takes a differential equation \!\(\*StyleBox[\"a\", \
\"TI\"]\), which is required to be in epsilon-form except for the off-diagonal \
block of the highest sector. Needs to be provided with all previous \
\!\(\*SubscriptBox[\nStyleBox[\"D\", \"TI\"], \nStyleBox[\"k\", \"TI\"]]\) in \
the argument \!\(\*StyleBox[\"previousD\", \"TI\"]\) and computes the ansatz \
\!\(\*SubscriptBox[\nStyleBox[\"R\", \"TI\"], \nStyleBox[\"D\", \"TI\"]]\) for \
the computation of the next \!\(\*SubscriptBox[\nStyleBox[\"D\", \"TI\"], \
\nStyleBox[\"k\", \"TI\"]]\). Takes the option \
\!\(\*StyleBox[\"DDeltaNumeratorDegree\", \"TI\"]\) to enlarge the ansatz. For \
more details see the accompanying paper.";


FindAnsatzT::usage =
"\!\(\*RowBox[{\"FindAnsatzT\", \"[\", RowBox[{StyleBox[\"a\", \"TI\"], \",\", \
StyleBox[\"invariants\", \"TI\"]}], \"]\"}]\) takes a differential equation \
\!\(\*StyleBox[\"a\", \"TI\"]\) in the \!\(\*StyleBox[\"invariants\", \"TI\"]\) \
and computes an ansatz \!\(\*SubscriptBox[\nStyleBox[\"R\", \"TI\"], \
\nStyleBox[\"T\", \"TI\"]]\) as described in the accompanying paper. The ansatz \
can be enlarged with the options \!\(\*StyleBox[\"TDeltaNumeratorDegree\", \
\"TI\"]\) and \!\(\*StyleBox[\"TDeltaDenominatorDegree\", \"TI\"]\).";


FindConstantNormalization::usage =
"\!\(\*RowBox[{\"FindConstantNormalization\", \"[\", \
RowBox[{StyleBox[\"invariants\", \"TI\"], \",\", StyleBox[\"trafoPrevious\", \
\"TI\"], \",\", StyleBox[\"aPrevious\", \"TI\"]}], \"]\"}]\) calculates a \
constant diagonal transformation to minimize the number of prime factors \
present in the matrix-residues. The transformation is composed with \
\!\(\*StyleBox[\"trafoPrevious\", \"TI\"]\) and returned together with the \
resulting differential equation.";


FindEpsDependentNormalization::usage =
"\!\(\*RowBox[{\"FindEpsDependentNormalization\", \"[\", \
RowBox[{StyleBox[\"a\", \"TI\"], \",\", StyleBox[\"invariants\", \"TI\"]}], \
\"]\"}]\) calculates a diagonal transformation depending only on the \
dimensional regulator in order to attempt to minimize the number of orders that \
need to be calculated in a subsequent determination of the transformation to a \
canonical form. Returns the transformation together with the resulting \
differential equation.";


RecursivelyTransformSectors::usage =
"\!\(\*RowBox[{\"RecursivelyTransformSectors\", \"[\", \
RowBox[{StyleBox[\"aFull\", \"TI\"], \",\", StyleBox[\"invariants\", \"TI\"], \
\",\", StyleBox[\"sectorBoundaries\", \"TI\"], \",\", \
StyleBox[\"{nSecStart,nSecStop}\", \"TI\"]}], \"]\"}]\) calculates a rational \
transformation of \!\(\*StyleBox[\"aFull\", \"TI\"]\) to canonical form in a \
recursion over the sectors of the differential equation, which have to be \
specified by \!\(\*StyleBox[\"sectorBoundaries\", \"TI\"]\). The arguments \
\!\(\*StyleBox[\"nSecStart\", \"TI\"]\) and \!\(\*StyleBox[\"nSecStop\", \
\"TI\"]\) set the first and the last sector to be computed respectively. If \
\!\(\*StyleBox[\"nSecStart\", \"TI\"]\) is greater than one, the result of the \
calculation for the sectors lower than \!\(\*StyleBox[\"nSecStart\", \"TI\"]\) \
needs to be provided in the additional arguments \
\!\(\*StyleBox[\"trafoPrevious\", \"TI\"]\) and \!\(\*StyleBox[\"aPrevious\", \
\"TI\"]\). \!\(\*StyleBox[\"RecursivelyTransformSectors\", \"TI\"]\) returns \
the transformation of \!\(\*StyleBox[\"aFull\", \"TI\"]\) to a canonical form \
for the sectors up to \!\(\*StyleBox[\"nSecStop\", \"TI\"]\) and the resulting \
differential equation. The ansaetze for the individual blocks are generated \
automatically. The sizes of the ansaetze for the diagonal blocks can be \
controlled with the options \!\(\*StyleBox[\"TDeltaNumeratorDegree\", \"TI\"]\) \
and \!\(\*StyleBox[\"TDeltaDenominatorDegree\", \"TI\"]\). Similarly, the sizes \
of the ansaetze for the off-diagonal blocks are controlled by the option \
\!\(\*StyleBox[\"DDeltaNumeratorDegree\", \"TI\"]\).";


SectorBoundariesFromDE::usage =
"\!\(\*RowBox[{\"SectorBoundariesFromDE\", \"[\", RowBox[{StyleBox[\"a\", \
\"TI\"]}], \"]\"}]\) returns the most fine grained sector boundaries compatible \
with \!\(\*StyleBox[\"a\", \"TI\"]\).";


SectorBoundariesFromID::usage =
"\!\(\*RowBox[{\"SectorBoundariesFromID\", \"[\", \
RowBox[{StyleBox[\"masterIntegrals\", \"TI\"]}], \"]\"}]\) takes a list of \
\!\(\*StyleBox[\"masterIntegrals\", \"TI\"]\), which need to be ordered by \
their sector-id and returns the sector boundaries computed from the \
sector-ids.";


TransformDE::usage =
"\!\(\*RowBox[{\"TransformDE\", \"[\", RowBox[{StyleBox[\"a\", \"TI\"], \",\", \
StyleBox[\"invariants\", \"TI\"], \",\", StyleBox[\"t\", \"TI\"]}], \"]\"}]\) \
applies the transformation \!\(\*StyleBox[\"t\", \"TI\"]\) to the differential \
equation \!\(\*StyleBox[\"a\", \"TI\"]\). Returns \
\!\(\*SuperscriptBox[\nStyleBox[\"a\", \"TI\"], \nStyleBox[\"\[Prime]\", \
\"TI\"]]\)\!\(\*StyleBox[\"=\", \"TI\"]\)\!\(\*SuperscriptBox[\nStyleBox[\"t\", \
\"TI\"], \nStyleBox[\"-1\", \"TI\"]]\)\!\(\*StyleBox[\"a\", \
\"TI\"]\)\!\(\*StyleBox[\"t\", \"TI\"]\)\!\(\*StyleBox[\"-\", \
\"TI\"]\)\!\(\*SuperscriptBox[\nStyleBox[\"t\", \"TI\"], \nStyleBox[\"-1\", \
\"TI\"]]\)\!\(\*StyleBox[\"d\", \"TI\"]\)\!\(\*StyleBox[\"t\", \"TI\"]\). The \
option \!\(\*StyleBox[\"SimplifyResult->False\", \"TI\"]\) deactivates the \
simplification of the result.";


TransformDiagonalBlock::usage =
"\!\(\*RowBox[{\"TransformDiagonalBlock\", \"[\", RowBox[{StyleBox[\"a\", \
\"TI\"], \",\", StyleBox[\"invariants\", \"TI\"]}], \"]\"}]\) calculates a \
rational transformation to transform \!\(\*StyleBox[\"a\", \"TI\"]\) into \
canonical form and returns the transformation together with the resulting \
differential equation. With the optional argument \
\!\(\*StyleBox[\"userProvidedAnsatz\", \"TI\"]\), the user can specify the \
ansatz to be used. If no ansatz is provided, an ansatz is generated \
automatically. The size of the automatically generated ansatz can be controlled \
with the options \!\(\*StyleBox[\"TDeltaNumeratorDegree\", \"TI\"]\) and \
\!\(\*StyleBox[\"TDeltaDenominatorDegree\", \"TI\"]\).";


TransformDlogToEpsForm::usage =
"\!\(\*RowBox[{\"TransformDlogToEpsForm\", \"[\", \
RowBox[{StyleBox[\"invariants\", \"TI\"], \",\", StyleBox[\"sectorBoundaries\", \
\"TI\"], \",\", StyleBox[\"trafoPrevious\", \"TI\"], \",\", \
StyleBox[\"aPrevious\", \"TI\"]}], \"]\"}]\) computes a transformation \
depending only on the regulator in order to transform \
\!\(\*StyleBox[\"aPrevious\", \"TI\"]\) from dlog-form into canonical form (cf. \
arXiv:1411.0911). The transformation is composed with \
\!\(\*StyleBox[\"trafoPrevious\", \"TI\"]\) and returned together with the \
resulting differential equation. Per default, the transformation is demanded to \
be in a block-triangular form induced by \!\(\*StyleBox[\"sectorBoundaries\", \
\"TI\"]\). This condition can be dropped with the option \
\!\(\*StyleBox[\"EnforceBlockTriangular->False\", \"TI\"]\).";


TransformNextDiagonalBlock::usage =
"\!\(\*RowBox[{\"TransformNextDiagonalBlock\", \"[\", \
RowBox[{StyleBox[\"aFull\", \"TI\"], \",\", StyleBox[\"invariants\", \"TI\"], \
\",\", StyleBox[\"sectorBoundaries\", \"TI\"], \",\", \
StyleBox[\"trafoPrevious\", \"TI\"], \",\", StyleBox[\"aPrevious\", \"TI\"]}], \
\"]\"}]\) calls \!\(\*StyleBox[\"TransformDiagonalBlock\", \"TI\"]\) to compute \
the transformation of the next diagonal block into canonical form and composes \
it with \!\(\*StyleBox[\"trafoPrevious\", \"TI\"]\). Returns the composed \
transformation together with the resulting differential equation. With the \
optional argument \!\(\*StyleBox[\"userProvidedAnsatz\", \"TI\"]\), the user \
can specify the ansatz to be used. If no ansatz is provided, an ansatz is \
generated automatically. The size of the automatically generated ansatz can be \
controlled with the options \!\(\*StyleBox[\"TDeltaNumeratorDegree\", \"TI\"]\) \
and \!\(\*StyleBox[\"TDeltaDenominatorDegree\", \"TI\"]\).";


TransformNextSector::usage =
"\!\(\*RowBox[{\"TransformNextSector\", \"[\", RowBox[{StyleBox[\"aFull\", \
\"TI\"], \",\", StyleBox[\"invariants\", \"TI\"], \",\", \
StyleBox[\"sectorBoundaries\", \"TI\"], \",\", StyleBox[\"trafoPrevious\", \
\"TI\"], \",\", StyleBox[\"aPrevious\", \"TI\"]}], \"]\"}]\) transforms the \
next sector into canonical form, composes the calculated transformation with \
\!\(\*StyleBox[\"trafoPrevious\", \"TI\"]\) and returns it together with the \
resulting differential equation. With the optional argument \
\!\(\*StyleBox[\"userProvidedAnsatz\", \"TI\"]\), the user can specify the \
ansatz to be used for the diagonal block. If no ansatz is provided, an ansatz \
is generated automatically. The size of the automatically generated ansatz for \
the diagonal block can be controlled with the options \
\!\(\*StyleBox[\"TDeltaNumeratorDegree\", \"TI\"]\) and \
\!\(\*StyleBox[\"TDeltaDenominatorDegree\", \"TI\"]\). Similarly, the sizes of \
the ansaetze for the off-diagonal blocks are controlled by the option \
\!\(\*StyleBox[\"DDeltaNumeratorDegree\", \"TI\"]\).";


TransformOffDiagonalBlock::usage =
"\!\(\*RowBox[{\"TransformOffDiagonalBlock\", \"[\", \
RowBox[{StyleBox[\"invariants\", \"TI\"], \",\", StyleBox[\"sectorBoundaries\", \
\"TI\"], \",\", StyleBox[\"trafoPrevious\", \"TI\"], \",\", \
StyleBox[\"aPrevious\", \"TI\"]}], \"]\"}]\) assumes \
\!\(\*StyleBox[\"aPrevious\", \"TI\"]\) to be in canonical form except for the \
highest sector of which only the diagonal block is assumed to be in canonical \
form. Computes a transformation to transform the off-diagonal block of the \
highest sector into dlog-form. This transformation is composed with \
\!\(\*StyleBox[\"trafoPrevious\", \"TI\"]\) and returned together with the \
resulting differential equation. Proceeds in a recursion over sectors, which \
can be resumed at an intermediate step by providing all previous \
\!\(\*SubscriptBox[\nStyleBox[\"D\", \"TI\"], \nStyleBox[\"k\", \"TI\"]]\) (cf. \
arXiv:1611.01087) in the optional argument \!\(\*StyleBox[\"userProvidedD\", \
\"TI\"]\). The sizes of the automatically generated ansaetze for the \
off-diagonal blocks are controlled by the option \
\!\(\*StyleBox[\"DDeltaNumeratorDegree\", \"TI\"]\).";


(*           Usage messages of public options of public functions              *)


AllowEpsDependence::usage =
"Option of \!\(\*StyleBox[\"ExtractIrreducibles\", \"TI\"]\) controlling \
whether irreducible factors depending on both the invariants and the regulator \
are returned as well. The default value is \!\(\*StyleBox[\"False\", \
\"TI\"]\).";


DDeltaNumeratorDegree::usage =
"Option that controls the numerator powers of the rational functions in the \
ansatz used for the computation of D for the transformation of off-diagonal \
blocks. The default value is 0. For more details see the accompanying paper. \
\!\(\*StyleBox[\"DDeltaNumeratorDegree\", \"TI\"]\) is an option of the \
following functions: \!\(\*StyleBox[\"CalculateNextSubsectorD\", \"TI\"]\), \
\!\(\*StyleBox[\"FindAnsatzSubsectorD\", \"TI\"]\), \
\!\(\*StyleBox[\"RecursivelyTransformSectors\", \"TI\"]\), \
\!\(\*StyleBox[\"TransformNextSector\", \"TI\"]\), \
\!\(\*StyleBox[\"TransformOffDiagonalBlock\", \"TI\"]\).";


EnforceBlockTriangular::usage =
"Option of \!\(\*StyleBox[\"TransformDlogToEpsForm\", \"TI\"]\) controlling \
whether the resulting transformation is demanded to be in the block-triangular \
form induced by the \!\(\*StyleBox[\"sectorBoundaries\", \"TI\"]\) argument. \
The default value is \!\(\*StyleBox[\"True\", \"TI\"]\).";


FinalConstantNormalization::usage =
"Option of \!\(\*StyleBox[\"RecursivelyTransformSectors\", \"TI\"]\) \
controlling whether \!\(\*StyleBox[\"FindConstantNormalization\", \"TI\"]\) is \
invoked after all sectors have been transformed into canonical form in order to \
simplify the resulting canonical form. The default value is \
\!\(\*StyleBox[\"False\", \"TI\"]\).";


PreRescale::usage =
"Option of \!\(\*StyleBox[\"TransformDiagonalBlock\", \"TI\"]\) controlling \
whether \!\(\*StyleBox[\"FindEpsDependentNormalization\", \"TI\"]\) is called \
prior to the main computation in order to attempt to minimize the number of \
orders that need to be calculated in a subsequent determination of the \
transformation to a canonical form. The default value is \
\!\(\*StyleBox[\"True\", \"TI\"]\).";


SimplifyResult::usage =
"Option of \!\(\*
StyleBox[\"TransformDE\", \"TI\"]\) controlling whether the resulting \
differential equation is simplified. The default value is \!\(\*
StyleBox[\"True\", \"TI\"]\).";


TDeltaDenominatorDegree::usage =
"Option that controls the denominator powers of the rational functions in the \
ansatz used for the computation of the transformation of diagonal blocks. The \
default value is 0. For more details see the accompanying paper. \
\!\(\*StyleBox[\"TDeltaDenominatorDegree\", \"TI\"]\) is an option of the \
following functions: \!\(\*StyleBox[\"FindAnsatzT\", \"TI\"]\), \
\!\(\*StyleBox[\"RecursivelyTransformSectors\", \"TI\"]\), \
\!\(\*StyleBox[\"TransformNextDiagonalBlock\", \"TI\"]\), \
\!\(\*StyleBox[\"TransformNextSector\", \"TI\"]\).";


TDeltaNumeratorDegree::usage =
"Option that controls the numerator powers of the rational functions in the \
ansatz used for the computation of the transformation of diagonal blocks. The \
default value is 0. For more details see the accompanying paper. \
\!\(\*StyleBox[\"TDeltaNumeratorDegree\", \"TI\"]\) is an option of the \
following functions: \!\(\*StyleBox[\"FindAnsatzT\", \"TI\"]\), \
\!\(\*StyleBox[\"RecursivelyTransformSectors\", \"TI\"]\), \
\!\(\*StyleBox[\"TransformNextDiagonalBlock\", \"TI\"]\), \
\!\(\*StyleBox[\"TransformNextSector\", \"TI\"]\).";


VerbosityLevel::usage =
"Option that controls the verbosity of several main functions. Takes integer \
values from 0 to 12 with a value of 12 resulting in the most detailed output \
about the current state of the computation and a value of 0 suppressing all \
output but warnings about inconsistent inputs. The default value is 10. The \
following functions accept the \!\(\*StyleBox[\"VerbosityLevel\", \"TI\"]\) \
option: \!\(\*StyleBox[\"CalculateNextSubsectorD\", \"TI\"]\), \
\!\(\*StyleBox[\"FindConstantNormalization\", \"TI\"]\), \
\!\(\*StyleBox[\"RecursivelyTransformSectors\", \"TI\"]\), \
\!\(\*StyleBox[\"TransformDiagonalBlock\", \"TI\"]\), \
\!\(\*StyleBox[\"TransformDlogToEpsForm\", \"TI\"]\), \
\!\(\*StyleBox[\"TransformNextDiagonalBlock\", \"TI\"]\), \
\!\(\*StyleBox[\"TransformNextSector\", \"TI\"]\), \
\!\(\*StyleBox[\"TransformOffDiagonalBlock\", \"TI\"]\).";


(*                     Public options of public functions                      *)


Options[CalculateNextSubsectorD] = {DDeltaNumeratorDegree -> 0,
VerbosityLevel -> 10};


Options[ExtractIrreducibles] = {AllowEpsDependence -> False};


Options[FindAnsatzT] = {TDeltaDenominatorDegree -> 0,
TDeltaNumeratorDegree -> 0};


Options[FindAnsatzSubsectorD] = {DDeltaNumeratorDegree -> 0};


Options[FindConstantNormalization] = {VerbosityLevel -> 10};


Options[RecursivelyTransformSectors] = {DDeltaNumeratorDegree -> 0,
TDeltaDenominatorDegree -> 0, TDeltaNumeratorDegree -> 0,
FinalConstantNormalization -> False, VerbosityLevel -> 10};


Options[TransformDE] = {SimplifyResult -> True};


Options[TransformDiagonalBlock] = {PreRescale -> True,
TDeltaDenominatorDegree -> 0, TDeltaNumeratorDegree -> 0,
VerbosityLevel -> 10};


Options[TransformDlogToEpsForm] = {EnforceBlockTriangular -> True,
VerbosityLevel -> 10};


Options[TransformNextDiagonalBlock] = {TDeltaDenominatorDegree -> 0,
TDeltaNumeratorDegree -> 0, VerbosityLevel -> 10};


Options[TransformNextSector] = {DDeltaNumeratorDegree -> 0,
TDeltaDenominatorDegree -> 0, TDeltaNumeratorDegree -> 0,
VerbosityLevel -> 10};


Options[TransformOffDiagonalBlock] = {DDeltaNumeratorDegree -> 0,
VerbosityLevel -> 10};


Begin["`Private`"]


$RandomSeed = 42;


(*                      Options of private functions                           *)


Options[AlgebraicallyIndepQ] = {ShowAnnihilatingPoly -> False};


Options[BreakToIndepSummands] = {Form -> Raw};


Options[CalcAnsatzD] = {DDeltaDenominatorDegree -> 0,
DDeltaNumeratorDegree -> 0};


Options[CalcNegPowerPossibilities] = {DDeltaDenominatorDegree->0};


Options[CalcNextDn] = {VerbosityLevel -> 10};


Options[CalcNextTn] = {VerbosityLevel -> 10};


Options[CheckDE] = {EnforceSquare -> True};


Options[DenominatorFactors] = {ShowPowersAndPrefactor -> False};


Options[ExprPropLetterQ] = {ShowLetter -> False};


Options[FindD] = {DDeltaDenominatorDegree -> 0,
DDeltaNumeratorDegree -> 0, VerbosityLevel -> 10};


(* Undocumented options of public functions *)


AppendTo[Options[CalculateNextSubsectorD],
DDeltaDenominatorDegree -> 0];


Options[CheckIntegrability] = {ShowRelations -> False};


AppendTo[Options[FindAnsatzSubsectorD], DDeltaDenominatorDegree -> 0];


AppendTo[Options[RecursivelyTransformSectors],
DDeltaDenominatorDegree -> 0];


AppendTo[Options[TransformNextSector], DDeltaDenominatorDegree -> 0];


AppendTo[Options[TransformOffDiagonalBlock],
DDeltaDenominatorDegree -> 0];


(*                                Messages                                     *)


CalcAnsatzD::nintnum =
"DDeltaNumeratorDegree needs to be a non-negative integer.";
CalcAnsatzD::nintden =
"DDeltaDenominatorDegree needs to be a non-negative integer.";


CalculateDlogForm::incalphabet =
"Alphabet does not contain all irreducible denominator factors \
present in the differential equation.";


CalculateNexta::mismatch1 =
"trafoPrevious and aPrevious must have the same dimension.";
CalculateNexta::mismatch2 =
"Size of trafoPrevious must correspond to a full sector.";
CalculateNexta::mismatch3 = "Next sector exceeds size of aFull.";
CalculateNexta::nonerem = "There is no further sector left.";
CalculateNexta::notsquare =
"trafoPrevious has to be a square matrix.";


CalculateNextSubsectorD::nosol =
"No solution found, try different ansatz.";


CheckAlphabet::notinv =
"List of invariants does not contain all variables present in the \
alphabet.";
CheckAlphabet::notpoly =
"Alphabet must contain polynomials in the invariants.";


CheckBoundariesConsistency::falsebounds =
"Invalid sector boundaries.";


CheckDE::notsquare =
"Differential equation contains non-square matrices.";
CheckDE::diffdims =
"Differential equation is not in the right format.";
CheckDE::fewvars =
"Differential equation contains invariants that are not specified \
in the invariants argument.";
CheckDE::varnumber =
"Length of differential equation list does not match the number of \
invariants.";
CheckDE::nonull = "Differential equation contains Null elements.";


ExtractDiagonalBlock::badbounds = "Invalid boundaries.";


FindAnsatzT::nintnum =
"TDeltaNumeratorDegree needs to be a non-negative integer.";
FindAnsatzT::nintden =
"TDeltaDenominatorDegree needs to be a non-negative integer.";
FindAnsatzT::ndlogtr =
"Tr[a] is not in dlog-form, epsilon form does not exist.";


FindConstantNormalization::baddims =
"Dimensions of trafoPrevious and aPrevious do not match.";
FindConstantNormalization::ndlog =
"aPrevious is not in epsilon-form.";


FindD::invansatz =
"Provided ansatz is not rational in the invariants.";


NextEquationD::baddims1 =
"Size of differential equation does not match a sector boundary.";
NextEquationD::baddims2 =
"Length of previousD does not match the size of the diagonal block.";
NextEquationD::baddims3 =
"Dimensions of previousD do not match a sector boundary.";


RecursivelyTransformSectors::badrange =
"Invalid range, nSecStart must be smaller or equal to nSecStop.";
RecursivelyTransformSectors::badbounds1 =
"Invalid boundaries, sectorBoundaries must contain at least \
nSecStop entries.";
RecursivelyTransformSectors::badbounds2 =
"Invalid boundaries, size of highest sector in range exceeds size \
of aFull.";
RecursivelyTransformSectors::baddims =
"Dimensions of trafoPrevious or aPrevious are inconsistent with \
nSecStart.";


SectorBoundariesFromID::noorder =
"List of master integrals is not ordered by sector-id.";


TransformDE::notinv = "Tranformation is not invertible.";
TransformDE::mismatch =
"Dimensions of differential equation and transformation do not \
match.";


TransformDiagonalBlock::noepsform =
"Canonical form does not exist, since Tr[a] is not of the necessary \
form.";
TransformDiagonalBlock::nonrationaltr =
"Algorithm not applicable: rational transformation does not \
exist.";
TransformDiagonalBlock::nonrational =
"Differential equation is not rational in the invariants and the \
regulator.";
TransformDiagonalBlock::invansatz = "Provided ansatz is not rational \
in the invariants.";


TransformDlogToEpsForm::notdlog =
"Differential equation is not in dlog-form.";


TransformOffDiagonalBlock::baddims1 =
"Dimensions of trafoPrevious and aPrevious do not match.";
TransformOffDiagonalBlock::baddims2 =
"Length of aPrevious does not correspond to a sector boundary.";
TransformOffDiagonalBlock::baddims3 =
"Length of userProvidedD does not match the size of the diagonal \
block.";
TransformOffDiagonalBlock::baddims4 =
"Dimensions of userProvidedD do not match a sector boundary.";


(*                             Function definitions                            *)


AlgebraicallyIndepQ[polyList_List, invariants_List,
OptionsPattern[]] :=
	Module[ {annihilatingPoly},
		annihilatingPoly =
			GroebnerBasis[MapIndexed[Y[#2[[1]]] - # &, polyList],
			Join[invariants, Table[Y[i], {i, 1, Length[polyList]}]],
			invariants];
		If[ OptionValue[ShowAnnihilatingPoly],
			Return[{annihilatingPoly === {}, annihilatingPoly}];,
			Return[annihilatingPoly === {}];
		]
	];


ApplyRelations[termList_List, alphabet_List, invariants_List] :=
	Module[ {},
		SeedRandom[$RandomSeed];
		Return[
			Times @@ (#[[2]] /.
				Fac[nLetter_, pow_] :> Power[alphabet[[nLetter]], pow]) & /@
			FindAndApplyRelations[alphabet, invariants,
			Map[{RandomReal[{0, 1},
				WorkingPrecision -> MachinePrecision], #[[2]]} &,
			Flatten[ToIndepFactorForm[#, alphabet, invariants] & /@
				termList, 1]], {}]];
	];


BreakToIndepSummands[fullExpr_, alphabet_, invariants_,
preferredTerms_, OptionsPattern[]] :=
	Module[ {indepFactorForm, rawForm},
		indepFactorForm =
			Function[rawExpr,
			FindAndApplyRelations[alphabet, invariants,
			GatherCommonTerms[
				FixedPoint[
				Function[expr,
				Flatten[(SplitNumerator[#1, alphabet, invariants] &) /@
					GatherByDenominator[expr], 1]],
				ToIndepFactorForm[rawExpr, alphabet, invariants]]],
			preferredTerms]][fullExpr];
		If[ OptionValue[Form] === IndepFactor,
			Return[indepFactorForm];,
			rawForm =
			Map[{#[[1]], Times @@ #[[2]]} &,
			indepFactorForm /.
			Fac[Letter_, Pow_] :> Power[alphabet[[Letter]], Pow]];
			Return[rawForm];
		];
	];


CalcAnsatzD[e_List, c_List, b_List, invariants_List,
OptionsPattern[]] :=
	Module[ {alphabet, bhat, negPowersb, negPowerFactors,
		posPowerFactors, extAlphabet, dDeltaDenominatorDegreeVal,
		dfacInit, eDlog, cDlog, dfacInitLetters, combinedFactors},
		If[ ! (IntegerQ[OptionValue[DDeltaDenominatorDegree]] &&
			OptionValue[DDeltaDenominatorDegree] >= 0),
			Message[CalcAnsatzD::nintden];
			Return[False];
		];
		If[ ! (IntegerQ[OptionValue[DDeltaNumeratorDegree]] &&
			OptionValue[DDeltaNumeratorDegree] >= 0),
			Message[CalcAnsatzD::nintnum];
			Return[False];
		];
		alphabet = ExtractIrreducibles[Join[e, c, b]];
		bhat = CalcbhatAndFactors[b, alphabet, invariants][[1]];
		dDeltaDenominatorDegreeVal = OptionValue[DDeltaDenominatorDegree];
		dfacInit =
			Map[Function[expr,
			Function[list, Sort[list, #1[[2]] < #2[[2]] &][[1]]] /@
			GatherBy[Flatten[expr, 1], #1[[1]] &]],
			Transpose[
			Map[CalcOccuringDenLetters[alphabet, invariants, #1,
				dDeltaDenominatorDegreeVal] &, bhat, {3}], {3, 1, 2}], {2}];
		eDlog =
			Map[If[ # =!= 0,
					1,
					0
				] &,
			CalculateDlogForm[e, invariants, alphabet], {3}];
		cDlog =
			Map[If[ # =!= 0,
					1,
					0
				] &,
			CalculateDlogForm[c, invariants, alphabet], {3}];
		dfacInitLetters =
			Table[Map[Function[list, Select[list, #[[1]] === nLetter &]],
			dfacInit, {2}], {nLetter, 1, Length@alphabet}];
		negPowerFactors =
			Union[Flatten[
			Function[expr,
				CalcNegPowerPossibilities[alphabet, invariants, expr]] /@
			Flatten[MapThread[Union,
				FixedPoint[
				Function[expr, DissipateFactors[expr, eDlog, cDlog]],
				dfacInitLetters], 2], 1]]];
		posPowerFactors =
			Join[{1},
			Union[Apply[Times,
			Flatten[Table[
				Tuples[DeleteCases[Variables[Join[bhat, c, e]],
				eps], {nLetters}], {nLetters, 1,
				3 + OptionValue[DDeltaNumeratorDegree]}], 1], {1}]]];
		extAlphabet = Union[invariants, alphabet];
		combinedFactors =
			Union[(#[[2]] &) /@
			Flatten[ParallelizeMap[$ComputeParallel][
				BreakToIndepSummands[#, extAlphabet, invariants, {}] &,
				Simplify[
				Union[Flatten[
				Outer[Times, Union[{1}, negPowerFactors],
					Union[{1}, posPowerFactors]]]]]], 1]];
		Return[ApplyRelations[combinedFactors, extAlphabet, invariants]];
	];


CalcbhatAndFactors[b_List, alphabet_List, invariants_List] :=
	Module[ {occuringSpuriousFactors, hbar, epsDepFactors,
		occuringOverallFactors, overallFactor, khat, bhat},
		occuringSpuriousFactors =
			Union[Flatten[
			Function[liste,
				Select[liste, #[[2]] < 0 && !FreeQ[#[[1]] && #[[1]] =!= eps, eps] &]] /@
			FactorList /@ Flatten[b], 1],
			SameTest -> (NumberQ[
				Simplify[#1[[1]]/#2[[1]]]] && #1[[2]] == #2[[2]] &)];
		hbar =
			Times @@
			Apply[Power, ({#[[1]],
				If[ EvenQ[#[[2]]],
					-(#[[2]]/2),
					1/2 (-#[[2]] + 1)
				]} &) /@
			Function[factor,
				Sort[Select[
					Select[occuringSpuriousFactors, !IndependentOfInvariantsQ[#[[1]], invariants] &],
					NumberQ[
					Simplify[#1[[1]]/
						factor]] &], #1[[2]] > #2[[2]] &][[-1]]] /@
				Union[(#1[[1]] &) /@
				Select[occuringSpuriousFactors, !IndependentOfInvariantsQ[#[[1]], invariants] &],
				SameTest -> (NumberQ[Simplify[#1[[1]]/#2[[1]]]] &)], {1}];
		epsDepFactors =
			Function[term,
			Select[FactorList[
				term], #[[2]] > 0 &&
				IndependentOfInvariantsQ[#[[1]], invariants] && !NumberQ[#[[1]]] &]] /@ DeleteCases[Flatten[b], 0];
		occuringOverallFactors =
			Function[liste, Sort[liste, #2[[2]] > #1[[2]] &]] /@
			GatherBy[
			Union[Flatten[epsDepFactors, 1],
			SameTest -> (NumberQ[
					Simplify[#1[[1]]/#2[[1]]]] && #1[[2]] == #2[[2]] &)], \
		#[[1]] &];
		overallFactor =
			Times @@
			Power @@@
			MapIndexed[
			If[ #,
				occuringOverallFactors[[#2[[1]], 1]],
				{1, 0}
			] &,
			Map[Function[group,
				FreeQ[Map[Function[term, Intersection[group, term]],
				epsDepFactors], {}]], occuringOverallFactors]];
		khat =
			Times @@
			Apply[Power, {#[[1]], -#[[2]]} & /@
				Function[fac,
				Sort[Select[
					Select[occuringSpuriousFactors,
					IndependentOfInvariantsQ[#[[1]], invariants] &],
					NumberQ[
					Simplify[#1[[1]]/
						fac]] &], #1[[2]] > #2[[2]] &][[-1]]] /@
				Union[(#1[[1]] &) /@
				Select[occuringSpuriousFactors,
					IndependentOfInvariantsQ[#[[1]], invariants] &],
				SameTest -> (NumberQ[Simplify[#1/#2]] &)], {1}]/
			overallFactor;
		bhat =
			Map[Times @@ Apply[Power, #1, {1}] &,
			Map[FactorList, b*Power[hbar, 2]*khat, {3}], {3}];
		Return[{bhat, hbar, khat}];
	];


CalcInverse[trafo_List] :=
	Module[ {adjMatrix, list, revTrafo, preList, sectorBoundaries},
		adjMatrix =
			Map[Function[entries, If[ And @@ PossibleZeroQ /@ entries,
									0,
									1
								]],
			Transpose[{trafo}, {3, 1, 2}], {2}];
		list =
			Sort[MapIndexed[{Max[Flatten[Position[#, 1]]], #2[[1]]} &,
			adjMatrix], #1[[1]] < #2[[1]] &];
		revTrafo =
			ReplacePart[0*IdentityMatrix[Length@trafo[[1]]],
			MapIndexed[{#2[[1]], #} -> 1 &, #[[2]] & /@ list]];
		preList = MapIndexed[{#2[[1]], #[[1]]} &, list];
		sectorBoundaries =
			NestWhile[
			Function[
			Expr, {Append[
				Expr[[1]], {Expr[[2, 1, 1]],
				FirstCase[Expr[[2]], {___, True}][[1]]}],
				Drop[Expr[[2]],
				FirstCase[Expr[[2]], {___, True}][[1]] - Expr[[2, 1, 1]] +
				1]}], {{},
			Map[{#[[1]], #[[1]] === #[[2]]} &,
				preList]}, #[[2]] =!= {} &][[1]];
		Return[
			CalcInverseBlockTriangular[revTrafo.trafo,
			sectorBoundaries].revTrafo];
	];


CalcInverseBlockTriangular[trafo_List, sectorBoundaries_List] :=
	Module[ {prevSecInverse, prevSecTrafo},
		prevSecInverse =
			Inverse[ExtractDiagonalBlock[{trafo}, sectorBoundaries[[1]]][[1]]];
		prevSecTrafo =
			Simplify[
			InsertBlockIntoIdentity[prevSecInverse, Length@trafo, 1].trafo];
		Return[
			Nest[CalcInverseStep, {sectorBoundaries, prevSecInverse,
			prevSecTrafo}, Length@sectorBoundaries - 1][[2]]];
	];


CalcInverseStep[{sectorBoundaries_List, prevSecInverse_List,
	prevSecTrafo_List}] :=
	Module[ {prevSubSector, subSector, nextOffDiagonalBlock,
		nextDiagonalBlock, nextDiagonalBlockInv, nextInvStep,
		nextCurrentInv, nextTrafo},
		prevSubSector =
			Position[sectorBoundaries, Length@prevSecInverse][[1, 1]];
		If[ prevSubSector === Length@sectorBoundaries,
			Return[{prevSecInverse, prevSecTrafo}]
		];
		subSector = prevSubSector + 1;
		nextOffDiagonalBlock =
			Transpose[
			Take[Transpose[
			Take[prevSecTrafo, sectorBoundaries[[subSector]]]], {1,
			sectorBoundaries[[subSector]][[1]] - 1}]];
		nextDiagonalBlock =
			Transpose[
			Take[Transpose[
			Take[prevSecTrafo, sectorBoundaries[[subSector]]]],
			sectorBoundaries[[subSector]]]];
		nextOffDiagonalBlock =
			Transpose[
			Take[Transpose[
			Take[prevSecTrafo, sectorBoundaries[[subSector]]]], {1,
			sectorBoundaries[[subSector]][[1]] - 1}]];
		nextDiagonalBlockInv = Inverse[nextDiagonalBlock];
		nextInvStep =
			Join[Drop[
			IdentityMatrix[
			sectorBoundaries[[subSector]][[2]]], -Length@
				nextDiagonalBlock],
			MapThread[
			Join, {-nextDiagonalBlockInv.nextOffDiagonalBlock,
			nextDiagonalBlockInv}]];
		nextCurrentInv =
			nextInvStep.InsertBlockIntoIdentity[prevSecInverse,
			sectorBoundaries[[subSector]][[2]], 1];
		nextTrafo =
			InsertBlockIntoIdentity[nextInvStep, sectorBoundaries[[-1]][[2]],
			1].prevSecTrafo;
		Return[{sectorBoundaries, nextCurrentInv, Factor@nextTrafo}];
	];


CalcNegPowerPossibilities[alphabet_List, invariants_List,
occuringLetters_List] :=
	Module[ {},
		Return[DeleteCases[(Times @@ # &) /@
			Function[powList, (alphabet[[#[[1]]]]^#[[2]] &) /@ powList] /@
				Flatten[Function[maxPowList,
				Flatten[
					Outer[List,
					Sequence @@
					Function[maxPowListEntry,
						Table[{maxPowListEntry[[1]], pow}, {pow,
						maxPowListEntry[[2]], -1}]] /@ maxPowList, 1],
					Length[maxPowList] - 1]] /@
				DeleteCases[Subsets[occuringLetters], {}], 1], False]];
	];


CalcNextDn[e_List, c_List, bhat_List, hbar_, khat_, nmin_Integer,
alphabet_List, invariants_List,
indepFactors_List, {previousDs_List, previousSolution_List,
	previousFactorSolutions_List}, OptionsPattern[]] :=
	Module[ {nOrder, ansatzD, lMax, kMax, khatMax, equationSet, vars,
		linearSystem, preSol, solRule, newPreviousSolution, newPreviousDs,
		nextDsVanishResult, maxEqnOrder, gVanishQ, bprimehatVanishQ,
		stopSol, preCompleteSoln, freeVarsToZero, freeVarsZeroSol,
		completeSoln},
		nOrder = Length[previousDs] + nmin - 1;
		If[ OptionValue[VerbosityLevel] >= 10,
			Print["Generating equations at order eps^" <> ToString[nOrder] <>
			"."]
		];
		ansatzD =
			Table[Table[
			Total[Table[\[Beta][nOrder, nIndepFactor, i, j]*
				indepFactors[[nIndepFactor]], {nIndepFactor, 1,
				Length[indepFactors]}]], {j, 1, Length[bhat[[1, 1]]]}], {i,
			1, Length[bhat[[1]]]}];
		lMax = Exponent[hbar, eps];
		kMax = Sort[Flatten[Exponent[bhat, eps]]][[1]];
		khatMax = Exponent[khat, eps];
		equationSet =
			Flatten[Table[
			Sum[(-D[SeriesCoefficient[hbar, {eps, 0, k}],
					invariants[[nVar]]]*
					Append[previousDs, ansatzD][[nOrder - k - nmin + 2]] +
				SeriesCoefficient[hbar, {eps, 0, k}]*
					D[Append[previousDs, ansatzD][[nOrder - k - nmin + 2]],
					invariants[[nVar]]]), {k, 0,
				Min[lMax, nOrder - nmin + 1]}] -
				Sum[SeriesCoefficient[
				hbar, {eps, 0,
					k}]*(e[[nVar]].Append[previousDs,
					ansatzD][[nOrder - 1 - k - nmin + 2]] -
					Append[previousDs,
					ansatzD][[nOrder - 1 - k - nmin + 2]].c[[nVar]]), {k,
				0, Min[lMax, nOrder - nmin]}] + -Sum[
				g[k]*SeriesCoefficient[
					bhat[[nVar]], {eps, 0, nOrder - k}], {k, 0,
				nOrder - nmin}] -
				Sum[D[Total[
					Table[Log[alphabet[[nLetter]]] Table[
					Table[\[Alpha][nLetter, nOrder - k, i, j], {j, 1,
						Length[bhat[[1, 1]]]}], {i, 1,
						Length[bhat[[1]]]}], {nLetter, 1, Length[alphabet]}]],
					invariants[[nVar]]]*
				SeriesCoefficient[Power[hbar, 2], {eps, 0, k}], {k, 0,
				Min[2*lMax, nOrder - nmin]}], {nVar, 1,
				Length[invariants]}]] /. Dispatch@previousSolution;
		vars =
			Join[Select[Variables[equationSet], Head[#1] === \[Alpha] &],
			Select[Variables[equationSet], Head[#1] === \[Beta] &],
			Select[Variables[equationSet], Head[#1] === g &]];
		linearSystem = (#1 == 0 &) /@
			Flatten[ParallelizeMap[$ComputeParallel][
			RatFunctionZeroCoeffs[#1, invariants] &, equationSet]];
		If[ OptionValue[VerbosityLevel] >= 12,
			Print["Found " <> ToString[Length[linearSystem]] <>
			" equations."];
		];
		If[ OptionValue[VerbosityLevel] >= 10,
			Print["Solving equations at order eps^" <> ToString[nOrder] <>
			"."]
		];
		Off[Solve::svars];
		preSol = LinearSystemSolver[linearSystem, vars, 0];
		On[Solve::svars];
		If[ Length[preSol] > 0,
			solRule = preSol[[1]];,
			Return[False];
		];
		newPreviousSolution =
			Join[previousSolution /. Dispatch@solRule, solRule];
		newPreviousDs =
			Join[previousDs /.
			Dispatch@newPreviousSolution, {ansatzD /.
			Dispatch@newPreviousSolution}];
		If[ OptionValue[VerbosityLevel] >= 10,
			Print["Checking whether series terminates."]
		];
		nextDsVanishResult =
			CheckNextDsVanish[newPreviousDs, newPreviousSolution, bhat, lMax,
			nmin, hbar, e, c, alphabet, invariants,
			lMax + 1 + Max[kMax + 1, 2*lMax + 1]];
		If[ nextDsVanishResult === False,
			Return[{newPreviousDs, newPreviousSolution, {}}]
		];
		maxEqnOrder =
			Length[newPreviousDs] + nmin - 2 + lMax + 1 +
			Max[kMax + 1, 2*lMax + 1];
		gVanishQ = (0 == #1[[2]] &) /@
			Select[nextDsVanishResult,
				Head[#1[[1]]] === g &&
				MemberQ[Table[
					i, {i, maxEqnOrder - nmin - (kMax + 1) + 1,
					maxEqnOrder - nmin}], #1[[1, 1]]] &] /.
			Table[g[i] -> 0, {i, maxEqnOrder - nmin - (kMax + 1) + 1,
				maxEqnOrder - nmin}] /.
			Table[\[Alpha][_, i, _, _] -> 0, {i,
			maxEqnOrder - (2 lMax + 1) + 1, maxEqnOrder}];
		bprimehatVanishQ = (0 == #1[[2]] &) /@
			Select[nextDsVanishResult,
				Head[#1[[1]]] === \[Alpha] &&
				MemberQ[Table[
					i, {i, maxEqnOrder - (2 lMax + 1) + 1,
					maxEqnOrder}], #1[[1, 2]]] &] /.
			Table[\[Alpha][_, i, _, _] -> 0, {i,
				maxEqnOrder - (2 lMax + 1) + 1, maxEqnOrder}] /.
			Table[g[i] -> 0, {i, maxEqnOrder - nmin - (kMax + 1) + 1,
			maxEqnOrder - nmin}];
		stopSol = Solve[And @@ bprimehatVanishQ && And @@ gVanishQ];
		If[ Length[stopSol] > 0,
			preCompleteSoln =
			Join[nextDsVanishResult /. stopSol[[1]], stopSol[[1]]];
			freeVarsToZero = # -> 0 & /@
			Variables[#[[2]] & /@ preCompleteSoln];
			freeVarsZeroSol =
			Join[stopSol[[1]] /. freeVarsToZero, freeVarsToZero];
			completeSoln =
			Join[nextDsVanishResult /. freeVarsZeroSol, freeVarsZeroSol];
			Return[{newPreviousDs /.
				Dispatch@completeSoln /. {\[Beta][___] ->
				0}, {}, {Sum[
				g[i]*Power[eps, i], {i, 0, maxEqnOrder - nmin}] /.
				Dispatch@completeSoln /. {\[Beta][___] -> 0}}}];,
			Return[{newPreviousDs, newPreviousSolution, {}}];
		];
	];


CalcNextTn[aHat_List, f_, alphabet_List, invariants_List,
lMIN_Integer, lMAX_Integer, kMAX_Integer, kMIN_Integer,
nonSingularPoint_List,
indepFactors_List, {previousTs_List, previousSolution_List,
	previousNonlinears_List, tZeroQ_}, OptionsPattern[]] :=
	Module[ {nOrder, tAnsatz, tVector, deqAtNOrder, equationSet,
		parameterEquations, linearPartSolved, solveResult, newTs, newSols,
		res},
		nOrder = Length[previousTs] + lMIN;
		tAnsatz =
			Table[Table[
			Total[Table[\[Beta][nOrder, nIndepFactor, i, j]*
				indepFactors[[nIndepFactor]], {nIndepFactor, 1,
				Length[indepFactors]}]], {j, 1, Length[aHat[[1]]]}], {i, 1,
			Length[aHat[[1]]]}];
		tVector = Append[previousTs, tAnsatz];
		deqAtNOrder =
			Table[Sum[(-D[SeriesCoefficient[f, {eps, 0, k}],
					invariants[[nVar]]]*tVector[[nOrder - k - lMIN + 1]] +
				SeriesCoefficient[f, {eps, 0, k}]*
				D[tVector[[nOrder - k - lMIN + 1]],
				invariants[[nVar]]]), {k, lMIN,
				Min[lMAX, nOrder - lMIN]}] -
			Sum[
			SeriesCoefficient[aHat[[nVar]], {eps, 0, k}].tVector[[
				nOrder - k - lMIN + 1]], {k, 0, Min[kMAX, nOrder - lMIN]}] +
			Sum[(SeriesCoefficient[f, {eps, 0, k}]*
				tVector[[nOrder - k - 1 - lMIN + 1]].D[
					Total[Table[
					Log[alphabet[[nLetter]]] Table[
						Table[\[Alpha][nLetter, i, j], {j, 1,
						Length[aHat[[1]]]}], {i, 1,
						Length[aHat[[1]]]}], {nLetter, 1,
					Length[alphabet]}]], invariants[[nVar]]] /.
				Dispatch@previousSolution), {k, lMIN,
				Min[lMAX, nOrder - 1 - lMIN]}], {nVar, 1, Length[invariants]}];
		equationSet = Flatten[deqAtNOrder];
		If[ OptionValue[VerbosityLevel] >= 10,
			Print["Generating equations at order eps^" <> ToString[nOrder] <>
			"."]
		];
		parameterEquations = (#1 == 0 &) /@
			Flatten[ParallelizeMap[$ComputeParallel][
			RatFunctionZeroCoeffs[#1, invariants] &, equationSet]];
		If[ OptionValue[VerbosityLevel] >= 12,
			Print["Found " <> ToString[Length[parameterEquations]] <>
			" equations."]
		];
		If[ OptionValue[VerbosityLevel] >= 10,
			Print["Solving equations at order eps^" <> ToString[nOrder] <>
			"."]
		];
		Off[Solve::svars];
		linearPartSolved =
			SolveLinearPart[Join[parameterEquations, previousNonlinears]];
		If[ linearPartSolved === {},
			If[ OptionValue[VerbosityLevel] >= 2,
				Print["No solution found at order eps^" <> ToString[nOrder] <>
				". Try different Ansatz."]
			];
			Return[False];
		];
		solveResult =
			Select[linearPartSolved[[1]],
			Union[Flatten[
				Table[Table[
					Table[\[Beta][lMIN, NIndepFactor, i, j], {NIndepFactor,
					1, Length[indepFactors]}], {i, 1,
					Length[aHat[[1]]]}], {j, 1, Length[aHat[[1]]]}]] /.
				Dispatch[previousSolution] /. Dispatch[#1]] =!= {0} &];
		On[Solve::svars];
		If[ solveResult == {},
			If[ OptionValue[VerbosityLevel] >= 2,
				Print["No solution found at order eps^" <> ToString[nOrder] <>
					". Try different Ansatz."];
			];
			Return[False];
		];
		If[ OptionValue[VerbosityLevel] >= 10,
			Print["Checking whether series terminates."]
		];
		newTs =
			Join[previousTs /.
			Dispatch[solveResult[[1]]], {tAnsatz /.
			Dispatch[solveResult[[1]]]}];
		newSols =
			Join[previousSolution /. Dispatch[solveResult[[1]]],
			solveResult[[1]]];
		res = CheckNextTsVanish[aHat, f, alphabet, invariants, lMIN, lMAX,
			kMAX, kMIN, nonSingularPoint, indepFactors, newTs, newSols,
			linearPartSolved[[2]], Max[kMAX - kMIN, lMAX - lMIN + 1]];
		If[ res === False,
			If[ Length[newTs] >= (Max[kMAX - kMIN, lMAX - lMIN + 1] + 1) &&
			Or @@ Table[
				Length[Union[
				newTs[[-Max[kMAX - kMIN, lMAX - lMIN + 1] - 1 - del ;;
					Length[newTs] - del]] /. \[Beta][a_, b_, c_,
					d_] :> \[Beta][b, c, d]]] === 1, {del, 0,
				Length[newTs] - Max[kMAX - kMIN, lMAX - lMIN + 1] - 1}],
				If[ OptionValue[VerbosityLevel] >= 2,
					Print["Infinite loop encountered. Try different Ansatz."]
				];
				Return[False];
			];
			Return[{newTs, newSols, linearPartSolved[[2]], False}];,
			Return[{res, {}, {}, True}];
		];
	];


CalcOccuringDenLetters[alphabet_List, invariants_List, expr_,
delta_Integer] :=
	Module[ {},
		Return[Select[({#[[1]], #[[2]] + 1 -
				delta} &) /@ ({ExprPropLetterQ[#[[1]], invariants, alphabet,
					ShowLetter -> True][[3]], -#1[[2]]} &) /@
			Select[FactorList[
				Denominator[expr]], !IndependentOfInvariantsQ[#[[1]],
				invariants] &], #[[2]] <= -1 &]];
	];


CalculateDlogForm[a_List, invariants_List, alphabet_List] :=
	Module[ {irredList, zeroRules, genericdLogForm, eqnsList, solList,
		nonzeroRules},
		If[ ! CheckAlphabet[alphabet, Append[invariants, eps]],
			Return[False];
		];
		If[ ! CheckDE[a, invariants, EnforceSquare -> False],
			Return[False];
		];
		irredList =
			Map[Function[expr,
			Function[res,
				If[ res === {},
					If[ Union[Flatten[expr]] === {0},
						{},
						False
					],
					res
				]][ExtractIrreducibles[expr,
				AllowEpsDependence -> True]]], Transpose[a, {3, 1, 2}], {2}];
		If[ ! FreeQ[irredList, False],
			Return[False];
		];
		If[ ! And @@ (ExprPropLetterQ[#1, invariants, alphabet] &) /@
			Union[Flatten[irredList]],
			Message[CalculateDlogForm::incalphabet];
			Return[False];
		];
		If[ IndependentOfInvariantsQ[irredList, invariants],
			If[ Union[Flatten[a]] === {0},
				Return[Table[
					Table[Table[0, {j, 1, Length[a[[1, 1]]]}], {i, 1,
					Length[a[[1]]]}], {nLetter, 1, Length@alphabet}]];,
				Return[False];
			];
		];
		zeroRules =
			Flatten[MapIndexed[\[Alpha][#1, #2[[1]], #2[[2]]] -> 0 &,
			Map[Complement[Table[i, {i, 1, Length[alphabet]}], #1] &,
			Map[ExprPropLetterQ[#1, invariants, alphabet,
				ShowLetter -> True][[3]] &, irredList, {3}], {2}], {3}]];
		genericdLogForm =
			D[Total[MapIndexed[
				Table[Table[\[Alpha][#2[[1]], i, j], {j, 1,
					Length[a[[1, 1]]]}], {i, 1, Length[a[[1]]]}] Log[#1] &,
				alphabet]], #1] & /@ invariants /. Dispatch[zeroRules];
		eqnsList = (Union[Flatten[#1]] &) /@
			Map[RatFunctionZeroCoeffs[#1, invariants] &,
			DeleteCases[
			Flatten[Transpose[genericdLogForm - a, {3, 1, 2}], 1],
			Table[0, {i, 1, Length[invariants]}]], {2}];
		solList =
			Function[eqns,
			Solve[Function[lhs, lhs == 0] /@ eqns,
			DeleteCases[Variables[eqns], eps]]] /@ eqnsList;
		If[ MemberQ[solList, {}],
			Return[False];
		];
		nonzeroRules = Flatten[solList];
		Return[
			MapIndexed[
			Table[Table[\[Alpha][#2[[1]], i, j], {j, 1,
				Length[a[[1, 1]]]}], {i, 1, Length[a[[1]]]}] &,
			alphabet] /. Dispatch[zeroRules] /. Dispatch[nonzeroRules]];
	];


CalculateNexta[aFull_List, invariants_List, sectorBoundaries_List,
trafoPrevious_List, aPrevious_List] :=
	Module[ {sizeNew, sizeOld, rawBlock, subBlock, diagBlock, aNew},
		If[ ! CheckSectorBoundaries[aFull, sectorBoundaries],
			Return[False];
		];
		If[ {{}, {{}}} =!= {trafoPrevious, aPrevious},
			If[ ! CheckDE[aPrevious, invariants],
				Return[False];
			];
			If[ ! SquareMatrixQ[trafoPrevious],
				Message[CalculateNexta::notsquare];
				Return[False];
			];
			If[ Length[trafoPrevious] =!= Length[aPrevious[[1]]],
				Message[CalculateNexta::mismatch1];
				Return[False];
			];
			If[ ! MemberQ[#[[2]] & /@ sectorBoundaries, Length[trafoPrevious]],
				Message[CalculateNexta::mismatch2];
				Return[False];
			];
			If[ Position[sectorBoundaries, Length[trafoPrevious]][[1, 1]] ===
			Length[sectorBoundaries],
				Message[CalculateNexta::nonerem];
				Return[False];
			];
		];
		sizeNew = NextBlockBoundaries[aPrevious, sectorBoundaries][[2]];
		If[ Length[aFull[[1]]] < sizeNew,
			Message[CalculateNexta::mismatch3];
			Return[False];
		];
		If[ sizeNew === sectorBoundaries[[1, 2]],
			aNew = ExtractDiagonalBlock[aFull, {1, sizeNew}];,
			sizeOld = Length[aPrevious[[1]]];
			rawBlock = ExtractDiagonalBlock[aFull, {1, sizeNew}];
			subBlock =
			Table[Table[
				Table[rawBlock[[nVar, j, i]], {i, 1, sizeOld}], {j,
				sizeOld + 1, sizeNew}].trafoPrevious, {nVar, 1,
			Length[invariants]}];
			diagBlock =
			Table[Table[
			Table[rawBlock[[nVar, j, i]], {i, sizeOld + 1, sizeNew}], {j,
				sizeOld + 1, sizeNew}], {nVar, 1, Length[invariants]}];
			aNew =
			Table[Join[
			Function[aLine,
				Join[aLine, Table[0, {i, 1, sizeNew - sizeOld}]]] /@
				aPrevious[[nVar]],
			MapIndexed[
				Function[{aLine, nLine},
				Join[aLine, diagBlock[[nVar, nLine[[1]]]]]],
				subBlock[[nVar]]]], {nVar, 1, Length[invariants]}];
		];
		Return[aNew];
	];


CalculateNextSubsectorD[a_List, invariants_List,
sectorBoundaries_List, previousD_List, userProvidedAnsatz_List: {},
	OptionsPattern[]] :=
	Module[ {nextEquation, irredFactors, nLowerSector, e, newb, c, b,
		subSector, alphabet, newCurrentD, nextSectorD},
		nextEquation =
			NextEquationD[a, invariants, sectorBoundaries, previousD];
		If[ nextEquation[[1]] === False,
			Return[{False, {}}];
		];
		{e, c, b, subSector, nLowerSector} = nextEquation;
		irredFactors =
			ExtractIrreducibles[nextEquation, AllowEpsDependence -> True];
		alphabet = Union[invariants, Select[irredFactors, FreeQ[#, eps] &]];
		If[ OptionValue[VerbosityLevel] >= 8,
			Print["Transforming sector " <> ToString[nLowerSector] <>
			" below sector " <> ToString[subSector] <>
			" into dlog-form."];
		];
		If[ FreeQ[irredFactors,
			eps] && (And @@ Flatten[Map[PossibleZeroQ, b, {3}]] ||
			CheckDlogForm[b, invariants, alphabet]),
			newCurrentD = (Join[
				Table[0, {i, 1,
				sectorBoundaries[[nLowerSector, 2]] -
					sectorBoundaries[[nLowerSector, 1]] + 1}], #1] &) /@
			previousD;
			If[ OptionValue[VerbosityLevel] >= 10,
				Print["Block is already in the required form."];
			];,
			nextSectorD =
			FindD[e, c, b, alphabet, invariants, userProvidedAnsatz,
			DDeltaDenominatorDegree -> OptionValue[DDeltaDenominatorDegree],
			DDeltaNumeratorDegree -> OptionValue[DDeltaNumeratorDegree],
			VerbosityLevel -> OptionValue[VerbosityLevel]];
			If[ nextSectorD === False,
				If[ OptionValue[VerbosityLevel] >= 2,
					Print["No solution found. Try different Ansatz."]
				];
				Return[{False, previousD}];
			];
			newCurrentD =
			MapIndexed[Join[nextSectorD[[#2[[1]]]], #1] &, previousD];
		];
		Return[newCurrentD];
	];


CalculateNonSingularPoint[alphabet_List, invariants_List] :=
	Return[FindInstance[And @@ Map[# != 0 &, alphabet],
		invariants][[1]]];


CheckAlphabet[alphabet_List, invariants_List] :=
	Module[ {},
		If[ ! And @@ Map[PolynomialQ[#, invariants] &, alphabet],
			Message[CheckAlphabet::notpoly];
			Return[False];
		];
		If[ Complement[Variables@alphabet, invariants] =!= {},
			Message[CheckAlphabet::notinv];
			Return[False];,
			Return[True];
		];
	];


CheckBoundariesConsistency[sectorBoundaries_List] :=
	Module[ {startsAtOneQ, increasingQ, consecutiveQ, returnValue},
		If[ sectorBoundaries === {},
			Message[CheckBoundariesConsistency::falsebounds];
			Return[False];
		];
		If[ Union[Length /@ sectorBoundaries] =!= {2},
			Message[CheckBoundariesConsistency::falsebounds];
			Return[False];
		];
		startsAtOneQ = sectorBoundaries[[1, 1]] === 1;
		increasingQ = And @@ Map[#[[1]] <= #[[2]] &, sectorBoundaries];
		consecutiveQ =
			If[ Length[sectorBoundaries] > 1,
				And @@ Table[
				sectorBoundaries[[n, 2]] + 1 ===
					sectorBoundaries[[n + 1, 1]], {n, 1,
					Length[sectorBoundaries] - 1}],
				True
			];
		returnValue = startsAtOneQ && increasingQ && consecutiveQ;
		If[ ! returnValue,
			Message[CheckBoundariesConsistency::falsebounds];
		];
		Return[returnValue];
	];


CheckDE[a_List, invariants_List, OptionsPattern[]] :=
	Module[ {nonNullQ, squareQ, sameDimQ, allVarsQ, varNumberMatchQ},
		nonNullQ = FreeQ[a, Null];
		squareQ =
			If[ OptionValue[EnforceSquare] ===
			True,
				(And @@ (SquareMatrixQ /@ a)),
				True
			];
		sameDimQ = (Length[Union[Dimensions /@ a]] ===
			1) && (Length[Dimensions[a]] === 3);
		allVarsQ =
			Complement[DeleteCases[Variables[a], Null],
			Append[invariants, eps]] === {};
		varNumberMatchQ = Length[a] === Length[invariants];
		If[ ! nonNullQ,
			Message[CheckDE::nonull]
		];
		If[ ! squareQ,
			Message[CheckDE::notsquare]
		];
		If[ ! sameDimQ,
			Message[CheckDE::diffdims]
		];
		If[ ! allVarsQ,
			Message[CheckDE::fewvars]
		];
		If[ ! varNumberMatchQ,
			Message[CheckDE::varnumber]
		];
		Return[
			nonNullQ && sameDimQ && squareQ && allVarsQ && varNumberMatchQ];
	];


CheckDlogForm[a_List, invariants_List, alphabet_List] :=
	Module[ {},
		If[ CalculateDlogForm[a, invariants, alphabet] =!= False,
			Return[True];,
			Return[False];
		];
	];


CheckEpsForm[a_List, invariants_List, alphabet_List] :=
	Module[ {dLogForm, mixedLetterPositions},
		Off[CalculateDlogForm::incalphabet];
		dLogForm = CalculateDlogForm[a, invariants, alphabet];
		On[CalculateDlogForm::incalphabet];
		If[ dLogForm === False,
			Return[False];
		];
		mixedLetterPositions = Position[FreeQ[#, eps] & /@ alphabet, False];
		Return[(And @@
			Map[NumberQ[Simplify[#/eps]] &,
				DeleteCases[Flatten@Delete[dLogForm, mixedLetterPositions],
				0]]) && (DeleteCases[
				Flatten[Extract[dLogForm, mixedLetterPositions]],
				0] === {})]
	];


CheckIntegrability[a_List, invariants_List, OptionsPattern[]] :=
	Module[ {nonSingularPoint, relation, fIntCond},
		If[ ! CheckDE[a, invariants],
			Return[Null]
		];
		nonSingularPoint =
			Join[FindInstance[And @@ (#1 != 0 &) /@ ExtractIrreducibles[a],
			invariants, Integers][[1]],
			MapIndexed[#1 -> Prime[10^9 + #2[[1]]] &,
			Complement[Variables[a], invariants]]];
		relation = ((D[a[[#1[[1]]]], invariants[[#1[[2]]]]] /.
				nonSingularPoint) - (D[a[[#1[[2]]]],
				invariants[[#1[[1]]]]] /.
				nonSingularPoint) + (a[[#1[[1]]]].a[[#1[[2]]]] -
				a[[#1[[2]]]].a[[#1[[1]]]] /. nonSingularPoint) &) /@
			Flatten[DeleteCases[
			Table[Table[{i, j}, {i, j + 1, Length[invariants]}], {j, 1,
				Length[invariants]}], {}], 1];
		If[ OptionValue[ShowRelations],
			If[ Length[Select[Flatten@N[relation], ! #1 === 0.` &]] === 0,
				Return[True],
				fIntCond = relation.Table[Int[i], {i, 1, Length@a[[1]]}];
				Return[Solve[# == 0 & /@ Union@Flatten@fIntCond]];
			];,
			If[ Length[Select[Flatten@N[relation], ! #1 === 0.` &]] === 0,
				Return[True];,
				Return[False];
			];
		];
	];


CheckNextDsVanish[newPreviousDs_List, newPreviousSolution_List,
bhat_List, lMax_Integer, nmin_Integer, hbar_, e_List, c_List,
alphabet_List, invariants_List, delta_Integer] :=
	Module[ {ansatzD, vectorD, equationSet, vars, linearSystem, preSol,
		solRule},
		ansatzD =
			Table[Table[0, {j, 1, Length[bhat[[1, 1]]]}], {i, 1,
			Length[bhat[[1]]]}];
		vectorD = Join[newPreviousDs, Table[ansatzD, {i, 1, delta}]];
		equationSet =
			Flatten[Table[
			Table[Sum[(-D[SeriesCoefficient[hbar, {eps, 0, k}],
					invariants[[nVar]]]*vectorD[[nOrder - k - nmin + 2]] +
					SeriesCoefficient[hbar, {eps, 0, k}]*
					D[vectorD[[nOrder - k - nmin + 2]],
					invariants[[nVar]]]), {k, 0,
				Min[lMax, nOrder - nmin + 1]}] -
				Sum[SeriesCoefficient[
					hbar, {eps, 0,
					k}]*(e[[nVar]].vectorD[[nOrder - 1 - k - nmin + 2]] -
					vectorD[[nOrder - 1 - k - nmin + 2]].c[[nVar]]), {k, 0,
				Min[lMax, nOrder - nmin]}] + -Sum[
				g[k]*SeriesCoefficient[
					bhat[[nVar]], {eps, 0, nOrder - k}], {k, 0,
					nOrder - nmin}] -
				Sum[D[Total[
					Table[Log[alphabet[[nLetter]]] Table[
						Table[\[Alpha][nLetter, nOrder - k, i, j], {j, 1,
						Length[bhat[[1, 1]]]}], {i, 1,
						Length[bhat[[1]]]}], {nLetter, 1,
					Length[alphabet]}]], invariants[[nVar]]]*
				SeriesCoefficient[Power[hbar, 2], {eps, 0, k}], {k, 0,
				Min[2*lMax, nOrder - nmin]}], {nVar, 1,
				Length[invariants]}] /. newPreviousSolution, {nOrder,
			Length[newPreviousDs] + nmin - 1,
			Length[newPreviousDs] + nmin + delta - 2}]];
		vars =
			Join[Select[Variables[equationSet], Head[#1] === \[Alpha] &],
			Select[Variables[equationSet], Head[#1] === \[Beta] &],
			Select[Variables[equationSet], Head[#1] === g &]];
		linearSystem =
			Map[# == 0 &,
			Flatten[ParallelizeMap[$ComputeParallel][
			RatFunctionZeroCoeffs[#, invariants] &, equationSet]]];
		Off[Solve::svars];
		preSol = LinearSystemSolver[linearSystem, vars, 0];
		On[Solve::svars];
		If[ Length[preSol] > 0,
			solRule = preSol[[1]];,
			Return[False];
		];
		Return[Join[newPreviousSolution /. solRule, solRule]];
	];


CheckNextTsVanish[aHat_List, f_, alphabet_List, invariants_List,
lMIN_Integer, lMAX_Integer, kMAX_Integer, kMIN_Integer,
nonSingularPoint_List, indepFactors_List, previousTs_List,
previousSolution_List, previousNonlinears_List, delta_Integer] :=
	Module[ {tVector, deAtNextDeltaOrders, equationSet,
		nParameterEquations, nlinearPartSolved, preTrafo,
		simplifiedPreTrafo, preSol, polishedSol, remSol, freeVarsZero,
		fullSol, cmatrix, coeffList, constTrafo},
		tVector =
			Join[previousTs,
			Table[Table[
			Table[0, {j, 1, Length[aHat[[1]]]}], {i, 1,
				Length[aHat[[1]]]}], {i, 1, delta}]];
		deAtNextDeltaOrders =
			Table[Table[
			Sum[-D[SeriesCoefficient[f, {eps, 0, k}], invariants[[nVar]]]*
				tVector[[nOrder - k - lMIN + 1]] +
				SeriesCoefficient[f, {eps, 0, k}]*
				D[tVector[[nOrder - k - lMIN + 1]], invariants[[nVar]]], {k,
				lMIN, Min[lMAX, nOrder - lMIN]}] -
			Sum[SeriesCoefficient[aHat[[nVar]], {eps, 0, k}].tVector[[
				nOrder - k - lMIN + 1]], {k, 0, nOrder - lMIN}] +
			Sum[
				SeriesCoefficient[f, {eps, 0, k}]*
				tVector[[nOrder - k - 1 - lMIN + 1]].D[
					Total@Table[
					Log[alphabet[[nLetter]]]*
					Table[Table[\[Alpha][nLetter, i, j], {j, 1,
						Length[aHat[[1]]]}], {i, 1,
						Length[aHat[[1]]]}], {nLetter, 1, Length[alphabet]}],
					invariants[[nVar]]] /. Dispatch[previousSolution], {k,
				lMIN, Min[lMAX, nOrder - 1 - lMIN]}], {nVar, 1,
			Length@invariants}], {nOrder, Length[previousTs] + lMIN,
			Length[previousTs] + lMIN - 1 + delta}];
		equationSet = Flatten[deAtNextDeltaOrders];
		nParameterEquations = (#1 == 0 &) /@
			Flatten[ParallelizeMap[$ComputeParallel][
			RatFunctionZeroCoeffs[#1, invariants] &, equationSet]];
		nlinearPartSolved =
			SolveLinearPart[Join[nParameterEquations, previousNonlinears]];
		If[ nlinearPartSolved === {},
			Return[False];
		];
		preTrafo =
			Power[f, -1]*
			Total[MapIndexed[#1 eps^(#2[[1]] - 1 + lMIN) &,
			previousTs /.
				Dispatch[
				Join[previousSolution /. nlinearPartSolved[[1, 1]],
				nlinearPartSolved[[1, 1]]]]]];
		simplifiedPreTrafo =
			Simplify[
			preTrafo /. nonSingularPoint /. eps -> Prime[Power[10, 4]]];
		Off[Solve::svars];
		preSol =
			Solve[simplifiedPreTrafo == IdentityMatrix[Length[preTrafo]]];
		On[Solve::svars];
		If[ preSol === {},
			Return[False];
		];
		If[ Length[Select[Variables[preTrafo], Head[#] === \[Beta] &]] ===
			Power[Length[preTrafo], 2],
			polishedSol =
			Nest[Function[expr, PolishStep[expr, simplifiedPreTrafo]], {{},
				preSol[[1]]}, Power[Length[preTrafo], 2]][[1]];
			remSol =
			SolveLinearPart[nlinearPartSolved[[2]] /. Dispatch@polishedSol];
			If[ remSol =!= {} && remSol[[2]] === {},
				Return[Simplify[
					preTrafo /. Dispatch[remSol[[1, 1]]] /.
					Dispatch[polishedSol]]];,
				Return[False];
			];,
			remSol =
			SolveLinearPart[
			nlinearPartSolved[[2]] /. Dispatch[preSol[[1]]]];
			If[ ! (remSol =!= {} && remSol[[2]] === {}),
				Return[False];
			];
			freeVarsZero =
			Map[# -> 0 &, Variables[#[[2]] & /@ remSol[[1, 1]]]];
			fullSol = Join[remSol[[1, 1]] /. freeVarsZero, freeVarsZero];
			cmatrix =
			Table[Table[c[i, j], {j, 1, Length[preTrafo]}], {i, 1,
			Length[preTrafo]}];
			coeffList =
			DeleteCases[
			Flatten[(#1.cmatrix &) /@ (Flatten[
					Table[Table[
					Table[Table[\[Beta][nOrder, nIndep, i, j], {j, 1,
						Length[preTrafo]}], {i, 1,
						Length[preTrafo]}], {nIndep, 1,
					Length[indepFactors]}], {nOrder, lMIN,
					Length[previousTs] + lMIN - 1}], 1] /.
				Dispatch[
					Join[Join[
					Join[previousSolution /.
						Dispatch[nlinearPartSolved[[1, 1]]],
						nlinearPartSolved[[1, 1]]] /. Dispatch[preSol[[1]]],
					preSol[[1]]] /. Dispatch[fullSol],
					fullSol]])] /. {\[Beta][___] -> 0}, 0];
			constTrafo =
			cmatrix /.
			Nest[Function[expr, SolveConstTrafoStep[expr, cmatrix]], {{},
				coeffList}, Power[Length[preTrafo], 2]][[1]];
			Return[
			Simplify[(preTrafo /. Dispatch[preSol[[1]]] /.
				Dispatch[fullSol]).constTrafo]];
		];
	];


CheckRationality[a_List, invariants_List] :=
	Module[ {freeOfExpFunctionsQ, freeOfOtherHeads},
		freeOfExpFunctionsQ =
			Cases[a,
			Power[___,
			b_ /; ! IndependentOfInvariantsQ[b, Append[invariants, eps]]],
			Infinity] === {};
		freeOfOtherHeads =
			Complement[
			Union@Flatten[Reap[MapAll[Sow[Head[#]] &, a]]], {Integer, List,
			Plus, Power, Rational, Symbol, Times}] === {};
		Return[freeOfExpFunctionsQ && freeOfOtherHeads];
	];


CheckSectorBoundaries[a_List, sectorBoundaries_List] :=
	Module[ {size},
		size = Length[a[[1]]];
		If[ CheckBoundariesConsistency[sectorBoundaries],
			Return[And @@
				PossibleZeroQ /@
				Union[Flatten[
					Function[matrix,
					Function[
						bounds, (Take[
							matrix[[#1]], {bounds[[2]] + 1, Length[matrix]}] &) /@
						Table[i, {i, bounds[[1]], bounds[[2]]}]] /@
						Drop[Select[sectorBoundaries,
						FreeQ[#1, x_ /; x > size] &], -1]] /@ a]]];,
			Return[False];
		];
	];


ConstantNormalizationStep[{dlogForm_List, trafoPrevious_List}] :=
	Module[ {consttrafo, freeConsts, fixedPoint, trafo},
		consttrafo =
			DiagonalMatrix[Table[c[i], {i, 1, Length@dlogForm[[1]]}]];
		freeConsts =
			Select[DeleteCases[
			Flatten[Table[
				Inverse[consttrafo].dlogForm[[nLetter]].consttrafo /.
				eps -> 1, {nLetter, 1, Length@dlogForm}]],
			0], ! FreeQ[#, c] &];
		fixedPoint = FixedPoint[FindNextConstant, {freeConsts, {}}];
		trafo = consttrafo /. fixedPoint[[2]] /. _c -> 1;
		Return[{Table[
			Inverse[trafo].dlogForm[[nLetter]].trafo, {nLetter, 1,
			Length@dlogForm}], trafoPrevious.trafo}]
	];


DenominatorFactors[expr_, invariants_List, OptionsPattern[]] :=
	Module[ {factors},
		factors = FactorList[Denominator[expr]];
		If[ OptionValue[ShowPowersAndPrefactor],
			Return[{Select[factors,
			IndependentOfInvariantsQ[#, invariants] &],
			Select[factors, !IndependentOfInvariantsQ[#, invariants] &]}],
			Return[
			Map[#[[1]] &,
			Select[factors, !IndependentOfInvariantsQ[#, invariants] &]]];
		];
	];


DissipateFactors[lettersBounds_List, eDlog_List, cDlog_List] :=
	Module[ {eDlog0, cDlog0, lettersBoundsPlusOne, eStep0, eStep, cStep0,
		cStep},
		eDlog0 = Map[If[ # =!= 0,
						1,
						0
					] &, Total[eDlog], {2}];
		cDlog0 = Map[If[ # =!= 0,
						1,
						0
					] &, Total[cDlog], {2}];
		lettersBoundsPlusOne =
			DeleteCases[
			Map[If[ #[[2]] >= -1,
					False,
					{#[[1]], #[[2]] + 1}
				] &,
			lettersBounds, {4}], False, 4];
		eStep0 =
			Table[Table[
			Table[Union[
				DeleteCases[
				Flatten[Table[
				eDlog0[[i, k]]*lettersBoundsPlusOne[[nLetter, k, j]], {k,
					1, Length[eDlog[[nLetter, 1]]]}], 1], {0, 0}]], {j, 1,
				Length[lettersBounds[[nLetter, 1]]]}], {i, 1,
			Length[eDlog[[nLetter]]]}], {nLetter, 1, Length@eDlog}];
		eStep = Table[
			Table[Table[
			Union[DeleteCases[
				Flatten[Table[
				eDlog[[nLetter, i, k]]*lettersBounds[[nLetter, k, j]], {k,
					1, Length[eDlog[[nLetter, 1]]]}], 1], {0, 0}]], {j, 1,
				Length[lettersBounds[[nLetter, 1]]]}], {i, 1,
			Length[eDlog[[nLetter]]]}], {nLetter, 1, Length@eDlog}];
		cStep0 =
			Table[Table[
			Table[Union[
				DeleteCases[
				Flatten[Table[
				lettersBoundsPlusOne[[nLetter, i, k]]*cDlog0[[k, j]], {k,
					1, Length[cDlog[[nLetter]]]}], 1], {0, 0}]], {j, 1,
				Length[cDlog[[nLetter, 1]]]}], {i, 1,
			Length[lettersBounds[[nLetter]]]}], {nLetter, 1, Length@cDlog}];
		cStep =
			Table[Table[
			Table[Union[
				DeleteCases[
				Flatten[Table[
				lettersBounds[[nLetter, i, k]]*cDlog[[nLetter, k, j]], {k,
					1, Length[cDlog[[nLetter]]]}], 1], {0, 0}]], {j, 1,
				Length[cDlog[[nLetter, 1]]]}], {i, 1,
			Length[lettersBounds[[nLetter]]]}], {nLetter, 1, Length@cDlog}];
		Return[
			Map[Function[list,
			Map[Function[glist, Sort[glist, #1[[2]] < #2[[2]] &][[1]]],
			GatherBy[list, #[[1]] &]]],
			MapThread[Union, {lettersBounds, eStep0, eStep, cStep},
			3], {3}]];
	];


EliminateLinearEqns[prevNLEquations_List, prevLinearSoln_List,
vars_List] :=
	Module[ {unionEquations, linearTestRes, linearEqns, nonLinearEqns,
		linearSoln, updatedPrevSolns, nextLinearSoln},
		If[ ! FreeQ[prevNLEquations, False],
			Return[{False, False, {}}];
		];
		unionEquations = Union[prevNLEquations];
		linearTestRes =
			ParallelizeMap[$ComputeParallel][LinearTest[#1[[1]]] &,
			unionEquations];
		linearEqns = Pick[unionEquations, linearTestRes];
		nonLinearEqns = Complement[unionEquations, linearEqns];
		Off[Solve::svars];
		linearSoln = LinearSystemSolver[linearEqns, vars, 0];
		If[ linearSoln === {},
			Return[{False, False, {}}];
		];
		updatedPrevSolns =
			Map[#1[[1]] == #1[[2]] &,
			Join[prevLinearSoln /. Dispatch@linearSoln[[1]]]];
		nextLinearSoln =
			Join[Solve[updatedPrevSolns,
			Variables[#[[1]] & /@ updatedPrevSolns]][[1]],
			linearSoln[[1]]];
		On[Solve::svars];
		Return[{DeleteCases[
			Union[nonLinearEqns /. Dispatch[linearSoln[[1]]]], True],
			nextLinearSoln}];
	];


EmptyIntersectionQ[polyList_List, invariants_List] :=
	Module[ {returnValue},
		Off[Solve::svars];
		returnValue =
			Solve[And @@ Map[Function[factor, factor == 0], polyList],
			invariants] === {};
		On[Solve::svars];
		Return[returnValue];
	];


EpsDependentNormalizationStep[{invariants_List, trafoPrevious_List,
	aPrevious_List}] :=
	Module[ {preFactorsOnlyDE, offsetMatrix, factors,
		nonSingularEpsPoint, currentPowers, trafoPowers, powMatrix,
		ordersList, numeratorContribution, overallFactor, vars, sol,
		trafo},
		If[ Length[aPrevious[[1]]] === 1,
			Return[{invariants, {{1}}, aPrevious}];
		];
		preFactorsOnlyDE =
			Map[Function[expr,
			Select[FactorList[
				expr], ! FreeQ[#1, eps] &&
				IndependentOfInvariantsQ[#1, invariants] &]], aPrevious, {3}];
		factors =
			Union[(#1[[1]] &) /@ Flatten[preFactorsOnlyDE, 3],
			SameTest -> (NumberQ[Simplify[#1/#2]] &)];
		nonSingularEpsPoint = CalculateNonSingularPoint[factors, {eps}];
		currentPowers =
			Map[{ExprPropLetterQ[#[[1]], invariants, factors,
				ShowLetter -> True][[3]], #[[2]]} &, preFactorsOnlyDE, {4}];
		offsetMatrix =
			Map[Function[expr,
			Exponent[
			Times @@
				Power @@@
				Select[FactorList[
				expr], ! FreeQ[#1, eps] && !IndependentOfInvariantsQ[#1, invariants] && #[[2]] >
			0 &], eps]], aPrevious, {3}];
		trafoPowers =
			Table[Table[
			MapIndexed[{#2[[1]], c[#2[[1]], j] - c[#2[[1]], i]} &,
			factors], {j, 1, Length@aPrevious[[1]]}], {i, 1,
			Length@aPrevious[[1]]}];
		powMatrix =
			ReplacePart[
			Table[MapThread[
			Map[Function[
				flist, {flist[[1, 1]],
				Total[Map[Function[x, x[[2]]], flist]]}],
				GatherBy[Join[#1, #2], First]] &, {currentPowers[[nVar]],
				trafoPowers}, 2], {nVar, 1, Length@invariants}],
			Map[# -> Table[{i, 0}, {i, 1, Length@factors}] &,
			Position[Map[PossibleZeroQ, aPrevious, {3}], True]]];
		ordersList = Exponent[#, eps] & /@ factors;
		numeratorContribution =
			Max[Flatten[
			MapThread[
			Function[{powMatrixComponent, offsetComponent},
				offsetComponent +
				Total[Map[
				Function[pows,
					ordersList[[pows[[1]]]]*StepFunction[pows[[2]]]],
				powMatrixComponent]]], {powMatrix, offsetMatrix}, 3], 2]];
		overallFactor =
			Total[
			MapIndexed[ordersList[[#2[[1]]]]*# &,
			Map[Function[
				flist, -Min[
				Map[Function[fac, -StepFunction[-fac[[2]]]], flist]]],
			Sort[GatherBy[
				Flatten[powMatrix,
				3], #[[1]] &], #1[[1, 1]] < #2[[1, 1]] &]]]];
		vars = Select[Variables[powMatrix], #[[2]] =!= 1 &];
		Off[NMinimize::cvmit];
		If[ vars === {},
			sol = {1, {}};,

	(* Mathematica 12 slightly changed the syntax for NMinimze, so account for that here *)
			If[ $VersionNumber >= 12,
				sol = NMinimize[overallFactor + numeratorContribution /. c[_, 1] -> 0, Element[vars, Integers],
				MaxIterations -> 200],
				sol = NMinimize[overallFactor + numeratorContribution /. c[_, 1] -> 0, vars,
				Integers, MaxIterations -> 200]
			];
		];
		On[NMinimize::cvmit];
		If[ sol[[
			1]] - (overallFactor + numeratorContribution /. _c ->
				0) > -0.2,
			trafo = IdentityMatrix[Length@aPrevious[[1]]],
			trafo = DiagonalMatrix[
				Table[Times @@
				MapIndexed[Power[#, c[#2[[1]], i]] &, factors], {i, 1,
				Length@aPrevious[[1]]}]] /. sol[[2]] /. _c -> 0
		];
		Return[{invariants, trafoPrevious.trafo,
			TransformDE[aPrevious, invariants, trafo]}];
	];


ExprPropLetterQ[expr_, invariants_List, alphabet_List,
OptionsPattern[]] :=
	Module[ {remainderList, candidatePositions, selectList, propConst},
		If[ And @@
			Map[PolynomialQ[#, invariants] &, Join[{expr}, alphabet]],
			remainderList =
			Map[Function[letter,
				ReleaseHold[
				And @@ Function[var,
					Hold[PossibleZeroQ[
					PolynomialRemainder[expr, letter, var]]]] /@
				invariants]], alphabet];
			candidatePositions = Position[remainderList, True];
			selectList =
			Select[Map[{Simplify[expr/alphabet[[#[[1]]]]], #} &,
				candidatePositions], NumberQ[#[[1]]] &];
			If[ OptionValue[ShowLetter],
				If[ ! selectList === {},
					propConst = selectList[[1, 1]];
					Return[{True, alphabet[[selectList[[1, 2, 1]]]],
					selectList[[1, 2, 1]], propConst}];,
					Return[{False, {}, {}, {}}];
				];,
				If[ ! selectList === {},
					Return[True],
					Return[False];
				];
			];,
			Return[False];
		];
	];


ExtractDiagonalBlock[a_List, boundaries_List] :=
	Module[ {},
		If[ ! (Length[boundaries] === 2 &&
			And @@ Map[IntegerQ[#] && Positive[#] &,
				boundaries] && (Length[a[[1]]] >= boundaries[[2]] >=
				boundaries[[1]] >= 1)),
			Message[ExtractDiagonalBlock::badbounds];
			Return[False];
		];
		Return[
			Map[Function[delA,
			Take[Map[Take[#, boundaries] &, delA], boundaries]], a]];
	];


ExtractIrreducibles[a_List, OptionsPattern[]] :=
	Module[ {},
		Return[Union[
			Select[Union[(#1[[1]] &) /@
				Flatten[FactorList /@
				Union[Flatten[Denominator[Together[a]]]], 1]], !NumberQ[#1] &&
				If[ OptionValue[AllowEpsDependence] =!= True,
					FreeQ[#1, eps],
					Variables[#1] =!= {eps}
				] &],
			SameTest -> (NumberQ[Simplify[#1/#2]] &)]];
	];


FindAndApplyRelations[alphabet_List, invariants_List, expr_,
preferredTerms_List] :=
	Module[ {occuringPreferredTerms, nonOccuringPreferredTerms, extExpr,
		terms, positionsPreferredterms, coefficients, toLCDFactor,
		termsLCD, monomialLists, gatheredMonomialLists, solution, a,
		indepVariables, eliminatedSol, finalExpr},
		If[ Length@expr === 1,
			Return[expr];,
			occuringPreferredTerms =
			Map[#[[2]] &, Select[expr, MemberQ[preferredTerms, #[[2]]] &]];
			nonOccuringPreferredTerms =
			Complement[preferredTerms, occuringPreferredTerms];
			extExpr = Join[expr, Map[{0, #} &, nonOccuringPreferredTerms]];
			terms = Map[#[[2]] &, extExpr];
			positionsPreferredterms =
			Position[terms, #][[1, 1]] & /@ preferredTerms;
			coefficients = Map[#[[1]] &, extExpr];
			toLCDFactor =
			Times @@ (Select[(Sort[#1, #1[[2]] > #2[[2]] &][[-1]] &) /@
				GatherBy[Flatten[terms, 1], #1[[1]] &], #1[[2]] < 0 &] /.
				Fac[nLetter_, pow_] :> Power[alphabet[[nLetter]], -pow]);
			termsLCD =
			Map[toLCDFactor*
				Times @@ (#1 /.
					Fac[nLetter_, pow_] :> Power[alphabet[[nLetter]], pow]) &,
				terms];
			monomialLists =
			MapIndexed[
			Function[{monomials, nTerm},
				Switch[Head[monomials], Power, {1, monomials, nTerm[[1]]},
				Times, {Select[monomials, NumberQ[#1] &],
				Select[monomials, ! NumberQ[#1] &], nTerm[[1]]},
				Symbol, {1, monomials, nTerm[[1]]},
				Integer, {monomials, 1, nTerm[[1]]},
				Real, {monomials, 1, nTerm[[1]]},
				Rational, {monomials, 1,
				nTerm[[1]]}]], (SummandList[Expand[#1]] &) /@ termsLCD, {2}];
			gatheredMonomialLists =
			GatherBy[Flatten[monomialLists, 1], #1[[2]] &];
			solution =
			Map[#[[1]] -> #[[2]] &,
			Apply[List,
				Reduce[Function[liste,
				Total[(#1[[1]]*a[#1[[3]]] &) /@ liste] == 0] /@
				gatheredMonomialLists, a /@ positionsPreferredterms]]];
			If[ solution === True,
				Return[expr];,
				indepVariables =
				Union[Flatten[(Variables[#1[[2]]] &) /@ solution]];
				eliminatedSol =
				solution /. Map[# -> -coefficients[[#[[1]]]] &, indepVariables];
				finalExpr =
				Select[Map[{#[[2]] + coefficients[[#[[1, 1]]]],
					terms[[#[[1, 1]]]]} &, eliminatedSol], #[[1]] =!= 0 &];
				Return[finalExpr];
			];
		];
	];


FindAnsatzSubsectorD[a_List, invariants_List, sectorBoundaries_List,
previousD_List, OptionsPattern[]] :=
	Module[ {nextEquation, e, c, b},
		nextEquation =
		NextEquationD[a, invariants, sectorBoundaries, previousD];
		If[ nextEquation[[1]] === False,
			Return[{False, {}}];
		];
		e = nextEquation[[1]];
		c = nextEquation[[2]];
		b = nextEquation[[3]];
		Return[CalcAnsatzD[e, c, b, invariants,
			DDeltaDenominatorDegree -> OptionValue[DDeltaDenominatorDegree],
			DDeltaNumeratorDegree -> OptionValue[DDeltaNumeratorDegree]]];
	];


FindAnsatzT[a_List, invariants_List, OptionsPattern[]] :=
	Module[ {irreducibleDenominators, alphabet, mixedLetters, trDlog,
		trDlogZero, maxNegativePowers, negPowerFactors, posPowerFactorsv1,
		posPowerFactorsv2, posPowerFactorsv3, posPowerFactors,
		extAlphabet, combinedFactors},
		StartKernels[];
		If[ ! (IntegerQ[OptionValue[TDeltaDenominatorDegree]] &&
			OptionValue[TDeltaDenominatorDegree] >= 0),
			Message[FindAnsatzT::nintden];
			Return[False];
		];
		If[ ! (IntegerQ[OptionValue[TDeltaNumeratorDegree]] &&
			OptionValue[TDeltaNumeratorDegree] >= 0),
			Message[FindAnsatzT::nintnum];
			Return[False];
		];
		irreducibleDenominators =
			ExtractIrreducibles[a, AllowEpsDependence -> True];
		alphabet = Select[irreducibleDenominators, FreeQ[#, eps] &];
		mixedLetters = Select[irreducibleDenominators, ! FreeQ[#, eps] &];
		trDlog =
			CalculateDlogForm[({{Tr[#]}} &) /@ a, invariants,
			Join[alphabet, mixedLetters]];
		If[ trDlog === False,
			Message[FindAnsatzT::ndlogtr];
			Return[False];
		];
		trDlogZero =
			SeriesCoefficient[Take[trDlog, Length[alphabet]], {eps, 0, 0}];
		maxNegativePowers =
			Select[MapIndexed[{#2[[1]],
				If[ #[[1, 1]] >=
				0,
					-OptionValue[TDeltaDenominatorDegree],
					#[[1, 1]] -
					OptionValue[TDeltaDenominatorDegree]
				]} &,
			trDlogZero], #[[2]] < 0 &];
		negPowerFactors =
			If[ maxNegativePowers === {},
				Map[Power[#, -1] &, ExtractIrreducibles[a]],
				DeleteCases[
				Map[If[ Length[Variables[#1]] < Length[#1],
						False,
						Times @@ #1
					] &,
				Map[Function[powList,
					Power[alphabet[[#[[1]]]], #[[2]]] & /@ powList],
					Flatten[Function[maxPowList,
					Flatten[
						Outer[List,
						Sequence @@
						Function[maxPowListEntry,
							Table[{maxPowListEntry[[1]], pow}, {pow,
							maxPowListEntry[[2]], -1}]] /@ maxPowList, 1],
						Length[maxPowList] - 1]] /@
					DeleteCases[
					Subsets[maxNegativePowers, Length[invariants]], {}], 1]]],
				False]
			];
		posPowerFactorsv1 =
			Join[{1},
			Union[Apply[Times,
			Flatten[Table[
				Tuples[DeleteCases[Variables[a],
				eps], {nLetters}], {nLetters, 1,
				3 + OptionValue[TDeltaNumeratorDegree]}], 1], {1}]]];
		posPowerFactorsv2 =
			Map[#[[2]] &,
			Select[Function[
				monomial, {Total[(#[[2]] &) /@
				Select[FactorList[monomial], ! NumberQ[#[[1]]] &]],
				monomial}] /@
			Union[Flatten[((Numerator[#[[2]]] &) /@
					BreakToIndepSummands[#, invariants, invariants, {}] &) /@
				Numerator /@ Factor /@ Flatten[a]]], #[[1]] <= Infinity &]];
		posPowerFactorsv3 =
			Map[#[[2]] &,
			BreakToIndepSummands[
			Times @@
			MapIndexed[
				Power[alphabet[[#2[[1]]]], StepFunction[#[[1, 1]]]] &,
				trDlogZero], invariants, invariants, {}]];
		posPowerFactors =
			Union[posPowerFactorsv1, posPowerFactorsv2, posPowerFactorsv3];
		extAlphabet = Union[Join[invariants, alphabet]];
		combinedFactors =
			Union[Map[#[[2]] &,
			Flatten[ParallelizeMap[$ComputeParallel][
				BreakToIndepSummands[#, extAlphabet, invariants, {}] &,
				Simplify[
				Union[Flatten[
				Outer[Times, Union@Join[{1}, negPowerFactors],
					Union@Join[{1}, posPowerFactors]]]]]], 1]]];
		Return[ApplyRelations[combinedFactors, extAlphabet, invariants]];
	];


FindConstantNormalization[invariants_List, trafoPrevious_List,
aPrevious_List, OptionsPattern[]] :=
	Module[ {alphabet, dlogForm, consttrafo, freeConsts, fixedPoint,
		trafo},
		alphabet = ExtractIrreducibles[aPrevious];
		If[ Length[trafoPrevious] =!= Length[aPrevious[[1]]],
			Message[FindConstantNormalization::baddims];
			Return[{False, {trafoPrevious, aPrevious}}];
		];
		If[ OptionValue[VerbosityLevel] >= 4,
			Print["Calculating constant normalization."]
		];
		dlogForm = CalculateDlogForm[aPrevious, invariants, alphabet];
		If[ dlogForm === False,
			Message[FindConstantNormalization::ndlog];
			Return[False];
		];
		trafo =
			FixedPoint[
			ConstantNormalizationStep, {dlogForm,
			IdentityMatrix[Length@dlogForm[[1]]]}][[2]];
		Return[{trafoPrevious.trafo,
			TransformDE[aPrevious, invariants, trafo]}];
	];


FindD[e_List, c_List, b_List, alphabet_List, invariants_List,
userProvidedAnsatz_: {}, OptionsPattern[]] :=
	Module[ {bhatAndFactors, bhat, hbar, khat, nmin, res, dhat, fullD,
		indepFactors},
		bhatAndFactors = CalcbhatAndFactors[b, alphabet, invariants];
		bhat = bhatAndFactors[[1]];
		hbar = bhatAndFactors[[2]];
		khat = bhatAndFactors[[3]];
		If[ userProvidedAnsatz === {},
			indepFactors =
			CalcAnsatzD[e, c, b, invariants,
			DDeltaDenominatorDegree ->
				OptionValue[DDeltaDenominatorDegree],
			DDeltaNumeratorDegree -> OptionValue[DDeltaNumeratorDegree]];,
			If[ CheckRationality[userProvidedAnsatz, invariants] &&
			Complement[Variables[userProvidedAnsatz], invariants] === {},
				indepFactors = userProvidedAnsatz;
				StartKernels[];,
				Message[FindD::invansatz];
				Return[False];
			];
		];
		nmin = Sort[Flatten[Exponent[bhat, eps, Min]]][[1]];
		res = NestWhile[
			Function[previousResult,
			CalcNextDn[e, c, bhat, hbar, khat, nmin, alphabet, invariants,
			indepFactors, {previousResult[[1]], previousResult[[2]],
				previousResult[[3]]},
			VerbosityLevel -> OptionValue[VerbosityLevel]]], {{Table[
				Table[\[Beta][nmin - 1, 1, i, j], {j, 1,
				Length[bhat[[1, 1]]]}], {i, 1, Length[bhat[[1]]]}]}, {g[
				0] -> 1}, {}}, ! #1 === False && Length[#1[[3]]] == 0 &, 1];
		If[ res === False,
			Return[False];
		];
		dhat =
			Sum[res[[1, n - nmin + 2]]*Power[eps, n], {n, nmin - 1,
			Length[res[[1]]] + nmin - 2}];
		fullD = dhat/(khat*hbar*res[[3, 1]]);
		Return[fullD];
	];


FindEpsDependentNormalization[a_List, invariants_List] :=
	Module[ {fixedPoint},
		fixedPoint =
			FixedPoint[
			EpsDependentNormalizationStep, {invariants,
			IdentityMatrix[Length[a[[1]]]], a}];
		Return[{fixedPoint[[2]], fixedPoint[[3]]}];
	];


FindNextConstant[{freeConsts_List, previousSol_List}] :=
	Module[ {minimizingFactors},
		minimizingFactors =
			Sort[Map[
			Function[
			const, {const,
				MinimizePrimeFactors[
				Solve[# == 1, const][[1, 1, 2]] /. c[_] -> 1 & /@
				Select[freeConsts, ! FreeQ[#, const] &]]}],
			Variables[freeConsts]], #1[[2, 2]] > #2[[2, 2]] &];
		If[ Length[minimizingFactors] > 0 &&
			minimizingFactors[[1, 2, 2]] > 0,
			Return[{freeConsts /.
				minimizingFactors[[1, 1]] -> minimizingFactors[[1, 2, 1]],
			Append[previousSol,
				minimizingFactors[[1, 1]] -> minimizingFactors[[1, 2, 1]]]}];,
			Return[{freeConsts, previousSol}];
		];
	];


ForwardSolve[{equations_, prevRules_List, vars_List}] :=
	Module[ {allVars, allWithFirstVar, solveVars, sol, rules, newSys},
		If[ equations === False,
			Return[False]
		];
		allVars = Variables[Map[#[[1]] &, equations]];
		allWithFirstVar = Select[equations, ! FreeQ[#, allVars[[1]]] &];
		solveVars =
			Intersection[vars, Variables[Map[#[[1]] &, allWithFirstVar]]];
		Off[Solve::svars];
		sol = Solve[allWithFirstVar, solveVars];
		On[Solve::svars];
		If[ sol === {{}},
			Return[{Complement[equations, allWithFirstVar],
			Append[prevRules, {}], vars}]
		];
		If[ sol === {},
			Return[False]
		];
		rules = Dispatch[sol[[1]]];
		newSys = Union[DeleteCases[equations /. rules, True]];
		Return[{newSys, Append[prevRules, sol[[1]]], vars}];
	];


GatherByDenominator[indepFactorForm_List] :=
	Return[GatherBy[indepFactorForm,
		Function[summand, Select[summand[[2]], #[[2]] < 0 &]]]];


GatherCommonTerms[indepFactorForm_List] :=
	Module[ {sortedTerms},
		sortedTerms =
			Map[Function[
			term, {term[[1]], Sort[term[[2]], #1[[1]] < #2[[1]] &]}],
			indepFactorForm];
		Return[
			Select[Map[
			Function[
			gatheredTerms, {Total@
				Map[Function[term, term[[1]]], gatheredTerms],
				gatheredTerms[[1, 2]]}],
			GatherBy[sortedTerms, #[[2]] &]], ! #[[1]] === 0 &]];
	];


GatherCommonTermsRaw[termList_List, invariants_List] :=
	Module[ {factorsList, splittedFactorsList},
		factorsList = FactorList /@ termList;
		splittedFactorsList =
			Function[
			factors, {Union[
				Select[factors, IndependentOfInvariantsQ[#, invariants] &]],
			Union[Select[
				factors, ! IndependentOfInvariantsQ[#, invariants] &]]}] /@
			factorsList;
		Return[
			Function[commonList,
			Total[Function[term, Times @@ Apply[Power, term[[1]], {1}]] /@
				commonList] Times @@ Apply[Power, commonList[[1, 2]], {1}]] /@
			GatherBy[splittedFactorsList, #1[[2]] &]];
	];


GenericPolynomial[invariants_List, highestDegree_Integer,
identifier_] :=
	Module[ {partitions},
		partitions =
			Map[Function[degree,
			Flatten[Map[
				Permutations[
				Join[#, Table[0, {i, 1, Length@invariants - Length@#}]]] &,
				IntegerPartitions[degree, Length@invariants]], 1]],
			Table[i, {i, 1, highestDegree}]];
		Return[
			c[identifier, 0, 1] +
			Sum[Total[
			MapIndexed[c[identifier, degree, #2[[1]]]*# &,
				Flatten[Map[
				Function[partition,
				Times @@
					MapIndexed[
					Function[{pow, nVar}, Power[invariants[[nVar]], pow]],
					partition]], partitions[[degree]]], 1]]], {degree, 1,
			highestDegree}]];
	];


IndependentOfInvariantsQ[expr_, invariants_List] :=
	Return[And @@ Map[Function[var, FreeQ[expr, var]], invariants]];


InsertBlockIntoIdentity[blockMatrix_List, dim_Integer,
blockStartPosition_Integer] :=
	Return[ReplacePart[IdentityMatrix[dim],
		Map[{#[[1, 1]] + blockStartPosition - 1, #[[1, 2]] +
			blockStartPosition - 1} -> #[[2]] &,
		Flatten[MapIndexed[#2 -> # &, blockMatrix, {2}], 1]]]];


InsertDIntoIdentity[sectorBoundaries_List, fullD_List] :=
	Module[ {trafoSize, trafo},
		trafoSize =
			sectorBoundaries[[Position[sectorBoundaries,
				Length[fullD[[1]]]][[1, 1]] + 1]][[2]];
		trafo =
			Factor@ReplacePart[IdentityMatrix[trafoSize],
			Flatten[Table[
				Table[{i, j} ->
				fullD[[i - (trafoSize - Length[fullD]), j]], {i,
				trafoSize - Length[fullD] + 1, trafoSize}], {j, 1,
				trafoSize - Length[fullD]}], 1]];
		Return[trafo];
	];


LinearSystemSolver[parameterEquations_List, vars_List,
maxLength_Integer] :=
	Module[ {preforwardSolved, sol, forwardSolved},
		preforwardSolved =
			NestWhile[
			Function[prevResult,
			ForwardSolve[
			FixedPoint[SolveSimpleEqns, prevResult,
				SameTest -> (#1[[1]] === #2[[1]] ||
					Length[#1[[1]]] <
					maxLength &)]]], {parameterEquations, {},
			vars}, #1 =!= False && Length[#1[[1]]] > maxLength &];
		If[ preforwardSolved === False,
			Return[{}];
		];
		sol = Solve[preforwardSolved[[1]],
			Variables[Map[#[[1]] &, preforwardSolved[[1]]]]];
		If[ sol === {},
			Return[{}];
		];
		forwardSolved = Append[preforwardSolved[[2]], sol[[1]]];
		Return[{Fold[Join[#2 /. Dispatch[#1], #1] &, {},
			Reverse[forwardSolved]]}];
	];


LinearTest[expr_] :=
	Return[If[ Sort[Function[monomial,
			Total[Map[Function[term, term[[2]]],
			Select[FactorList[monomial], ! NumberQ[#1[[1]]] &]]]] /@
		MonomialList[expr]][[-1]] > 1,
			False,
			True
		]];


MinimizePrimeFactors[ratList_List] :=
	Module[ {facIntList, nPowersTotal, primeFactors, minSolution,
		minPowersTotal, deltaPowers, minimizingFactor},
		facIntList = FactorInteger /@ ratList;
		nPowersTotal =
			Total[Abs[#[[2]]] & /@
			Select[Select[Flatten[facIntList, 1], FreeQ[#, {-1, _}] &],
			FreeQ[#, {1, _}] &]];
		primeFactors =
			DeleteCases[
			DeleteCases[
			Union@Flatten[
				Map[Function[facTerm, Map[#[[1]] &, facTerm]],
				facIntList]], -1], 1];
		minSolution =
			Map[Function[
			primeFactor, {primeFactor,
			Minimize[
				Total@Map[Abs[p + #[[1, 2]]] &,
				Function[facTerm,
					Select[facTerm, ! FreeQ[#, {primeFactor, _}] &]] /@
					facIntList /. {} -> {{primeFactor, 0}}], p]}],
			primeFactors];
		minPowersTotal = Total[#[[2, 1]] & /@ minSolution];
		deltaPowers = nPowersTotal - minPowersTotal;
		minimizingFactor =
			Times @@ (Power[#[[1]], #[[2, 2, 1, 2]]] & /@ minSolution);
		Return[{1/minimizingFactor, deltaPowers}];
	];


NextBlockBoundaries[aPrevious_List, sectorBoundaries_List] :=
	If[ Length[aPrevious[[1]]] === 0,
		Return[sectorBoundaries[[1]]],
		Return[sectorBoundaries[[Position[sectorBoundaries,
				Length[aPrevious[[1]]]][[1, 1]] + 1]]]
	];


NextEquationD[a_List, invariants_List, sectorBoundaries_List,
previousD_List] :=
	Module[ {position, subSector, subSectorSize, nLowerSector, e, c, b,
		newc, cmix, bbar},
		If[ ! CheckDE[a, invariants],
			Return[{False, {}}]
		];
		position =
			Select[Position[sectorBoundaries, Length[a[[1]]]], #[[2]] === 2 &];
		If[ position === {},
			Message[NextEquationD::baddims1];
			Return[{False, {}}];,
			subSector = position[[1, 1]];
		];
		subSectorSize =
			sectorBoundaries[[subSector, 2]] -
			sectorBoundaries[[subSector, 1]] + 1;
		If[ Length[previousD] =!= subSectorSize,
			Message[NextEquationD::baddims2];
			Return[{False, {}}];
		];
		If[ ! MemberQ[Prepend[#[[2]] & /@ sectorBoundaries, 0],
			Length[a[[1]]] - Length[previousD[[1]]] - subSectorSize],
			Message[NextEquationD::baddims3];
			Return[{False, {}}];
		];
		nLowerSector =
			Position[sectorBoundaries,
			sectorBoundaries[[subSector, 1]] - Length[previousD[[1]]] -
	1][[1, 1]];
		e = SeriesCoefficient[
			ExtractDiagonalBlock[
			a, {Length[a[[1]]] - subSectorSize + 1, Length[a[[1]]]}], {eps,
			0, 1}];
		c = SeriesCoefficient[
			ExtractDiagonalBlock[
			a, {1, Length[a[[1]]] - subSectorSize}], {eps, 0, 1}];
		b = Function[M,
			Take[(Take[#1, {sectorBoundaries[[nLowerSector, 1]],
					sectorBoundaries[[nLowerSector, 2]]}] &) /@
				M, {Length[M] - subSectorSize + 1, Length[M]}]] /@ a;
		newc =
			ExtractDiagonalBlock[
			c, {sectorBoundaries[[nLowerSector]][[1]],
			sectorBoundaries[[nLowerSector]][[2]]}];
		If[ sectorBoundaries[[nLowerSector]][[2]] == Length[c[[1]]],
			bbar = b;,
			cmix = Table[(Take[#1, sectorBoundaries[[nLowerSector]]] &) /@
			Take[c[[nVar]], {sectorBoundaries[[nLowerSector +
					1]][[1]], -1}], {nVar, 1, Length[invariants]}];
			bbar =
			b + Table[-eps previousD.cmix[[nVar]], {nVar, 1,
				Length[invariants]}];
		];
		Return[{e, newc, bbar, subSector, nLowerSector}];
	];


NullstellensatzCertificate[polyList_List, invariants_List] :=
	Module[ {solution, coeffList, coefficients, highestDegree,
		additionalRules, minimalSolution, certificate},
		solution = {};
		Off[Solve::svars];
		For[highestDegree = 0, solution == {}, highestDegree++,
			coeffList =
			Flatten[CoefficientList[
			Total[MapIndexed[
				GenericPolynomial[invariants, highestDegree, #2[[1]]]*# &,
				polyList]], invariants], 2];
			coefficients =
			Flatten[Table[
			Table[Table[
				c[nPoly, degree, nCoeff], {nCoeff, 1,
				Length[Flatten[
					Map[Permutations[
					Join[#,
						Table[0, {i, 1, Length@invariants - Length@#}]]] &,
					IntegerPartitions[1, Length@invariants]],
					degree]]}], {degree, 0, highestDegree}], {nPoly, 1,
				Length@polyList}], 2];
			solution =
			Solve[coeffList[[1]] == 1 &&
			And @@ Map[# == 0 &, Drop[coeffList, 1]], coefficients];];
		On[Solve::svars];
		additionalRules =
			Map[# -> 0 &,
			Select[Variables[Map[#[[2]] &, solution[[1]]]], Head[#] === c &]];
		minimalSolution =
			Join[solution[[1]] /. additionalRules, additionalRules];
		certificate =
			MapIndexed[
			GenericPolynomial[invariants, highestDegree - 1, #2[[1]]] &,
			polyList] /. minimalSolution;
		Return[certificate];
	];


ParallelizeMap[$ComputeParallel_] :=
	If[ $ComputeParallel === True,
		Return[ParallelMap],
		Return[Map];
	];


ParallelizeTable[$ComputeParallel_] :=
	If[ $ComputeParallel === True,
		Return[ParallelTable],
		Return[Table];
	];


PolishStep[currentSol_List, simplifiedPreTrafo_List] :=
	Module[ {det, val},
		If[ currentSol[[2, 1, 2]] == 0,
			Return[{Append[currentSol[[1]], currentSol[[2, 1]]],
			Drop[currentSol[[2]], 1]}];
		];
		det = 0;
		val = 0;
		While[det === 0,
			det = Det[
			simplifiedPreTrafo /. Dispatch@currentSol[[1]] /.
				Dispatch@Drop[currentSol[[2]], 1] /.
			currentSol[[2, 1, 1]] -> val];
			If[ det === 0,
				val++;
			];];
		Return[{Append[currentSol[[1]], currentSol[[2, 1, 1]] -> val],
			Drop[currentSol[[2]], 1]}];
	];


RatFunctionZeroCoeffs[rawEquation_, invariants_List] :=
	Module[ {totalDenNumList, preDenNumList, epsDepDens, denNumList,
		occuringFactors, factorFormList, cleanFactorList, denominators,
		commonDenominatorPowers, transitionFactors, expandedPoly},
		totalDenNumList = ({Numerator[#], Denominator[#]} &) /@
			SummandList[Expand[rawEquation]];
		preDenNumList =
			Function[
			sameDenGroup, {Total[Function[term, term[[1]]] /@ sameDenGroup],
				sameDenGroup[[1, 2]]}] /@ GatherBy[totalDenNumList, #1[[2]] &];
		epsDepDens = Select[preDenNumList, ! FreeQ[#[[2]], eps] &];
		denNumList =
			Join[(SplitEpsFactors[#, invariants] &) /@ epsDepDens,
			Complement[preDenNumList, epsDepDens]];
		occuringFactors =
			Union[Select[
			Union[Flatten[FactorList[#[[2]]] & /@ denNumList]], !NumberQ[#] &], SameTest -> (NumberQ@Simplify[#1/#2] &)];
		factorFormList = ({#[[1]],
				ToFactorForm[#[[2]], occuringFactors, invariants]} &) /@
			denNumList;
		cleanFactorList =
			Function[
			sameDenGroup, {Total[Function[term, term[[1]]] /@ sameDenGroup],
				sameDenGroup[[1, 2]]}] /@
			GatherBy[({#[[1]]/#[[2, 1]], #[[2, 2]]} &) /@
			factorFormList, #[[2]] &];
		denominators = (#[[2]] &) /@ cleanFactorList;
		commonDenominatorPowers = (If[ # === {},
									0,
									#[[1, 2]]
								] &) /@
			Table[Sort[
			Flatten[Function[den, Select[den, #[[1]] === nLetter &]] /@
				denominators, 1], #1[[2]] > #2[[2]] &], {nLetter, 1,
			Length[occuringFactors]}];
		transitionFactors =
			Function[den,
			Times @@
			MapIndexed[
				Function[{pow, nLetter},
				Power[occuringFactors[[nLetter[[1]]]], pow]],
				ReplacePart[commonDenominatorPowers,
				Function[letter,
				letter[[1]] ->
					commonDenominatorPowers[[letter[[1]]]] - letter[[2]]] /@
				den]]] /@ denominators;
		expandedPoly =
			Total[Expand /@
			MapIndexed[#[[1]]*transitionFactors[[#2[[1]]]] &,
			cleanFactorList]];
		Return[
			Union[(#[[2]] &) /@
			CoefficientRules[expandedPoly, invariants]]];
	];


RecursivelyTransformSectors[aFull_List, invariants_List,
sectorBoundaries_List, {nSecStart_Integer?Positive,
	nSecStop_Integer?Positive}, trafoPrevious_List: {},
aPrevious_List: {{}}, OptionsPattern[]] :=
	Module[ {previousSize, resultFull, resultFullNormalized},
		If[ ! CheckBoundariesConsistency[sectorBoundaries],
			Return[Null]
		];
		If[ ! CheckDE[aFull, invariants],
			Return[Null]
		];
		If[ ! (nSecStart <= nSecStop),
			Message[RecursivelyTransformSectors::badrange];
			Return[Null];
		];
		If[ nSecStop > Length[sectorBoundaries],
			Message[RecursivelyTransformSectors::badbounds1];
			Return[Null];
		];
		If[ sectorBoundaries[[nSecStop, 2]] > Length[aFull[[1]]],
			Message[RecursivelyTransformSectors::badbounds2];
			Return[Null];
		];
		previousSize =
			If[ nSecStart =!= 1,
				sectorBoundaries[[nSecStart - 1, 2]],
				0
			];
		If[ previousSize =!= Length[trafoPrevious] ||
			previousSize =!= Length[aPrevious[[1]]],
			Message[RecursivelyTransformSectors::baddims];
			Return[Null];
		];
		If[ previousSize =!= 0,
			If[ ! CheckDE[aPrevious, invariants],
				Return[Null]
			];
		];
		StartKernels[];
		resultFull =
			Catch[Nest[
			Function[{previousResult},
			If[ previousResult[[1]] === False,
				Throw[previousResult],
				TransformNextSector[aFull, invariants, sectorBoundaries,
				previousResult[[1]], previousResult[[2]],
				TDeltaDenominatorDegree ->
				OptionValue[TDeltaDenominatorDegree],
				TDeltaNumeratorDegree -> OptionValue[TDeltaNumeratorDegree],
				DDeltaDenominatorDegree ->
				OptionValue[DDeltaDenominatorDegree],
				DDeltaNumeratorDegree -> OptionValue[DDeltaNumeratorDegree],
				VerbosityLevel ->
				OptionValue[VerbosityLevel]]
			]], {trafoPrevious, aPrevious},
			nSecStop - nSecStart + 1]];
		If[ resultFull === False,
			Return[resultFull];
		];
		If[ OptionValue[FinalConstantNormalization] === True,
			resultFullNormalized =
			FindConstantNormalization[invariants, resultFull[[1]],
			resultFull[[2]]];
			Return[resultFullNormalized];,
			Return[resultFull];
		];
	];


RepeatedlySplitExpr[expr_, invariants_List] :=
	Return[NestWhile[
		Function[termList,
		GatherCommonTermsRaw[
		Flatten[Map[SplitAlgebraicallyDependent[#, invariants] &,
			termList], 1], invariants]],
		NestWhile[
		Function[termList,
		GatherCommonTermsRaw[
		Flatten[Map[SplitEmptyIntersection[#, invariants] &, termList],
			1], invariants]],
		GatherCommonTermsRaw[SummandList[Expand[expr]], invariants],
		Or @@ Map[
			Function[term,
			EmptyIntersectionQ[DenominatorFactors[term, invariants],
			invariants]], #] &],
		Or @@ Function[
			term, ! AlgebraicallyIndepQ[
			DenominatorFactors[term, invariants], invariants]] /@ # &]
	];


ReplaceVarByNonSingularValue[solution_List, var_] :=
	Module[ {forbiddenValues, smallestNonForbiddenValue},
		forbiddenValues =
			Union[Select[
			Map[Solve[#[[1]] == 0, var][[1, 1, 2]] &,
			Select[Join[
				Flatten[FactorList /@
				Select[Flatten[solution], ! FreeQ[#, var] &], 1],
				FactorList[Det[solution]]], ! FreeQ[#, var] &]],
			FreeQ[#, eps] &]];
		smallestNonForbiddenValue =
			If[ Select[forbiddenValues, NumberQ[#] &] === {},
				0,
				Floor[Sort[Select[forbiddenValues, NumberQ[#] &]][[-1]] + 1]
			];
		Return[solution /. var -> smallestNonForbiddenValue];
	];


SectorBoundariesFromDE[a_List] :=
	Module[ {reduceda},
		reduceda = Map[If[ PossibleZeroQ[#],
						0,
						1
					] &, a, {3}];
		Return[
			NestWhile[
			Function[currentBoundaries,
			Select[If[ CheckSectorBoundaries[reduceda, currentBoundaries],
					Append[currentBoundaries, {currentBoundaries[[-1, -1]] + 1,
					currentBoundaries[[-1, -1]] + 1}],
					Join[Drop[
					currentBoundaries, -2], {{currentBoundaries[[-2, 1]],
					currentBoundaries[[-2, 2]] +
						1}, {currentBoundaries[[-1, 1]] + 1,
					currentBoundaries[[-1, 1]] + 1}}]
				],
			FreeQ[#, x_ /; x > Length[reduceda[[1]]]] &]], {{1,
			1}}, ! (#[[-1, 2]] === Length[a[[1]]] &&
				CheckSectorBoundaries[reduceda, #]) &]];
	];


SectorBoundariesFromID[masterIntegrals_List] :=
	Module[ {secIDList},
		If[ OrderedQ[masterIntegrals,
			SectorID[#1[[2]]] <= SectorID[#2[[2]]] &],
			secIDList = SectorID[#[[2]]] & /@ masterIntegrals;
			Return[
			Nest[Function[currentBoundaries,
				If[ secIDList[[currentBoundaries[[-1, 2]]]] ===
				secIDList[[currentBoundaries[[-1, 2]] + 1]],
					Join[Drop[
					currentBoundaries, -1], {{currentBoundaries[[-1, 1]],
						currentBoundaries[[-1, 2]] + 1}}],
					Append[currentBoundaries, {currentBoundaries[[-1, -1]] + 1,
					currentBoundaries[[-1, -1]] + 1}]
				]], {{1, 1}},
			Length[masterIntegrals] - 1]];,
			Message[SectorBoundariesFromID::noorder];
			Return[False];
		];
	];


SectorID[propagatorPowers_List] :=
	Return[Total@
		MapIndexed[If[ # > 0,
					2^(#2[[1]] - 1),
					0
				] &, propagatorPowers]];


SeparateNumericalFactors[expr_, numberHeads_List] :=
	Module[ {factorsList, numericalFactors, algebraicFactors},
		If[ Head[expr] === Times,
			factorsList = Apply[List, expr];
			numericalFactors =
			Select[factorsList,
			NumberQ[#] ||
				And @@ Map[
				Function[Var,
					MemberQ[numberHeads, Var] ||
					MemberQ[numberHeads, Head[Var]]], Variables[#]] &];
			algebraicFactors = Complement[factorsList, numericalFactors];
			Return[{Times @@ numericalFactors, Times @@ algebraicFactors}];,
			If[ NumberQ[expr] ||
				And @@ Map[
				Function[Var,
				MemberQ[numberHeads, Var] ||
					MemberQ[numberHeads, Head[Var]]], Variables[expr]],
				Return[{expr, 1}];,
				Return[{1, expr}];
			];
		];
	];


ShrinkEquationSet[parameterEquations_List, vars_List] :=
	Module[ {expandedExtractedParameterEqns, singleTerms, termstoC,
		ctoTerms, cEqns, eqVars, coeffMatrix, coeffMatrixReduced, newEqns,
		paramEqns},
		If[ parameterEquations === {},
			Return[{}];
		];
		If[ ! FreeQ[parameterEquations, False],
			Return[False]
		];
		expandedExtractedParameterEqns =
			DeleteCases[(Expand[#1[[1]]] &) /@ parameterEquations, 0];
		If[ expandedExtractedParameterEqns === {},
			Return[{}];
		];
		singleTerms =
			DeleteCases[
			Union[Flatten[
			Function[lhs,
				Function[prod,
				If[ Head[prod] === Times,
					Select[prod, ! NumberQ[#1] &],
					If[ MemberQ[vars, prod],
						prod,
						If[ Head[prod] === Power,
							prod
						]
					]
				]] /@ SummandList[lhs]] /@
				expandedExtractedParameterEqns]], Null];
		termstoC =
			MapIndexed[#1 -> xc[#2[[1]]] &,
			Join[Select[singleTerms, MemberQ[{Times, Power}, Head[#]] &],
			Select[singleTerms, ! MemberQ[{Times, Power}, Head[#]] &]]];
		ctoTerms = (#1[[2]] -> #1[[1]] &) /@ termstoC;
		If[ ParallelizeMap[$ComputeParallel] === ParallelMap,
			cEqns =
			ParallelMap[(#1 /. termstoC) == 0 &,
			expandedExtractedParameterEqns, DistributedContexts -> All];,
			cEqns = ((#1 /. termstoC) == 0 &) /@
			expandedExtractedParameterEqns;
		];
		eqVars = (Variables[#1[[1]]] &) /@ cEqns;
		coeffMatrix =
			SparseArray[
			Flatten[Table[
			Append[MapIndexed[{nEqn,
					eqVars[[nEqn, #2[[1]]]][[1]] + 1} -> #1[[2]] &,
				Take[CoefficientRules[cEqns[[nEqn, 1]], eqVars[[nEqn]]],
				Length[eqVars[[nEqn]]]]], {nEqn, 1} ->
				cEqns[[nEqn, 1]] /. _xc -> 0], {nEqn, 1, Length[cEqns]}],
			1]];
		coeffMatrixReduced = RowReduce[coeffMatrix];
		newEqns =
			coeffMatrixReduced.Prepend[Table[xc[i], {i, 1, Length[termstoC]}],
			1];
		paramEqns = (#1 == 0 &) /@ newEqns /. Dispatch[ctoTerms];
		Return[DeleteCases[paramEqns, True]]
	];


ShrinkNElimLinearStep[{prevNLEquations_List, prevLinearSoln_List,
	vars_List}] :=
	Module[ {elimResult, shrinkResult},
		elimResult =
			EliminateLinearEqns[prevNLEquations, prevLinearSoln, vars];
		shrinkResult = ShrinkEquationSet[elimResult[[1]], vars];
		Return[{shrinkResult, elimResult[[2]], vars}]
	];


SolveConstTrafoStep[{prevSol_List, currentCoeff_}, cmatrix_List] :=
	Module[ {val, det, sol},
		SeedRandom[$RandomSeed];
		val = 0;
		det = 0;
		While[det === 0, sol = Solve[currentCoeff[[1]] == val][[1]];
						det =
						Det[cmatrix /. prevSol /. sol /.
						MapThread[#1 -> #2 &, {Flatten[cmatrix],
							RandomInteger[{1, Prime[Power[10, 10]]},
							Power[Length[cmatrix], 2]]}]];
						If[ det === 0,
							val++;
						]];
		Return[{Join[prevSol /. sol, sol],
			Select[Simplify[currentCoeff /. sol], ! FreeQ[#, c] &]}]
	];


SolveLinearPart[equations_List] :=
	Module[ {occuringVars, orderedVars, unionEquations, shrinkedResult,
		newNonLinearEqns, linearSoln},
		occuringVars = Variables[equations /. Equal -> List];
		orderedVars =
			Join[Select[occuringVars, Head[#1] == \[Beta] &],
			Select[occuringVars, Head[#1] == \[Alpha] &]];
		Off[Solve::svars];
		Off[Solve::fulldim];
		unionEquations = Union[equations];
		shrinkedResult =
			FixedPoint[
			ShrinkNElimLinearStep, {unionEquations, {}, orderedVars}];
		If[ shrinkedResult[[1]] === False,
			Return[{}];
		];
		newNonLinearEqns = shrinkedResult[[1]];
		linearSoln = {shrinkedResult[[2]]};
		Return[{linearSoln, newNonLinearEqns}];
	];


SolveSimpleEqns[{unsolvedLinearEqns_, solvedLinearEqns_, vars_}] :=
	Module[ {newSimpleEqns, solNewSimpleEqns, rules, nSys},
		If[ ! FreeQ[unsolvedLinearEqns, False],
			Return[{False, {}, {}}];
		];
		newSimpleEqns =
			Select[unsolvedLinearEqns, Length[Variables[#1[[1]]]] === 1 &];
		Off[Solve::svars];
		solNewSimpleEqns =
			Solve[newSimpleEqns,
			Intersection[vars, Variables[Map[#[[1]] &, newSimpleEqns]]]];
		On[Solve::svars];
		If[ solNewSimpleEqns === {},
			Return[{False, {}, {}}];
		];
		rules = Dispatch[solNewSimpleEqns[[1]]];
		nSys = Union[DeleteCases[unsolvedLinearEqns /. rules, True]];
		Return[{nSys, Append[solvedLinearEqns, solNewSimpleEqns[[1]]],
			vars}];
	];


SplitAlgebraicallyDependent[expr_, invariants_List] :=
	Module[ {denFactors, nonConstantDenFactors, constantDenFactor,
		denLetters, algIndepTest, annihilatingPoly,
		sortedAnnihilatingPolyMonomials, splittedDenominator},
		denFactors =
			DenominatorFactors[expr, invariants,
			ShowPowersAndPrefactor -> True];
		nonConstantDenFactors = (Power[#[[1]], #[[2]]] &) /@
			denFactors[[2]];
		constantDenFactor =
			Times @@ (Power[#[[1]], #[[2]]] &) /@ denFactors[[1]];
		denLetters = (#1[[1]] &) /@ denFactors[[2]];
		algIndepTest =
			AlgebraicallyIndepQ[denLetters, invariants,
			ShowAnnihilatingPoly -> False];
		If[ ! algIndepTest,
			annihilatingPoly =
			AlgebraicallyIndepQ[nonConstantDenFactors, invariants,
			ShowAnnihilatingPoly -> True][[2, 1]];
			sortedAnnihilatingPolyMonomials =
			Sort[CoefficientRules[annihilatingPoly,
			Table[Y[i], {i, 1, Length[nonConstantDenFactors]}]],
			Total[#1[[1]]] < Total[#2[[1]]] &];
			splittedDenominator =
			Map[(-1)*#[[
				2]]/(constantDenFactor*
				sortedAnnihilatingPolyMonomials[[1, 2]]*
				Times @@
					MapIndexed[
					Function[{pow, nFactor},
					Power[nonConstantDenFactors[[nFactor[[1]]]], pow]], #[[
					1]]]) &,
			Map[{-#[[1]] + 1 + sortedAnnihilatingPolyMonomials[[1, 1]], #[[
				2]]} &, Drop[sortedAnnihilatingPolyMonomials, 1]]];
			Return[
			Flatten[Outer[Times, SummandList[Numerator[expr]],
			splittedDenominator], 1]];,
			Return[
			SummandList[
				Numerator[expr]]/(constantDenFactor*
				Times @@ nonConstantDenFactors)];
		];
	];



SplitEmptyIntersection[expr_, invariants_List] :=
	Module[ {denFactors, denLetters, certificate},
		denFactors =
			DenominatorFactors[expr, invariants,
			ShowPowersAndPrefactor -> True];
		denLetters = #[[1]] & /@ denFactors[[2]];
		If[ EmptyIntersectionQ[denLetters, invariants],
			certificate = NullstellensatzCertificate[denLetters, invariants];
			Return[
			Flatten[Map[
			If[ ! IndependentOfInvariantsQ[Numerator[#], invariants],
				SummandList[
				Expand[Numerator[#], var_ /; MemberQ[invariants, var]]]/
				Denominator[#],
				#
			] &,
			DeleteCases[(1/(Times @@ (Power @@@ (denFactors[[1]]))))*
				Numerator[expr]*
				MapIndexed[#/(Times @@
					Power @@@
					ReplacePart[
						denFactors[[2]], #2[[1]] -> {denFactors[[2, #2[[1]],
							1]], denFactors[[2, #2[[1]], 2]] - 1}]) &,
				certificate], 0]], 1]];,
			Return[
			Flatten[Map[
			If[ ! IndependentOfInvariantsQ[Numerator[#], invariants] &&
			Head@Collect[Numerator[#], invariants] === Plus,
				Apply[List, Collect[Numerator[#], invariants]]/
				Denominator[#],
				#
			] &, SummandList[expr]], 1]];
		];
	];


SplitEpsFactors[expr_List, invariants_List] :=
	Module[ {fullFactorList, indepFactorList, factor},
		fullFactorList = FactorList[expr[[2]]];
		indepFactorList =
			Select[fullFactorList,
			IndependentOfInvariantsQ[#, invariants] &];
		factor = Times @@ Power @@@ indepFactorList;
		Return[{expr[[1]]/factor,
			Times @@
			Power @@@ Complement[fullFactorList, indepFactorList]}];
	];


SplitNumerator[group_List, alphabet_List, invariants_List] :=
	Module[ {num, backSubstitutionRules, denFactors, allReductions,
		remainderLessReductions, constantRemainderReductions, reduction,
		containedInIdeal, remainder},
		num = Total@
			MapIndexed[
			Function[{term, nTerm},
				prefactor[nTerm[[1]]]*
				Times @@ Join[{1}, Select[term[[2]], #[[2]] > 0 &]]],
			group] /.
			Fac[nLetter_, pow_] :> Power[alphabet[[nLetter]], pow];
		If[ IndependentOfInvariantsQ[num, invariants],
			Return[group];,
			backSubstitutionRules =
			MapIndexed[
			Function[{term, nTerm}, prefactor[nTerm[[1]]] -> term[[1]]],
			group];
			denFactors = Select[group[[1, 2]], #[[2]] < 0 &];
			allReductions =
			Map[PolynomialReduce[num,
				denFactors /.
				Fac[NLetter_, pow_] :> alphabet[[NLetter]], #] &,
			Permutations[invariants]] /. backSubstitutionRules;
			remainderLessReductions = Select[allReductions, #[[2]] === 0 &];
			constantRemainderReductions =
			Select[allReductions,
			FreeQ[#[[2]], var_ /; MemberQ[invariants, var]] &];
			reduction =
			Join[remainderLessReductions, constantRemainderReductions,
			allReductions][[1]];
			containedInIdeal =
			Flatten[MapIndexed[
			Function[{numCoeff, nFactor},
				Map[Function[
				term, {term[[1]],
				Join[term[[2]],
					Select[denFactors /.
					denFactors[[nFactor[[1]]]] ->
					Fac[denFactors[[nFactor[[1]], 1]],
						denFactors[[nFactor[[1]], 2]] + 1], #[[2]] =!=
					0 &]]}],
				GatherCommonTerms@
				ToIndepFactorForm[numCoeff, alphabet, invariants]]],
			reduction[[1]]], 1];
			remainder =
			Map[{#[[1]], Join[#[[2]], denFactors]} &,
			ToIndepFactorForm[reduction[[2]], alphabet, invariants]];
			Return[
			Select[Join[containedInIdeal, remainder], ! #[[1]] === 0 &]];
		];
	];


StartKernels[] :=
	Module[ {},
		If[ ValueQ[$ComputeParallel],
			If[ $ComputeParallel === True,
				If[ ValueQ[$NParallelKernels],
					If[ Length[Kernels[]] < $NParallelKernels,
						LaunchKernels[$NParallelKernels - Length[Kernels[]]];
					];,
					LaunchKernels[];
				];,
				CloseKernels[];
			];,
			CloseKernels[];
		];
	];


StepFunction[x_] :=
	Return[If[ x > 0,
			x,
			0
		]];


SummandList[expr_] :=
	Return[If[ Head[expr] === Plus,
			Apply[List, expr],
			{expr}
		]];


ToFactorForm[expr_, alphabet_List, invariants_List] :=
	Module[ {separated, factors, constantFactors, nonConstantFactors,
		letterNumbers, prefactor},
		separated =
			SeparateNumericalFactors[expr, {\[Alpha], \[Beta], eps}];
		If[ ! separated[[2]] === 1,
			factors = FactorList[separated[[2]]];
			constantFactors =
			Select[FactorList[separated[[2]]], NumberQ[#[[1]]] &];
			nonConstantFactors = Complement[factors, constantFactors];
			letterNumbers =
			MapIndexed[{#[[4]], #[[3]],
				nonConstantFactors[[#2[[1]],
				2]]} &, (ExprPropLetterQ[#1[[1]], invariants, alphabet,
				ShowLetter -> True] &) /@ nonConstantFactors],
			letterNumbers = {};
			constantFactors = {};
		];
		prefactor =
			separated[[1]]*
			Times @@ Apply[Power, constantFactors, {1}] Times @@
			Map[Power[#[[1]], #[[3]]] &, letterNumbers];
		Return[{prefactor, (Fac[#1[[2]], #1[[3]]] &) /@ letterNumbers}];
	];


ToIndepFactorForm[expr_, alphabet_List, invariants_List] :=
	Return[Map[ToFactorForm[#, alphabet, invariants] &,
		RepeatedlySplitExpr[expr, invariants]]];


TransformDE[a_, invariants_, t_, OptionsPattern[]] :=
	Module[ {tInverse},
		If[ ! CheckDE[a, invariants],
			Return[Null]
		];
		If[ Length[t] =!= Length[a[[1]]],
			Message[TransformDE::mismatch];
			Return[Null];
		];
		If[ MatrixRank[t] === Length[t[[1]]],
			tInverse = CalcInverse[t];
			If[ OptionValue[SimplifyResult] === True,
				Return[
				MapIndexed[
					Simplify[
					tInverse.#.t - tInverse.D[t, invariants[[#2[[1]]]]]] &,
					a]];,
				Return[
				MapIndexed[
					tInverse.#.t - tInverse.D[t, invariants[[#2[[1]]]]] &, a]];
			];,
			Message[TransformDE::notinv];
			Return[Null];
		];
	];


TransformDiagonalBlock[a_List, invariants_List,
userProvidedAnsatz_List: {}, OptionsPattern[]] :=
	Module[ {irreducibleDenominators, alphabet, normRes, aNormed,
		mixedLetters, trDlog, nonZeroTrCoeffs, mixedContribution,
		pureContribution, f, nonSingularPoint, aHat, lMAX, lMIN, kMAX,
		kMIN, indepFactors, trLinear, denominatorFactors,
		denominatorLetterNumbers, traceContraints, trafo, res},
		If[ ! CheckDE[a, invariants],
			Return[False];
		];
		If[ ! CheckRationality[a, invariants],
			Message[TransformDiagonalBlock::nonrational];
			Return[False];
		];
		If[ a ===
			Table[Table[
			Table[0, {j, 1, Length[a[[1]]]}], {i, 1, Length[a[[1]]]}], {k,
			1, Length[invariants]}],
			Return[{IdentityMatrix[Length[a[[1]]]], a}];
		];
		irreducibleDenominators =
			ExtractIrreducibles[a, AllowEpsDependence -> True];
		alphabet =
			Union[Select[
			Join[irreducibleDenominators,
			ExtractIrreducibles[userProvidedAnsatz]], FreeQ[#, eps] &],
			SameTest -> (NumberQ[Simplify[#1/#2]] &)];
		mixedLetters = Complement[irreducibleDenominators, alphabet];
		If[ CheckEpsForm[a, invariants, alphabet],
			Return[{IdentityMatrix[Length[a[[1]]]], a}];
		];
		normRes =
			If[ OptionValue[PreRescale] =!=
			True,
				{IdentityMatrix[Length[a[[1]]]], a},
				FindEpsDependentNormalization[a, invariants]
			];
		aNormed = normRes[[2]];
		trDlog =
			CalculateDlogForm[{{Tr[#]}} & /@ aNormed, invariants,
			Join[alphabet, mixedLetters]];
		If[ trDlog === False,
			Message[TransformDiagonalBlock::noepsform];
			Return[False];
		];
		nonZeroTrCoeffs =
			DeleteCases[Map[#[[1, 1]] &, Take[trDlog, Length[alphabet]]], 0];
		If[ ! (And @@
				Map[PolynomialQ[#, eps] &,
				nonZeroTrCoeffs] && (Min[
				Exponent[nonZeroTrCoeffs, eps, Min]] >=
				0) && (Max[Exponent[nonZeroTrCoeffs, eps, Max]] <= 1) &&
			FreeQ[Drop[trDlog, Length[alphabet]], eps]),
			Message[TransformDiagonalBlock::noepsform];
			Return[False];
		];
		mixedContribution =
			Times @@
			MapIndexed[mixedLetters[[#2[[1]]]]^#1 &,
			Flatten[Drop[trDlog, Length[alphabet]]]];
		pureContribution =
			Times @@
			MapIndexed[alphabet[[#2[[1]]]]^#1 &,
			Flatten[SeriesCoefficient[
				Take[trDlog, Length[alphabet]], {eps, 0, 0}]]];
		If[ Length[aNormed[[1]]] === 1,
			trafo = {{pureContribution*mixedContribution}};
			Return[{trafo, TransformDE[aNormed, invariants, trafo]}];
		];
		If[ ! And @@
			Map[IntegerQ[#[[1, 1]]] &,
			SeriesCoefficient[trDlog, {eps, 0, 0}]],
			Message[TransformDiagonalBlock::nonrationaltr];
			Return[False];
		];
		f = Power[
			Times @@
			Apply[Power,
			Function[Group, Sort[Group, #1[[2]] < #2[[2]] &][[1]]] /@
				GatherBy[
				Union[Flatten[
				Map[Function[Liste,
					Select[Liste, #1[[2]] < 0 && ! FreeQ[#1[[1]], eps] &]],
					Map[FactorList, aNormed, {3}], {3}], 3],
				SameTest -> (NumberQ[
					Simplify[#1[[1]]/#2[[1]]]] && #1[[2]] == #2[[
						2]] &)], #1[[1]] &], {1}], -1];
		nonSingularPoint =
			CalculateNonSingularPoint[alphabet, invariants];
		aHat = Simplify[f*aNormed];
		lMAX = Exponent[f, eps, Max];
		lMIN = Exponent[f, eps, Min];
		kMAX =
			Sort[Select[Flatten[Exponent[aHat, eps, Max]],
			NumberQ[#1] &]][[-1]];
		kMIN =
			Sort[Select[Flatten[Exponent[aHat, eps, Min]], NumberQ[#1] &]][[
			1]];
		If[ userProvidedAnsatz === {},
			indepFactors =
			FindAnsatzT[aNormed, invariants,
			TDeltaDenominatorDegree -> OptionValue[TDeltaDenominatorDegree],
			TDeltaNumeratorDegree -> OptionValue[TDeltaNumeratorDegree]];
			If[ indepFactors === False,
				Return[False];
			];,
			If[ CheckRationality[userProvidedAnsatz, invariants] &&
			Complement[Variables[userProvidedAnsatz], invariants] === {},
				indepFactors = userProvidedAnsatz;
				StartKernels[];,
				Message[TransformDiagonalBlock::invansatz];
				Return[False];
			];
		];
		trLinear = SeriesCoefficient[trDlog, {eps, 0, 1}];
		denominatorFactors =
			Select[Union[
			Cases[Factor@aNormed, Power[f_, p_] /; p < 0 :> f, Infinity],
			SameTest -> (NumberQ@Simplify[#1/#2] &)], FreeQ[#, eps] &];
		denominatorLetterNumbers =
			Map[Function[DenFactor,
			Position[
				Map[Function[Letter, NumberQ@Simplify[DenFactor/Letter]],
				alphabet], True][[1, 1]]], denominatorFactors];
Off[Solve::svars];
		traceContraints =
			Join[Solve[
			DeleteCases[
				MapIndexed[
				If[ MemberQ[denominatorLetterNumbers, #2[[1]]],
					Sum[\[Alpha][#2[[1]], i, i], {i, 1,
						Length[aNormed[[1]]]}] == #1[[1, 1]],
					0
				] &, trLinear],
				0]][[1]],
			Flatten[(Table[
				Table[\[Alpha][#1, i, j] -> 0, {i, 1,
					Length[aNormed[[1]]]}], {j, 1, Length[aNormed[[1]]]}] &) /@
				Complement[Table[i, {i, 1, Length[alphabet]}],
				denominatorLetterNumbers]]];
On[Solve::svars];
		res = NestWhile[
			Function[PreviousResult,
			CalcNextTn[aHat, f, alphabet, invariants, lMIN, lMAX, kMAX,
			kMIN, nonSingularPoint,
			indepFactors, {PreviousResult[[1]], PreviousResult[[2]],
				PreviousResult[[3]], PreviousResult[[4]]},
			VerbosityLevel -> OptionValue[VerbosityLevel]]], {{},
			traceContraints, {},
			False}, ! #1 === False && #1[[4]] === False &, 1];
		If[ res === False,
			Return[False];,
			trafo = res[[1]];
		];
		Return[{Simplify[normRes[[1]].trafo],
			TransformDE[aNormed, invariants, trafo]}];
	];


TransformDlogToEpsForm[invariants_List, sectorBoundaries_List,
trafoPrevious_List, aPrevious_List, OptionsPattern[]] :=
	Module[ {alphabet, pretAnsatz, subSector, enforceBlockTriangularRule,
		tAnsatz, dLogForm, generalSolution, particularSolution},
		subSector =
			Position[sectorBoundaries, Length[aPrevious[[1]]]][[1, 1]];
		If[ subSector =!= 1,
			If[ OptionValue[VerbosityLevel] >= 8,
				Print["Transforming sector " <> ToString[subSector] <>
				" from dlog-form into epsilon-form."]
			]
		];
		alphabet = ExtractIrreducibles[aPrevious];
		dLogForm = CalculateDlogForm[aPrevious, invariants, alphabet];
		If[ dLogForm === False,
			Message[TransformDlogToEpsForm::notdlog];
			Return[{False, {trafoPrevious, aPrevious}}];
		];
		If[ And @@ (NumberQ[Simplify[#1/eps]] &) /@
			DeleteCases[Flatten[dLogForm], 0],
			Return[{trafoPrevious, aPrevious}];
		];
		pretAnsatz =
			Table[t[i, j], {i, 1, Length[dLogForm[[1]]]}, {j, 1,
			Length[dLogForm[[1]]]}];
		enforceBlockTriangularRule = # -> 0 & /@
			Flatten[Function[matrix,
				Function[
				bounds, (Take[
					matrix[[#1]], {bounds[[2]] + 1, Length[matrix]}] &) /@
				Table[i, {i, bounds[[1]], bounds[[2]]}]] /@
				Take[sectorBoundaries, subSector - 1]][pretAnsatz]];
		If[ OptionValue[EnforceBlockTriangular] === False,
			tAnsatz = pretAnsatz;,
			tAnsatz = pretAnsatz /. enforceBlockTriangularRule;
		];
		Off[Solve::svars];
		generalSolution =
			Simplify[
			tAnsatz /.
			Solve[And @@
				Map[#.tAnsatz/eps - (tAnsatz.#/mu /. eps -> mu) == 0 &,
				dLogForm],
				Variables[
				Table[t[i, j], {i, 1, Length[dLogForm[[1]]]}, {j, 1,
				Length[dLogForm[[1]]]}]]][[1]]];
		On[Solve::svars];
		particularSolution =
			Fold[ReplaceVarByNonSingularValue, generalSolution,
			Join[{mu},
			Select[Variables[generalSolution], Head[#] === t &]]];
		If[ MatrixRank[particularSolution] === Length[particularSolution],
			Return[{trafoPrevious.particularSolution,
			TransformDE[aPrevious, invariants, particularSolution]}];,
			Return[{False, {trafoPrevious, aPrevious}}];
		];
	];


TransformIntoBlockTriangularForm[a_List, invariants_List] :=
	Module[ {adjMatrix, adjGraph, components, condensateEdges,
		condensateGraph, newPartition, newOrder, trafo, sectorBoundaries},
		adjMatrix =
		Map[Function[entries,
		If[ And @@ Map[PossibleZeroQ, entries],
			0,
			1
		]],
		Transpose[a, {3, 1, 2}], {2}];
		adjGraph = AdjacencyGraph[adjMatrix];
		components = ConnectedComponents@adjGraph;
		condensateEdges =
			Union[Cases[
			EdgeList[adjGraph] /.
			Table[v -> First[Select[components, MemberQ[#, v] &]], {v,
				VertexList[adjGraph]}], u_ \[DirectedEdge] v_ /; u =!= v]];
		condensateGraph = Graph[components, condensateEdges];
		newPartition = Reverse@TopologicalSort@condensateGraph;
		newOrder = Flatten@newPartition;
		trafo =
			Inverse[ReplacePart[0*IdentityMatrix[Length@a[[1]]],
			MapIndexed[{#2[[1]], #} -> 1 &, newOrder]]];
		sectorBoundaries =
			Drop[FoldList[
			Function[{prev, delta}, {prev[[2]] + 1, prev[[2]] + delta}], {0,
				0}, Length /@ newPartition], 1];
		Return[{sectorBoundaries, {trafo,
			TransformDE[a, invariants, trafo]}}];
	];


TransformNextDiagonalBlock[aFull_List, invariants_List,
sectorBoundaries_List, trafoPrevious_List, aPrevious_List,
userProvidedAnsatz_List: {}, OptionsPattern[]] :=
	Module[ {aNew, nextBlockBounds, newBlock, subSector,
		trafoLowerSectorsToEpsForm, newBlockInEpsForm,
		trafoBlockToEpsForm, aBlockInEpsForm},
		aNew = CalculateNexta[aFull, invariants, sectorBoundaries,
			trafoPrevious, aPrevious];
		If[ aNew === False,
			Return[{False, {trafoPrevious, aPrevious}}];
		];
		nextBlockBounds =
			NextBlockBoundaries[aPrevious, sectorBoundaries];
		newBlock = ExtractDiagonalBlock[aNew, nextBlockBounds];
		subSector = Position[sectorBoundaries, Length[aNew[[1]]]][[1, 1]];
		If[ OptionValue[VerbosityLevel] >= 4,
			Print["Transforming sector " <> ToString[subSector] <> "."]
		];
		If[ OptionValue[VerbosityLevel] >= 6,
			Print["Transforming diagonal block of sector " <>
			ToString[subSector] <> "."]
		];
		trafoLowerSectorsToEpsForm =
			InsertBlockIntoIdentity[trafoPrevious, Length[aNew[[1]]], 1];
		newBlockInEpsForm =
			TransformDiagonalBlock[newBlock, invariants, userProvidedAnsatz,
			TDeltaDenominatorDegree -> OptionValue[TDeltaDenominatorDegree],
			TDeltaNumeratorDegree -> OptionValue[TDeltaNumeratorDegree],
			VerbosityLevel -> OptionValue[VerbosityLevel]];
		If[ newBlockInEpsForm === False,
			Return[{False, {trafoPrevious, aPrevious}}];
		];
		trafoBlockToEpsForm =
			InsertBlockIntoIdentity[newBlockInEpsForm[[1]], Length[aNew[[1]]],
			nextBlockBounds[[1]]];
		aBlockInEpsForm =
			TransformDE[aNew, invariants, trafoBlockToEpsForm];
		Return[{trafoLowerSectorsToEpsForm.trafoBlockToEpsForm,
			aBlockInEpsForm}];
	];


TransformNextSector[aFull_List, invariants_List,
sectorBoundaries_List, trafoPrevious_, aPrevious_,
userProvidedAnsatz_List: {}, OptionsPattern[]] :=
	Module[ {aBlockInEpsForm, aBlockInEpsFormOffDiagIndLog, aInEpsForm,
		aInSimplifiedEpsForm},
		aBlockInEpsForm =
			TransformNextDiagonalBlock[aFull, invariants, sectorBoundaries,
			trafoPrevious, aPrevious, userProvidedAnsatz,
			TDeltaDenominatorDegree -> OptionValue[TDeltaDenominatorDegree],
			TDeltaNumeratorDegree -> OptionValue[TDeltaNumeratorDegree],
			VerbosityLevel -> OptionValue[VerbosityLevel]];
		If[ aBlockInEpsForm[[1]] === False,
			Return[{False, aBlockInEpsForm[[2]]}]
		];
		aBlockInEpsFormOffDiagIndLog =
			TransformOffDiagonalBlock[invariants, sectorBoundaries,
			aBlockInEpsForm[[1]], aBlockInEpsForm[[2]],
			DDeltaDenominatorDegree -> OptionValue[DDeltaDenominatorDegree],
			DDeltaNumeratorDegree -> OptionValue[DDeltaNumeratorDegree],
			VerbosityLevel -> OptionValue[VerbosityLevel]];
		If[ aBlockInEpsFormOffDiagIndLog[[1]] === False,
			Return[{False, {aBlockInEpsForm[[1]], aBlockInEpsForm[[2]]},
			aBlockInEpsFormOffDiagIndLog[[2]]}]
		];
		aInEpsForm =
			TransformDlogToEpsForm[invariants, sectorBoundaries,
			aBlockInEpsFormOffDiagIndLog[[1]],
			aBlockInEpsFormOffDiagIndLog[[2]],
			VerbosityLevel -> OptionValue[VerbosityLevel]];
		If[ aInEpsForm[[1]] === False,
			Return[{False, aInEpsForm[[2]]}]
		];
		Return[{Simplify[aInEpsForm[[1]]], aInEpsForm[[2]]}];
		Return[{Simplify[aInSimplifiedEpsForm[[1]]],
			aInSimplifiedEpsForm[[2]]}];
	];


TransformOffDiagonalBlock[invariants_List, sectorBoundaries_List,
trafoPrevious_List, aPrevious_List, userProvidedD_List: {},
OptionsPattern[]] :=
	Module[ {position, subSector, irredFactors, subSectorSize,
		offdiagonalBlock, startD, fullD, trafoD},
		If[ Length[trafoPrevious] =!= Length[aPrevious[[1]]],
			Message[TransformOffDiagonalBlock::baddims1];
			Return[{False, {}}];
		];
		position =
			Select[Position[sectorBoundaries,
			Length[aPrevious[[1]]]], #[[2]] === 2 &];
		If[ position === {},
			Message[TransformOffDiagonalBlock::baddims2];
			Return[{False, {}}];,
			subSector = position[[1, 1]];
		];
		If[ subSector =!= 1 && userProvidedD === {},
			If[ OptionValue[VerbosityLevel] >= 6,
				Print["Transforming off-diagonal block below sector " <>
				ToString[subSector] <> " into dlog-form."]
			]
		];
		subSectorSize =
			sectorBoundaries[[subSector, 2]] -
			sectorBoundaries[[subSector, 1]] + 1;
		offdiagonalBlock =
			Table[Map[Take[#, Length[aPrevious[[1]]] - subSectorSize] &,
			Take[aPrevious[[nVar]], -subSectorSize]], {nVar, 1,
			Length[invariants]}];
		If[ subSector === 1,
			Return[{trafoPrevious, aPrevious}]
		];
		irredFactors =
			ExtractIrreducibles[offdiagonalBlock,
			AllowEpsDependence -> True];
		If[ FreeQ[irredFactors, eps] &&
			CheckDlogForm[offdiagonalBlock, invariants, irredFactors],
			If[ OptionValue[VerbosityLevel] >= 10,
				Print["Off-diagonal blocks below sector " <>
					ToString[subSector] <> " are already in dlog-form."];
			];
			Return[{trafoPrevious, aPrevious}];
		];
		startD =
			If[ userProvidedD =!= {},
				userProvidedD,
				Table[{}, {i, 1, subSectorSize}]
			];
		fullD =
			NestWhile[
			Function[{previousD},
			CalculateNextSubsectorD[aPrevious, invariants, sectorBoundaries,
				previousD,
			DDeltaDenominatorDegree ->
				OptionValue[DDeltaDenominatorDegree],
			DDeltaNumeratorDegree -> OptionValue[DDeltaNumeratorDegree],
			VerbosityLevel -> OptionValue[VerbosityLevel]]],
			startD, (#[[1]] =!= False) && (Length[#[[1]]] + subSectorSize =!=
				Length[aPrevious[[1]]]) &];
		If[ fullD[[1]] === False,
			Return[{False, fullD[[2]]}];
		];
		trafoD = InsertDIntoIdentity[sectorBoundaries, fullD];
		Return[{trafoPrevious.trafoD,
			TransformDE[aPrevious, invariants, trafoD]}];
	];


End[]


EndPackage[]
