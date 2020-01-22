(* ::Package:: *)

(* ::Title:: *)
(*Drell-Yan with one internal mass*)


(* ::Section:: *)
(*Load CANONICA and the matrix for this example*)


If[$FrontEnd===Null,
	exDirectory=DirectoryName[$InputFileName];
	verbosity=4;
	colorPrint=Function[(WriteString["stdout","\033[1m"<>#1<>"\033[0m "<> If[TrueQ[#4],
		"\033[1m \033[32m"<>#2<>"\033[0m \033[0;39m","\033[1m \033[31m"<>#3<>"\033[0m \033[0;39m"]<>"\n"];
		If[!TrueQ[#4],Quit[1]])],	
	exDirectory=NotebookDirectory[];
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

caDirectory=ParentDirectory@ParentDirectory@exDirectory;
caPath = FileNameJoin[{caDirectory,"src","CANONICA.m"}];


Block[{Print=quiet},Get[caPath]];
description="Drell-Yan with one internal mass";
Get[FileNameJoin[{exDirectory,"DrellYanOneMassDEQ.m"}]];


If[!MatchQ[aFull,{_?MatrixQ..}],
	Print["Cannot load the matrix aFull, evaluation aborted!"];
	If[$FrontEnd===Null,
		Quit[1],
		Abort
	]
];


(* ::Section:: *)
(*Use CANONICA to find a canonical form*)


Print[description];


invariants = {x, y};
sectorBoundaries = SectorBoundariesFromDE[aFull];
secStart=1;
secEnd=20;
computeParallel=False;
nParallelKernels=2;


parseExtraArguments[];


$ComputeParallel=computeParallel;
$NParallelKernels=nParallelKernels;
maxMem=MaxMemoryUsed[fullResult = 
	RecursivelyTransformSectors[aFull, invariants, 
	sectorBoundaries, {secStart, secEnd},VerbosityLevel->verbosity];];


(* ::Section:: *)
(*Check the final result*)


colorPrint["Check the obtained epsilon form:","CORRECT","WRONG",
CheckEpsForm[fullResult[[2]], invariants,ExtractIrreducibles[aFull]]];
Print["\tCPU Time used: ", Round[N[TimeUsed[],4],0.001], " s."];
Print["\tRAM used: ", Round[N[maxMem/10^6]], " MB"];
