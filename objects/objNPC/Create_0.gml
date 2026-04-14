type = NPC.FRIENDLY;
diag = "I'm just a rock. Chillin'.";
interactCd = false;

diagChar = global.data.dialogue.npc_test;
line = "test";

baseSpriteName = "sprNPC";

onInteract = function(){
	if (!interactCd){
		with(objDialogue){
			loadDiag(other.diagChar, other.line, other);	
		}
	}
}
image_speed = 0;

enum NPCSTATE {
	IDLE,
	PATROL,
	STAND
}

state = NPCSTATE.STAND;
passive = false;

movePath = ds_list_create();
mapSpace = [floor(x / TILE_SIZE), floor(y / TILE_SIZE)];
moveTarget = mapSpace;
moving = false;
dir = Dirs.DOWN;

moveTimer = 0;
moveTimerMax = 10 * game_get_speed(gamespeed_fps);
moveTimerMin = 2 * game_get_speed(gamespeed_fps);
rangeSide = 10 * TILE_SIZE;
rangeDist = 10 * TILE_SIZE;
spd = 2;
idleSpd = 2;
patrolSpd = 2;
chaseSpd = 4;

idleWanderRange = 3;
patrolTargets = [];
chaseTarget = [0,0];

canAnimate = false;

initMove = function(_tar, _spd){
	moveTarget = _tar;
	if(x != (moveTarget[0] * TILE_SIZE)){
		if (x < (moveTarget[0] * TILE_SIZE)){
			dir = Dirs.RIGHT;
			sprite_index = asset_get_index(baseSpriteName + "Right");
		}
		if (x > (moveTarget[0] * TILE_SIZE)){
			dir = Dirs.LEFT;
			sprite_index = asset_get_index(baseSpriteName + "Left");
		}
	} 
	if (y != (moveTarget[1] * TILE_SIZE)){
		if (y < (moveTarget[1] * TILE_SIZE)){
			dir = Dirs.DOWN;
			sprite_index = asset_get_index(baseSpriteName + "Down");
		}
		if (y > (moveTarget[1] * TILE_SIZE)){
			dir = Dirs.UP;
			sprite_index = asset_get_index(baseSpriteName + "Up");
		}
	}
	spd = _spd;
	moving = true;
}

npcMove = function(){
	if (!ds_list_empty(movePath) && !moving){
		var node = ds_list_find_value(movePath, 0);
		initMove([node.gx, node.gy], spd);
		ds_list_delete(movePath, 0);
	}
	
	if (moving){
		image_speed = 1;
		if(dir == Dirs.LEFT || dir == Dirs.RIGHT){
			x = approach(x, (moveTarget[0] * TILE_SIZE), spd);
			if (abs(x - (moveTarget[0] * TILE_SIZE)) <= spd/2){
				x = (moveTarget[0] * TILE_SIZE);
				mapSpace[0] = moveTarget[0];
				moving = false;	
			}
		}
		if(dir == Dirs.UP || dir == Dirs.DOWN){
			y = approach(y, (moveTarget[1] * TILE_SIZE), spd);
			if (abs(y - (moveTarget[1] * TILE_SIZE)) <= spd/2){
				y = (moveTarget[1] * TILE_SIZE);
				mapSpace[1] = moveTarget[1];
				moving = false;	
			}
		}
	} else {
		if (!canAnimate){
			image_index = 0;
			image_speed = 0;
		}
	}
}

getMoveTarget = function(_mTar){
	movePath = getPath(mapSpace, _mTar);
}