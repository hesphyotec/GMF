spd = 2;
moving = false;
dir = Dirs.DOWN;
moveTarget = [0,0];
moveQueue = [[x, y],[x, y]];
companions = [];
inMenu = false;
mapSpace = [floor(x / TILE_SIZE), floor(y / TILE_SIZE)];
moveTarget = mapSpace;

playerMove = function(){
	if (global.server >= 0){
		if ((up || left || right || down ) && !moving){
			scrSendKey(global.server, up, down, left, right);
		}
	} else {
		if ((up || left || right || down ) && !moving){
			moving = true;
			if (up){
				dir = Dirs.UP;
				sprite_index = sprPlayerTempUp;
				if (scrMapCanMove(global.map, mapSpace[0], mapSpace[1]-1)){
					moveTarget[1]--;
					moveComps();
				} else {
					moving = false;	
				}
			} else if (left){
				dir = Dirs.LEFT;
				sprite_index = sprPlayerTempLeft;
				if (scrMapCanMove(global.map, mapSpace[0]-1, mapSpace[1])){
					moveTarget[0]--;
					moveComps();
				} else {
					moving = false;	
				}
			} else if (right){
				dir = Dirs.RIGHT;
				sprite_index = sprPlayerTempRight;
				if (scrMapCanMove(global.map, mapSpace[0]+1, mapSpace[1])){
					moveTarget[0]++;
					moveComps();
				} else {
					moving = false;	
				}
			} else if (down){
				dir = Dirs.DOWN;
				sprite_index = sprPlayerTempDown;
				if (scrMapCanMove(global.map, mapSpace[0], mapSpace[1]+1)){
					moveTarget[1]++;
					moveComps();
				} else {
					moving = false;	
				}
			}
			scrSendKey(global.server, up, down, left, right)
		}
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

playerInteract = function(){
	if (interactPress){
		var toCheckx = x;
		var toChecky = y;
		switch(dir){
			case Dirs.LEFT:
				toCheckx = x - TILE_SIZE;
				break;
			case Dirs.RIGHT:
				toCheckx = x + TILE_SIZE;
				break;
			case Dirs.UP:
				toChecky = y - TILE_SIZE;
				break;
			case Dirs.DOWN:
				toChecky = y + TILE_SIZE;
				break;
		}
		if (place_meeting(toCheckx, toChecky, objNPC)){
			var npc = instance_place(toCheckx, toChecky, objNPC);
			if (npc.type != NPC.HOSTILE){
				npc.onInteract();	
			} else if (npc.type == NPC.HOSTILE){
				npc.onInteract(global.players[0].team);
			}
		}
	}
}

updateMoves = function(){
	array_insert(moveQueue, 0, mapSpace);
	if (array_length(moveQueue) > MAX_COMPANIONS){
		array_delete(moveQueue,3,1);	
	}
}

serverMove = function(_x, _y){
	if (global.server >= 0){
		scrSendTarPos(global.server, _x, _y);	
	}
}