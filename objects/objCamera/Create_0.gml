camwidth = 480;
camheight = 270;

//camwidth = (ceil((window_get_width() / camwidth))/(window_get_width() / camwidth) * camwidth) 
//camheight = (ceil((window_get_height() / camheight))/(window_get_height() / camheight) * camheight)

camera_set_view_size(view_camera[0], camwidth, camheight);

var viewH = window_get_height();
var viewW = window_get_width();

var scaleH = round(viewH / camheight);
var scaleW = round(viewW / camwidth);
var scale = max(scaleH, scaleW);
view_set_wport(0, camwidth * scale);
view_set_hport(0, camheight * scale);

follow = undefined;

if instance_exists(objOWPlayer){
	follow = objOWPlayer;
} else {
	follow = undefined;	
}
if (room == rmBattle){
	follow = objBattleController;	
}
if (follow != undefined){
	x = follow.x;
	y = follow.y;
}
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
