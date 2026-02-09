spd = 2;
moving = false;
dir = Dirs.DOWN;
mapSpace = [floor(x / TILE_SIZE), floor(y / TILE_SIZE)];
moveTarget = variable_clone(mapSpace);
moveQueue = [variable_clone(mapSpace),variable_clone(mapSpace)];
movePath = ds_list_create();
companions = [];
inMenu = false;

receiveMove = function(mTar){
	if (DEBUG_ENABLED) show_debug_message("Move Received");
	movePath = getPath(mapSpace, mTar);
}
	
playerMove = function(){
	if (!ds_list_empty(movePath) && !moving){
		var node = ds_list_find_value(movePath, 0);
		ds_list_delete(movePath, 0);
		moveTarget = [node.gx, node.gy];
	
		if (moveTarget[0] < mapSpace[0]){
			dir = Dirs.LEFT;
		} else if (moveTarget[0] > mapSpace[0]){
			dir = Dirs.RIGHT;
		} else if (moveTarget[1] < mapSpace[1]){
			dir = Dirs.UP;
		} else if (moveTarget[1] > mapSpace[1]){
			dir = Dirs.DOWN;
		}
	
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
		moving = true;
	}
	
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