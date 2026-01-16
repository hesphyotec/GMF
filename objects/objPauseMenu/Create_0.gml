enum PMENU{
	RESUME,
	OPTIONS,
	MAINMENU,
	MASVOLUME,
	MUSVOLUME,
	EFFVOLUME,
	BACK,
	QUIT
}

open = false;
active = true;

opening = false;
closing = false;

options = [PMENU.RESUME, PMENU.OPTIONS, PMENU.MAINMENU, PMENU.QUIT];
buttons = [];

bg = undefined;

menubg = {
	X : 0,
	Y : 0,
	w : 0,
	h : display_get_gui_height(),
	tweenW : 0,
	col : c_black,
	a : .75
}

buttonW = 128;
buttonH = 32;
buttonX = display_get_gui_width()/2 - buttonW/2;
buttonY = 64;
buttonSpace = buttonH + 8;

moveRate = .3;

openMenu = function(){
	open = true;
	opening = true;
	loadButtons();
	createBg();
	bg.targetX = display_get_gui_width();
	if(object_exists(objOWPlayer)){
		objOWPlayer.inMenu = true;	
	}
}

closeMenu = function(){
	active = false;
	closing = true;
	clearButtons();
	bg.targetX = 0;
	if(object_exists(objOWPlayer)){
		objOWPlayer.inMenu = false;	
	}
}

loadButtons = function(){
	show_debug_message("Loading Buttons!");
	for(var i = 0; i < array_length(options); ++i){
		var butt = createButton(buttonX, buttonY + (buttonSpace * i), buttonW, buttonH, sprButtonTest, GUI.TEXTBUTTON, {text : "ERROR", index : i});
		switch(options[i]){
			case PMENU.RESUME:
				with (butt){
					data.text = "Resume";
					onClick = function(){
						objPauseMenu.closeMenu();	
					}
				}
				break;
			case PMENU.OPTIONS:
				with (butt){
					data.text = "Options";
					onClick = function(){
						objPauseMenu.loadSettings();	
					}
				}
				break;
			case PMENU.MAINMENU:
				with (butt){
					data.text = "Main Menu";
					onClick = function(){
						audio_stop_all();
						instance_destroy(all);
						room_goto(rmTestSelect);
					}
				}
				break;
			case PMENU.QUIT:
				with (butt){
					data.text = "Quit";
					onClick = function(){
						game_end(0);
					}
				}
				break;
			case PMENU.MASVOLUME:
				with (butt){
					type = GUI.SLIDER;
					data.text = "Master Volume";
					slideVal = global.masVolume;
					onHold = function(){
						slideVal = (device_mouse_x_to_gui(0) - xPos) / width;
						global.masVolume = slideVal;
						audio_master_gain(global.masVolume);
					}
				}
				break;
			case PMENU.MUSVOLUME:
				with (butt){
					type = GUI.SLIDER;
					data.text = "Music Volume";
					slideVal = global.musVolume;
					onHold = function(){
						slideVal = (device_mouse_x_to_gui(0) - xPos) / width;
						global.musVolume = slideVal;
					}
				}
				break;
			case PMENU.EFFVOLUME:
				with (butt){
					type = GUI.SLIDER;
					data.text = "Effect Volume";
					slideVal = global.effVolume;
					onHold = function(){
						slideVal = (device_mouse_x_to_gui(0) - xPos) / width;
						global.effVolume = slideVal;
					}
				}
				break;
			case PMENU.BACK:
				with (butt){
					data.text = "Back";
					onClick = function(){
						objPauseMenu.loadPauseOps();
					}
				}
				break;
		}
		array_push(buttons, butt);
	}
}

clearButtons = function(){
	for(var i = array_length(buttons) - 1; i >= 0; --i){
		instance_destroy(buttons[i]);
		array_delete(buttons, i, 1);
	}
}

createBg = function(){
	bg = createButton(menubg.X, menubg.Y, menubg.w, menubg.h, sprButtonTest, GUI.BOXCONTAINER, menubg);
	bg.tweenSpeed = .3;
}

loadSettings = function(){
	instance_destroy(bg);
	options = [PMENU.MASVOLUME, PMENU.MUSVOLUME, PMENU.EFFVOLUME, PMENU.BACK];
	clearButtons();
	loadButtons();
	bg = createButton(menubg.X, menubg.Y, display_get_gui_width(), menubg.h, sprButtonTest, GUI.BOXCONTAINER, menubg);
	bg.tweenX = display_get_gui_width();
}

loadPauseOps = function(){
	instance_destroy(bg);
	options = [PMENU.RESUME, PMENU.OPTIONS, PMENU.MAINMENU, PMENU.QUIT];
	clearButtons();
	loadButtons();
	bg = createButton(menubg.X, menubg.Y, display_get_gui_width(), menubg.h, sprButtonTest, GUI.BOXCONTAINER, menubg);
	bg.tweenX = display_get_gui_width();
}