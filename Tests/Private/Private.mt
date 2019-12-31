(* :Title: Private.mt														*)

(*
	This software is covered by the GNU General Public License 3.
	Copyright (C) 2017-2020 Christoph Meyer
	Copyright (C) 2019-2020 Vladyslav Shtabovenko
*)

(* :Summary:  Private unit tests not meant for the general public			*)

(* ------------------------------------------------------------------------ *)

Needs["CANONICA`", caPath];


ClearAll[tests];
tests = FileNames["*.test",FileNameJoin[{testSuiteDirectory, "Private"}]]
Get/@tests;

If[	$OnlySubTest=!="",
	testNames = "Tests`Private`*";
	removeTests=Complement[Names[testNames],Flatten[StringCases[Names[testNames],Alternatives@@$OnlySubTest]]];
	Remove/@removeTests;
	WriteString["stdout","Only following subtests will be checked: ", Names[testNames]];
	Remove[testNames]
];

stringCompare[a_,b_]:=
	(ToString[a]===ToString[b]);

expCompare[a_,b_]:=
	MatchQ[Union[Flatten[{Together[a - b]}]], {0}];

stringCompareIgnore[_,_]:=
	True;

If[ Names["Tests`Private`*CheckAbort"]=!={},
	tmpTest = Map[test[ToExpression[(#[[2]])],ToExpression[(#[[3]])],(#[[4]]),testID->#[[1]],
		MessagesEquivalenceFunction->stringCompareIgnore]&,
		Join@@(ToExpression/@Names["Tests`Private`*CheckAbort"])];
	tmpTest = tmpTest /. testID->TestID /. test -> Test
];

nms=Names["Tests`Private`*"];
If[ nms=!={} && Select[nms, !StringMatchQ[#, "*CheckAbort"] &]=!={},
	tmpTest = Map[test[expCompare[ToExpression[(#[[2]])],ToExpression[(#[[3]])]],True,testID->#[[1]]]&,
	Join@@(ToExpression/@Select[nms, !StringMatchQ[#, "*CheckAbort"] &])];
	tmpTest = tmpTest /. testID->TestID /. test -> Test
];












