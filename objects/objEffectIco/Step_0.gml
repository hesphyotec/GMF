if (position_meeting(mouse_x, mouse_y, id)){
	if (!hovered){
		hovered = true;
		onHover();
	}
} else {
	hovered = false;	
}
if (--effect.duration <= 0){
	instance_destroy(id);
}