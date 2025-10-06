if (follow != noone){
	xto = follow.x
	yto = follow.y
}

x += ceil((xto - x)/5);
y += ceil((yto - y)/5);
camera_set_view_pos(view_camera[0], x-camwidth*0.5, y-(camheight*0.5));

if (alarm[0] > 0){
	var _shake_x = random_range(-s_amnt, s_amnt);
	var _shake_y = random_range(-s_amnt, s_amnt);
	x += _shake_x;
	y += _shake_y;
}