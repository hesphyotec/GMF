lines = [];
choices = [];
results = [];
result = undefined;
currentLine = 0;
active = false;
textProgress = 0;
selection = 0;
source = undefined;

dialogueData = global.data.dialogue;

loadDiag = function(diagChar, diag, src){
	source = src;
	currentDiag = struct_get(diagChar, diag);
	lines = currentDiag[$"dialogue"];
	if (struct_exists(currentDiag, "choices")){
		choices = currentDiag[$"choices"];
		results = currentDiag[$"result"];
	}
	currentLine = 0;
	active = true;
	objOWPlayer.inMenu = true;
}

writeDiag = function(){
	if (textProgress < string_length(lines[currentLine])){
		textProgress += 1;
		audio_play_sound(sndSelect, 1, false);
	} else if (array_length(choices) <= 0){
		if (interactPress){
			audio_play_sound(sndChoose, 1, false);
			textProgress = 0;
			if ((currentLine + 1) >= array_length(lines)){
				endDiag();
			} else {
				++currentLine;	
			}
		}
	} else if (array_length(choices) > 0){
		if (interactPress){
			result = results[selection];
			if (struct_exists(result, "op")){
				if(result[$"op"] == "recruit"){
					if (array_length(objPlayer.team) < 4){
						with(objPlayer){
							partyAdd(struct_get(global.data.companions, other.result[$"comp"]));
							audio_play_sound(sndGet,1, false);
						}
						instance_destroy(source);
					}
					endDiag();
				} else if (result[$"op"] == "endDiag"){
					endDiag();
				}
			}
		}
	}
}

displayDiag = function(){
	draw_set_color(c_black);
	draw_sprite(sprDiag,0,display_get_gui_width()/2 - 120,display_get_gui_height());
	var shownText = string_copy(lines[currentLine], 1, textProgress);
	draw_set_font(fntBattle);
	draw_text_ext(display_get_gui_width()/2 - 108, display_get_gui_height()-64, shownText, 16, 220);
	draw_set_color(c_white);
	
	if (textProgress == string_length(lines[currentLine])){
		for(var i = 0; i < array_length(choices); ++i){
			var option = choices[i];
			var color = (i == selection) ? c_yellow : c_black;
			draw_set_colour(color);
			draw_text(display_get_gui_width()/2 - 108 + (64*i), display_get_gui_height()-32, option);
		}
		draw_set_colour(c_white);
	}
}

endDiag = function(){
	lines = [];
	choices = [];
	active = false;
	currentLine = 0;
	source = undefined;
	textProgress = 0;
	results = [];
	selection = 0;
	result = undefined;
	objOWPlayer.alarm[0] = 15; // Leaves menu
}