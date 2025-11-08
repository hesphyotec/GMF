if (follow != undefined){
	xto = follow.x
	yto = follow.y
} else {
	if (instance_exists(objOWPlayer)) {
		follow = objOWPlayer;	
	}
}

x += ceil((xto - x)/5);
y += ceil((yto - y)/5);

var tX = clamp(ceil(x-(camwidth*0.5)),0, room_width - (camwidth));
var tY = clamp(ceil(y-(camheight*0.5)), 0, room_height - (camheight));

camera_set_view_pos(view_camera[0], tX, tY);

if (alarm[0] > 0){
	var _shake_x = random_range(-s_amnt, s_amnt);
	var _shake_y = random_range(-s_amnt, s_amnt);
	x += _shake_x;
	y += _shake_y;
}