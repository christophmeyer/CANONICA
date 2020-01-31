(* ::Package:: *)

If[$FrontEnd===Null,
	verbosity=4;
	colorPrint=Function[(WriteString["stdout","\033[1m"<>#1<>"\033[0m "<> If[TrueQ[#4],
		"\033[1m \033[32m"<>#2<>"\033[0m \033[0;39m","\033[1m \033[31m"<>#3<>"\033[0m \033[0;39m"]<>"\n"];
		If[!TrueQ[#4],Quit[1]])],	
	verbosity=10;
	colorPrint=Function[Print[Style[#1,"Text",Bold], " ", 
		If[TrueQ[#4],Style[#2,"Text",Darker[Green],Bold],Style[#3,"Text",Red,Bold]]]];
];
parseExtraArguments[]:=If[StringQ[extraArgs] && extraArgs=!="",
	If[ToExpression[extraArgs]===$Failed,
		Print["Cannot parse extra arguments, evaluation aborted!"];	
		If[$FrontEnd===Null,
			Quit[1],
			Abort
		]
	]
];
checkSkip[]:=If[Head[skip]===List,
	skip=ToString/@skip;
	If[MemberQ[skip,FileBaseName[exDirectory]],
		Print["Skipping this example."];
		Quit[]
	]
];
checkMatrix[var_]:=If[!MatchQ[var,{_?MatrixQ..}],
	Print["Cannot load the matrix aFull, evaluation aborted!"];
	If[$FrontEnd===Null,
		Quit[1],
		Abort
	]
];
caDirectory=ParentDirectory@ParentDirectory@exDirectory;
caPath = FileNameJoin[{caDirectory,"src","CANONICA.m"}];
Block[{Print=quiet},Get[caPath]];
