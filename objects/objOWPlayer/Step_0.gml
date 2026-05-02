scrGetInput();




if (!inMenu){
	playerMove();
	playerInteract();
}

if (global.loadPosBuffer.loading){
	x = global.loadPosBuffer.x;
	y = global.loadPosBuffer.y;
	mapSpace = [floor(x / TILE_SIZE), floor(y / TILE_SIZE)];
	global.loadPosBuffer.loading = false;
}
