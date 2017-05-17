Get["../../src/CANONICA.m"];
Get["./VVT2DEQ.m"];

invariants = {x, y, z};
sectorBoundaries = SectorBoundariesFromDE[aFull];

fullResult = 
RecursivelyTransformSectors[aFull, invariants, sectorBoundaries, {1, 24},
                            DDeltaNumeratorDegree->2];

If[FileExistsQ["Result.m"], DeleteFile["Result.m"]];
Save["Result.m",fullResult];

Exit[];
