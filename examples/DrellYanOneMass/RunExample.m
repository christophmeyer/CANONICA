Get["../../src/CANONICA.m"];
Get["./DrellYanOneMassDEQ.m"];

invariants = {x, y};
sectorBoundaries = SectorBoundariesFromDE[aFull];

fullResult = 
RecursivelyTransformSectors[aFull, invariants, sectorBoundaries, {1, 20}];

If[FileExistsQ["Result.m"], DeleteFile["Result.m"]];
Save["Result.m", fullResult];

Exit[];
