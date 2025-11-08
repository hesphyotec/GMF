function scrRoomToGui(wX, wY){
	var cam = view_camera[0];
	
	var camX = camera_get_view_x(cam);
	var camY = camera_get_view_y(cam);
	
	var screenX = (wX - camX);
	var screenY = (wY - camY);
	
	return [screenX, screenY];
}