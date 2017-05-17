Get["../../src/CANONICA.m"];
Get["./MasslessDoubleBoxDEQ.m"];

invariants = {x};
sectorBoundaries = SectorBoundariesFromDE[aFull];

fullResult = 
RecursivelyTransformSectors[aFull, invariants, sectorBoundaries, {1, 7}];

If[FileExistsQ["Result.m"], DeleteFile["Result.m"]];
Save["Result.m", fullResult];

Exit[];
