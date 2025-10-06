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
		}
		if (x > moveTarget){
			dir = Dirs.RIGHT;	
		}
	} 
	if (y != _tary){
		moveTarget = _tary;
		if (y < moveTarget){
			dir = Dirs.UP;	
		}
		if (y > moveTarget){
			dir = Dirs.DOWN;	
		}
	}
	spd = _spd;
	moving = true;
}

compMove = function(){
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