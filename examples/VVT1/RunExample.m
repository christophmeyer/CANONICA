Get["../../src/CANONICA.m"];
Get["./VVT1DEQ.m"];

invariants = {x, y, z};
sectorBoundaries = SectorBoundariesFromDE[aFull];

fullResult = 
RecursivelyTransformSectors[aFull, invariants, sectorBoundaries, {1, 23}];

If[FileExistsQ["Result.m"], DeleteFile["Result.m"]];
Save["Result.m",fullResult];

Exit[];
