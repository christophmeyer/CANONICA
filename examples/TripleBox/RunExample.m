Get["../../src/CANONICA.m"];
Get["./TripleBoxDEQ.m"];

invariants = {x};
sectorBoundaries = SectorBoundariesFromDE[aFull];

fullResult = 
RecursivelyTransformSectors[aFull, invariants, sectorBoundaries, {1, 19}];

If[FileExistsQ["Result.m"], DeleteFile["Result.m"]];
Save["Result.m",fullResult];

Exit[];
