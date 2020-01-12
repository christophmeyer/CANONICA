(* ::Package:: *)

(* ::Title:: *)
(*Drell-Yan with one internal mass*)


(* ::Section:: *)
(*Load CANONICA and the matrix for this example*)


If[$FrontEnd===Null,
	exDirectory=DirectoryName[$InputFileName];
	verbosity=4;
	colorPrint=Function[WriteString["stdout","\033[1m"<>#1<>"\033[0m "<> If[TrueQ[#4],
		"\033[1m \033[32m"<>#2<>"\033[0m \033[0;39m","\033[1m \033[31m"<>#3<>"\033[0m \033[0;39m"]<>"\n"]],
	
	exDirectory=NotebookDirectory[];
	verbosity=10;
	colorPrint=Function[Print[Style[#1,"Text",Bold], " ", 
		If[TrueQ[#4],Style[#2,"Text",Darker[Green],Bold],Style[#3,"Text",Red,Bold]]]];
];
caDirectory=ParentDirectory@ParentDirectory@exDirectory;
caPath = FileNameJoin[{caDirectory,"src","CANONICA.m"}];


Block[{Print=quiet},Get[caPath]];
description="Drell-Yan with one internal mass";
Get[FileNameJoin[{exDirectory,"DrellYanOneMassDEQ.m"}]];


If[!MatchQ[aFull,{_?MatrixQ..}],
	Print["Cannot load the matrix aFull, evaluation aborted!"];
	If[$FrontEnd===Null,
		Exit[-1],
		Abort
	]
];


(* ::Section:: *)
(*Use CANONICA to find a canonical form*)


Print[description];


invariants = {x, y};
sectorBoundaries = SectorBoundariesFromDE[aFull];


maxMem=MaxMemoryUsed[fullResult = 
	RecursivelyTransformSectors[aFull, invariants, 
	sectorBoundaries, {1, 20},VerbosityLevel->verbosity];];


(* ::Section:: *)
(*Check the final result*)


colorPrint["Check the obtained epsilon form:","CORRECT","WRONG",
CheckEpsForm[fullResult[[2]], invariants,ExtractIrreducibles[aFull]]];
Print["\tCPU Time used: ", Round[N[TimeUsed[],4],0.001], " s."];
Print["\tRAM used: ", Round[N[maxMem/10^6]], " MB"];



