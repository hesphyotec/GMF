// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function csMoveChar(obj, xx, yy, relative, mspd){
	if(ds_list_empty(movePath) && !moveStart){
		spd = mspd;
		var startX = floor(obj.x / TILE_SIZE);
		var startY = floor(obj.y / TILE_SIZE);
		mapSpace = [startX, startY];
		if(!relative){
			xDest = xx;
			yDest = yy;
		} else {
			xDest = startX + xx;
			yDest = startY + yy; 
		}
		show_debug_message("Map space: " + string(mapSpace))
		show_debug_message("Target: " + string([xDest, yDest]))
		ds_list_copy(movePath, getPath([startX, startY], [xDest, yDest]));
		moveStart = true
	}
	
	if(!ds_list_empty(movePath) && !moving){
		show_debug_message("Node found!");
		var node = ds_list_find_value(movePath, 0);
		draw_circle(node.px, node.py, 4, c_red);
		moveTarget = [node.gx, node.gy];
		ds_list_delete(movePath, 0);
		if (moveTarget[0] != mapSpace[0]){
			dir = moveTarget[0] < mapSpace[0] ? Dirs.LEFT : Dirs.RIGHT
		}
		if (moveTarget[1] != mapSpace[1]){
			dir = (moveTarget[1] < mapSpace[1]) ? Dirs.UP : Dirs.DOWN
		}
		var spriteDir = "Down";
		
		switch(dir){
			case Dirs.UP:
				spriteDir = "Up";
				break;
			case Dirs.DOWN:
				spriteDir = "Down";
				break;
			case Dirs.LEFT:
				spriteDir = "Left";
				break;
			case Dirs.RIGHT:
				spriteDir = "Right";
				break;
		}
		//if (asset_get_index(baseSpriteName + spriteDir)){
		//	obj.sprite_index = asset_get_index(baseSpriteName + spriteDir);
		//}
		moving = true;
	} else {
		//show_debug_message("Node not found!");	
	}
	
	if (moving){
		obj.image_speed = 1;
		show_debug_message(string(moveTarget));
		if(dir == Dirs.LEFT || dir == Dirs.RIGHT){
			obj.x = approach(obj.x, (moveTarget[0] * TILE_SIZE), spd);
			if (abs(obj.x - (moveTarget[0] * TILE_SIZE)) <= spd/2){
				obj.x = (moveTarget[0] * TILE_SIZE);
				moving = false;	
			}
		}
		if(dir == Dirs.UP || dir == Dirs.DOWN){
			obj.y = approach(obj.y, (moveTarget[1] * TILE_SIZE), spd);
			if (abs(obj.y - (moveTarget[1] * TILE_SIZE)) <= spd/2){
				obj.y = (moveTarget[1] * TILE_SIZE);
				moving = false;	
			}
		}
		mapSpace = [floor(obj.x / TILE_SIZE), floor(obj.y / TILE_SIZE)];
	} else {
		//if (!idleAnim){
		image_index = 0;
		image_speed = 0;
		//} else {
		//	image_speed = 1;
		//}
		xDest = -1;
		yDest = -1;
		moveTar = [0,0];
		moveTarget = [0,0];
		mapSpace = [0,0];
		ds_list_destroy(movePath);
		movePath = ds_list_create();
		spd = 0;
		moveStart = false;
		csEndAction();
	}
}