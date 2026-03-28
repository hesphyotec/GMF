sceneInfo = undefined;
scene = 0;

timer = 0;

sceneInfo = [
	//[csWait, 2],
	////[csStartBattle],
	////[csInstanceCreate, objTutPlayer.x, objTutPlayer.y, "World_Objects", objNPC],
	//[csChangeCamera, instance_nearest(objTutPlayer.x, objTutPlayer.y, objNPC)],
	//[csMoveChar, instance_nearest(objTutPlayer.x, objTutPlayer.y, objNPC), 0, 10, true, 1],
	//[csChangeCamera, objTutPlayer],
	//[csWait, 5],
	//[csChangeCamera, instance_nearest(objTutPlayer.x, objTutPlayer.y, objNPC)],
	//[csMoveChar, instance_nearest(objTutPlayer.x, objTutPlayer.y, objNPC), 8, 8, false, 4],
	//[csChangeCamera, objTutPlayer],
]

xDest = -1;
yDest = -1;
movePath = ds_list_create();
moving = false;
moveTar = [0, 0];
moveTarget = [0, 0];
mapSpace = [0, 0];
dir = Dirs.DOWN;
eff = undefined;
inDiag = false;
spd = 0;
moveStart = false;