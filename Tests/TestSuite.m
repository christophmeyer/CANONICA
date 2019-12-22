(* :Title: TestSuite.m                                              		*)

(*
	This software is covered by the GNU General Public License 3.
	Copyright (C) 2017-2020 Christoph Meyer
	Copyright (C) 2019-2020 Vladyslav Shtabovenko
*)

(* :Summary:  	Test Suite for CANONICA via MUnit.							*)

(* ------------------------------------------------------------------------ *)

caDirectory::usage="";
status::usage="";
time::usage="";
caTestList::usage="";
str::usage="";

If[$FrontEnd===Null,
	caDirectory=ParentDirectory@DirectoryName[$InputFileName],
	caDirectory=ParentDirectory@NotebookDirectory[]
];
testSuiteDirectory = FileNameJoin[{caDirectory,"Tests"}]; 
caPath = FileNameJoin[{caDirectory,"src","CANONICA.m"}];

status=Get[caPath];
If[	status===$Failed,
	Print["Cannot load CANONICA, test run aborted"];
	Exit[]
];

<< MUnit`


testRunner[test_String]:=
	(
	time=AbsoluteTime[];	
	If[!MUnit`TestRun[test,Loggers->{VerbosePrintLogger[]}],
	    WriteString["stdout","\nERROR! Some tests from ", test, " failed! Test run aborted!\n"];		
		Exit[1],
		WriteString["stdout","\nTiming: ", N[AbsoluteTime[] - time, 4], " seconds.\n\n"];		
	]
	);

WriteString["stdout","Starting CANONICA test suite on Mathematica ", $VersionNumber, "\n"];

Which[
    (* This selects only unit tests, i.e. short tests that need little time to finish	*)
	testType===1,
		caTestList = (FileNames["*.mt", FileNameJoin[{testSuiteDirectory, "*"}]]),
	(* This selects heavier integration tests that require much longer time to finish *)
	testType===2,
		caTestList = StringCases[
		FileNames["*.mt", FileNameJoin[{testSuiteDirectory, "*"}], Infinity], 
			RegularExpression[".*IntegrationTests.*"]]//Flatten,
	True,		
		WriteString["stdout","Error! Uknown test type.\n"];
		Exit[]
];

If[	onlyTest=!="" && Head[onlyTest]===String,	
	str = RegularExpression[(".*" <> # <> ".*")]& /@ (StringSplit[ToString[onlyTest],"|"]);
	caTestList = StringCases[caTestList,Alternatives@@str]//Flatten;
	WriteString["stdout","Only following tests will be checked: ", caTestList, "\n"];	
	FCPrint[0,"\n",UseWriteString->True]
];

If[	onlySubTest=!="" && Head[onlySubTest]===String,	
	$OnlySubTest = RegularExpression[(".*" <> # <> ".*")]& /@ StringSplit[ToString[onlySubTest],"|"],
	$OnlySubTest=""
];

SetAttributes[test, HoldAllComplete];

testRunner/@caTestList;
WriteString["stdout","\nDone!\n"];
Return[1]
