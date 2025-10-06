camwidth = 480;
camheight = 270;

camwidth = (ceil((window_get_width() / camwidth))/(window_get_width() / camwidth) * camwidth) 
camheight = (ceil((window_get_height() / camheight))/(window_get_height() / camheight) * camheight)

camera_set_view_size(view_camera[0], (camwidth), (camheight));
follow = objGame;
if object_exists(objOWPlayer){
	follow = objOWPlayer;
} else {
	follow = objGame;	
}
if (room == rmBattle){
	follow = objBattleController;	
}
x = follow.x;
y = follow.y;

xto = x;
yto = y;

// Shake stuff
s_amnt = 0;
shake_scr = function(_dur, _amnt){
	if (alarm[0] <= 0){
		alarm[0] = _dur;
	}
	s_amnt = _amnt;
}