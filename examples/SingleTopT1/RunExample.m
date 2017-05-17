Get["../../src/CANONICA.m"];
Get["./STT1DEQ.m"];

invariants = {x, y, z};
sectorBoundaries = SectorBoundariesFromDE[aFull];

fullResult = 
RecursivelyTransformSectors[aFull, invariants, sectorBoundaries, {1, 21}];

If[FileExistsQ["Result.m"], DeleteFile["Result.m"]];
Save["Result.m",fullResult];

Exit[];
