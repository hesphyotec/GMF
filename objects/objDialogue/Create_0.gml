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

textBox = {
	x	:	8,
	y	:	display_get_gui_height() - 80,
	w	:	240,
	h	:	64
}

textPos = {
	x	:	12,
	y	:	display_get_gui_height() - 76,
	w	:	220
}

choiceBoxPos = {
	x	:	248,
	y	:	display_get_gui_height() - 80,
	w	:	128,
	h	:	64,
}

choiceTextPos = {
	x	:	256,
	y	:	display_get_gui_height() - 72,
	w	:	112,
}

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
		audio_play_sound(sndSelect, 1, false, global.masVolume * global.effVolume);
	} else if (array_length(choices) <= 0){
		if (interactPress){
			audio_play_sound(sndChoose, 1, false, global.masVolume * global.effVolume);
			textProgress = 0;
			if ((currentLine + 1) >= array_length(lines)){
				if (struct_exists(currentDiag, "csTrig")){
					var cs = getCutscene(currentDiag.csTrig);
					createCutscene(cs);
					endDiag();
				} else if (struct_exists(currentDiag, "nextDiag")){
					var speaker = struct_get(dialogueData, currentDiag.nextDiag.speaker);
					var line = currentDiag.nextDiag.line;
					var src = asset_get_index(currentDiag.nextDiag.src);
					endDiag();
					loadDiag(speaker, line, src);
				} else {
					endDiag();	
				}
			} else {
				++currentLine;	
			}
		}
	} else if (array_length(choices) > 0){
		if (interactPress){
			result = results[selection];
			if (struct_exists(result, "op")){
				if(result[$"op"] == "recruit"){
					if (array_length(global.players[0].team) < 4){
						with(global.players[0]){
							audio_play_sound(sndLightning, 1, false, global.masVolume * global.effVolume);
							partyAdd(other.result[$"comp"]);
							audio_play_sound(sndGet,1, false, global.masVolume * global.effVolume);
						}
						instance_destroy(source);
					}
					endDiag();
				} else if (result[$"op"] == "endDiag"){
					endDiag();
				} else if (result.op == "trigCs"){
					var cs = getCutscene(result.csId);
					endDiag();
					createCutscene(cs);
				} else if (result.op == "nextDiag"){
					var speaker = struct_get(dialogueData, result.speaker);
					var line = result.line;
					var src = asset_get_index(result.src);
					endDiag();
					loadDiag(speaker, line, src);
				}
			}
		}
	}
}

displayDiag = function(){
	draw_set_color(c_black);
	draw_sprite_stretched(sprDiagBox,0, textBox.x , textBox.y, textBox.w, textBox.h);
	var shownText = string_copy(lines[currentLine], 1, textProgress);
	draw_set_font(fntBattle);
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	draw_text_ext(textPos.x, textPos.y, shownText, 16, textPos.w);
	draw_set_halign(fa_left);
	draw_set_halign(fa_top);
	draw_set_color(c_white);
	
	if (textProgress == string_length(lines[currentLine])){
		if (array_length(choices) > 0){
			draw_sprite_stretched(sprDiagBox, 0, choiceBoxPos.x, choiceBoxPos.y, choiceBoxPos.w, choiceBoxPos.h);
		} else {
			draw_sprite(sprTutPlayerSpirit, image_index, textBox.x + textBox.w - 32, textBox.y + textBox.h - 32);	
		}
		for(var i = 0; i < array_length(choices); ++i){
			var option = choices[i];
			var color = (i == selection) ? c_yellow : c_black;
			draw_set_colour(color);
			draw_text_ext(choiceTextPos.x, choiceTextPos.y + (12 * i), option, 16, choiceTextPos.w);
		}
		draw_set_colour(c_white);
	}
}

endDiag = function(){
	if (instance_exists(source)){
		if (variable_instance_exists(source, "interactCd")){
			source.interactCd = true;
			source.alarm[0] = 15;
		}
	}
	lines = [];
	choices = [];
	active = false;
	currentLine = 0;
	source = undefined;
	textProgress = 0;
	results = [];
	selection = 0;
	result = undefined;
	objOWPlayer.inMenu = false; // Leaves menu
}