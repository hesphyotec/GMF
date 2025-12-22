/// @description Insert description here
// You can write your code in this editor
textlog = [];
start = 0;
logTextPadding = 4;
logTextSpacing = 12;
active = false;

addEntry = function(msg){
	var log = "[ " + string(current_hour) + ":" + string(current_minute) + ":" + string(current_second) + " ]" + ": " + msg;
	array_insert(textlog, 0, log);	
}

drawLog = function(){
	draw_set_color(c_black);
	draw_set_alpha(.7);
	draw_rectangle(0,0,display_get_gui_width(), display_get_gui_height(), false);
	draw_set_alpha(1);
	draw_set_colour(c_white);
	if (array_length(textlog) > 0){
		draw_set_halign(fa_left);
		draw_set_font(fntHP);
		draw_set_color(c_red);
		for(var i = start; i < array_length(textlog); ++i){
			draw_text_ext(logTextPadding, display_get_gui_height() - (logTextSpacing * (i - start)) - 16, textlog[i], logTextSpacing, display_get_gui_width() - logTextPadding);
		}
		draw_set_color(c_white);
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
