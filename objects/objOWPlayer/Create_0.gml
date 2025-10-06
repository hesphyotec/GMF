spd = 2;
moving = false;
dir = Dirs.DOWN;
moveTarget = 0;
moveQueue = [[x, y],[x, y]];
companions = [instance_create_layer(x,y,"Instances", objCompanion), instance_create_layer(x,y,"Instances", objCompanion), instance_create_layer(x,y,"Instances", objCompanion)];
inMenu = false;

playerMove = function(){
	if ((up || left || right || down ) && !moving){
		moving = true;
		if (up){
			dir = Dirs.UP;
			if (!place_meeting(x, y - TILE_SIZE, objWall)){
				moveTarget = y - TILE_SIZE;
				moveComps();
			} else {
				moving = false;	
			}
		} else if (left){
			dir = Dirs.LEFT;
			if (!place_meeting(x - TILE_SIZE, y, objWall)){
				moveTarget = x - TILE_SIZE;
				moveComps();
			} else {
				moving = false;	
			}
		} else if (right){
			dir = Dirs.RIGHT;
			if (!place_meeting(x + TILE_SIZE, y, objWall)){
				moveTarget = x + TILE_SIZE;
				moveComps();
			} else {
				moving = false;	
			}
		} else if (down){
			dir = Dirs.DOWN;
			if (!place_meeting(x, y + TILE_SIZE, objWall)){
				moveTarget = y + TILE_SIZE;
				moveComps();
			} else {
				moving = false;	
			}
		}
	}
	
	if (moving){
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