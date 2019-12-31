(* :Title: Shared.mt														*)

(*
	This software is covered by the GNU General Public License 3.
	Copyright (C) 2017-2020 Christoph Meyer
	Copyright (C) 2019-2020 Vladyslav Shtabovenko
*)

(* :Summary:  Unit tests for shared functions								*)

(* ------------------------------------------------------------------------ *)

Needs["CANONICA`", caPath];


ClearAll[tests];
tests = FileNames["*.test",FileNameJoin[{testSuiteDirectory, "Shared"}]]
Get/@tests;

If[	$OnlySubTest=!="",
	testNames = "Tests`Shared`*";
	removeTests=Complement[Names[testNames],Flatten[StringCases[Names[testNames],Alternatives@@$OnlySubTest]]];
	Remove/@removeTests;
	WriteString["stdout","Only following subtests will be checked: ", Names[testNames]];
	Remove[testNames]
];

stringCompare[a_,b_]:=
	(ToString[a]===ToString[b]);

stringCompareIgnore[_,_]:=
	True;

expCompare[a_,b_]:=
	MatchQ[Union[Flatten[{Together[a - b]}]], {0}]

If[ Names["Tests`Shared`*CheckAbort"]=!={},
	tmpTest = Map[test[ToExpression[(#[[2]])],ToExpression[(#[[3]])],(#[[4]]),testID->#[[1]],
		MessagesEquivalenceFunction->stringCompareIgnore]&,
		Join@@(ToExpression/@Names["Tests`Shared`*CheckAbort"])];
	tmpTest = tmpTest /. testID->TestID /. test -> Test
];

nms=Names["Tests`Shared`*"];
If[ nms=!={} && Select[nms, !StringMatchQ[#, "*CheckAbort"] &]=!={},
	tmpTest = Map[test[expCompare[ToExpression[(#[[2]])],ToExpression[(#[[3]])]],True,testID->#[[1]]]&,
	Join@@(ToExpression/@Select[nms, !StringMatchQ[#, "*CheckAbort"] &])];
	tmpTest = tmpTest /. testID->TestID /. test -> Test
];
