(* ::Package:: *)

(* ::Title:: *)
(*Single top-quark topology 2*)


(* ::Section:: *)
(*Load CANONICA and the matrix for this example*)


If[$FrontEnd===Null,
	exDirectory=DirectoryName[$InputFileName],
	exDirectory=NotebookDirectory[]
];
Get[FileNameJoin[{Nest[ParentDirectory,exDirectory,2],"Tests","RunExampleProlog.m"}]]


description="Single top-quark topology 2. Time estimate: 20 min";
Get[FileNameJoin[{exDirectory,"STT2DEQ.m"}]];
checkMatrix[aFull];
Print[description];


(* ::Section:: *)
(*Use CANONICA to find a canonical form*)


invariants = {x, y, z};
sectorBoundaries = SectorBoundariesFromDE[aFull];
secStart=1;
secEnd=21;
computeParallel=False;
nParallelKernels=2;


parseExtraArguments[];
checkSkip[];


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
