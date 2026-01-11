/// @description Insert description here
// You can write your code in this editor
textlog = [];
start = 0;
logTextPadding = 4;
logTextSpacing = 12;
addEntry = function(msg){
	var log = "[ " + string(current_hour) + ":" + string(current_minute) + ":" + string(current_second) + " ]" + ": " + msg;
	array_insert(textlog, 0, log);	
}

drawLog = function(){
	if (array_length(textlog) > 0){
		draw_set_halign(fa_left);
		draw_set_font(fntHP);
		
		var tY = display_get_gui_height() - 16;
		
		for(var i = start; i < array_length(textlog); ++i){
			var h = string_height_ext(textlog[i], logTextSpacing, display_get_gui_width() - logTextPadding);
			draw_text_ext(logTextPadding, tY - (logTextSpacing * (i - start)) - h, textlog[i], logTextSpacing, display_get_gui_width() - logTextPadding);
			tY -= h;
		}
		//draw_set_halign(fa_center);
	}
}


scroll = function(dir){
	switch(dir){
		case Dirs.UP:
			start = clamp(start - 1, 0, array_length(textlog));
			break;
		case Dirs.DOWN:
			start = clamp(start + 1, 0, array_length(textlog));
			break;
	}
}

addEntry("Log Initialized!");
