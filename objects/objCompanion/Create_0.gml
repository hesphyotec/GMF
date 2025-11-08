leader = objOWPlayer;
moving = false;
moveTarget = 0;
spd = 0;
dir = Dirs.DOWN;

initMove = function(_tarx, _tary, _spd){
	if(x != _tarx){
		moveTarget = _tarx;
		if (x < moveTarget){
			dir = Dirs.LEFT;
			sprite_index = sprNPCRight;
		}
		if (x > moveTarget){
			dir = Dirs.RIGHT;
			sprite_index = sprNPCLeft;
		}
	} 
	if (y != _tary){
		moveTarget = _tary;
		if (y < moveTarget){
			dir = Dirs.UP;
			sprite_index = sprNPCDown;
		}
		if (y > moveTarget){
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