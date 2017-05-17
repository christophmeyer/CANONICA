Get["../../src/CANONICA.m"];
Get["./MasslessDoubleBoxNPDEQ.m"];

invariants = {x};
sectorBoundaries = SectorBoundariesFromDE[aFull];

fullResult = 
RecursivelyTransformSectors[aFull, invariants, sectorBoundaries, {1, 11}];

If[FileExistsQ["Result.m"], DeleteFile["Result.m"]];
Save["Result.m", fullResult];

Exit[];
