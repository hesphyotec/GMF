scrGetInput();
if (debug){
	global.debug = !global.debug;	
}

if (keyboard_check_pressed(vk_f5)){
	room_goto_next();	
}
if (keyboard_check_pressed(vk_f6)){
	room_goto_previous();	
}
if (keyboard_check_pressed(vk_f7)){
	saveFull();
}
if (keyboard_check_pressed(vk_f8)){
	loadFull();	
}
if (keyboard_check_pressed(vk_f9)){
	deleteSaveData();	
}