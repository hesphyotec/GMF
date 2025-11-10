spd = 2;
moving = false;
dir = Dirs.DOWN;
moveTarget = 0;
moveQueue = [[x, y],[x, y]];
companions = [];
inMenu = false;
mapSpace = [floor(x / TILE_SIZE), floor(y / TILE_SIZE)];

playerMove = function(){
	if ((up || left || right || down ) && !moving){
		moving = true;
		if (up){
			dir = Dirs.UP;
			sprite_index = sprPlayerTempUp;
			if (scrMapCanMove(mapSpace[0], mapSpace[1]-1)){
				moveTarget = y - TILE_SIZE;
				moveComps();
			} else {
				moving = false;	
			}
		} else if (left){
			dir = Dirs.LEFT;
			sprite_index = sprPlayerTempLeft;
			if (scrMapCanMove(mapSpace[0]-1, mapSpace[1])){
				moveTarget = x - TILE_SIZE;
				moveComps();
			} else {
				moving = false;	
			}
		} else if (right){
			dir = Dirs.RIGHT;
			sprite_index = sprPlayerTempRight;
			if (scrMapCanMove(mapSpace[0]+1, mapSpace[1])){
				moveTarget = x + TILE_SIZE;
				moveComps();
			} else {
				moving = false;	
			}
		} else if (down){
			dir = Dirs.DOWN;
			sprite_index = sprPlayerTempDown;
			if (scrMapCanMove(mapSpace[0], mapSpace[1]+1)){
				moveTarget = y + TILE_SIZE;
				moveComps();
			} else {
				moving = false;	
			}
		}
		scrSendKey(global.server, up, down, left, right)
	}
	
	if (moving){
		image_speed = 1;
		if(dir == Dirs.LEFT || dir == Dirs.RIGHT){
			x = approach(x, moveTarget, spd);
			if (abs(x - moveTarget) <= spd/2){
				x = moveTarget;
				moving = false;	
			}
		}
		if(dir == Dirs.UP || dir == Dirs.DOWN){
			y = approach(y, moveTarget, spd);
			if (abs(y - moveTarget) <= spd/2){
				y = moveTarget;
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
		companions[_i].initMove(moveQueue[_i][0], moveQueue[_i][1], spd);
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
				npc.onInteract(objPlayer.team);
			}
		}
	}
}

updateMoves = function(){
	array_insert(moveQueue, 0, [x,y]);
	if (array_length(moveQueue) > MAX_COMPANIONS){
		array_delete(moveQueue,3,1);	
	}
}

serverMove = function(_x, _y){
	if (global.server >= 0){
		scrSendTarPos(global.server, _x, _y);	
	}
}