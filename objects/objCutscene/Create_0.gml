sceneInfo = undefined;
scene = 0;

timer = 0;

sceneInfo = [
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
animPlaying = false;
activeSplash = undefined;