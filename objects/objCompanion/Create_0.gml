leader = objOWPlayer;
moving = false;
moveTarget = 0;
spd = 0;
dir = Dirs.DOWN;

initMove = function(_tar, _spd){
	moveTarget = _tar;
	if(x != (moveTarget[0] * TILE_SIZE)){
		if (x < (moveTarget[0] * TILE_SIZE)){
			dir = Dirs.LEFT;
			sprite_index = sprNPCRight;
		}
		if (x > (moveTarget[0] * TILE_SIZE)){
			dir = Dirs.RIGHT;
			sprite_index = sprNPCLeft;
		}
	} 
	if (y != (moveTarget[1] * TILE_SIZE)){
		if (y < (moveTarget[1] * TILE_SIZE)){
			dir = Dirs.UP;
			sprite_index = sprNPCDown;
		}
		if (y > (moveTarget[1] * TILE_SIZE)){
			dir = Dirs.DOWN;
			sprite_index = sprNPCUp;
		}
	}
	spd = _spd;
	moving = true;
}

compMove = function(){
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