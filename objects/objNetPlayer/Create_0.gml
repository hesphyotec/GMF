spd = 2;
moving = false;
dir = Dirs.DOWN;
mapSpace = [floor(x / TILE_SIZE), floor(y / TILE_SIZE)];
moveTarget = mapSpace;
moveQueue = [[x, y],[x, y]];
companions = [];
inMenu = false;

receiveMove = function(mTar, _dir){
	if (DEBUG_ENABLED) show_debug_message("Move Received");
	if (!moving){
		moving = true;
	}
	moveTarget = mTar;
	dir = _dir;
	switch(dir){
		case Dirs.UP:
			sprite_index = sprPlayerTempUp;
			break;
		case Dirs.DOWN:
			sprite_index = sprPlayerTempDown;
			break;
		case Dirs.LEFT:
			sprite_index = sprPlayerTempLeft;
			break;
		case Dirs.RIGHT:
			sprite_index = sprPlayerTempRight;
			break;
	}
	moveComps();
}
playerMove = function(){
	if (moving){
		image_speed = 1;
		if(dir == Dirs.LEFT || dir == Dirs.RIGHT){
			x = approach(x, (moveTarget[0] * TILE_SIZE), spd);
			if (abs(x - (moveTarget[0] * TILE_SIZE)) <= spd/2){
				x = (moveTarget[0] * TILE_SIZE);
				moving = false;	
			}
		}
		if(dir == Dirs.UP || dir == Dirs.DOWN){
			y = approach(y, (moveTarget[1] * TILE_SIZE), spd);
			if (abs(y - (moveTarget[1] * TILE_SIZE)) <= spd/2){
				y = (moveTarget[1] * TILE_SIZE);
				moving = false;	
			}
		}
		mapSpace = [floor(x / TILE_SIZE), floor(y / TILE_SIZE)];
	} else {
		image_index = 0;
		image_speed = 0;
	}
}

approach = function(_start, _tar, _step){
	if (_tar < _start) return max(_start - _step, _tar);
	if (_tar > _start) return min(_start + _step, _tar);
	return _tar;
}

moveComps = function(){
	updateMoves();
	for(var _i = 0; _i < array_length(companions); ++_i){
		companions[_i].initMove(moveQueue[_i], spd);
	}
}


updateMoves = function(){
	array_insert(moveQueue, 0, mapSpace);
	if (array_length(moveQueue) > MAX_COMPANIONS){
		array_delete(moveQueue,3,1);	
	}
}