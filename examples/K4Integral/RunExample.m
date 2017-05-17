Get["../../src/CANONICA.m"];
Get["./K4IntegralDEQ.m"];

invariants = {x};
sectorBoundaries = SectorBoundariesFromDE[aFull];

fullResult = 
RecursivelyTransformSectors[aFull, invariants, sectorBoundaries, {1, 4}];

If[FileExistsQ["Result.m"], DeleteFile["Result.m"]];
Save["Result.m", fullResult];

Exit[];
