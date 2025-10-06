lines = [];
choices = [];
currentLine = 0;
active = false;
textProgress = 0;

dialogueData = global.data.dialogue;

loadDiag = function(diagChar){
	lines = diagChar[$"dialogue"];
	if (variable_struct_exists(diagChar, "choices")){
		choices = diagChar[$"choices"];
	}
	currentLine = 0;
	active = true;
	objOWPlayer.inMenu = true;
}

writeDiag = function(){
	if (textProgress < string_length(lines[currentLine])){
		textProgress += 1;	
	} else if (interact){
		textProgress = 0;
		if ((currentLine + 1) >= array_length(lines)){
			lines = [];
			choices = [];
			active = false;
			currentLine = 0;
			objOWPlayer.alarm[0] = 30; // Leaves menu
		} else {
			++currentLine;	
		}
	}
}

displayDiag = function(){
	draw_set_color(c_black);
	draw_rectangle(0,0, display_get_gui_width(), 256, false);
	
	var shownText = string_copy(lines[currentLine], 1, textProgress);
	draw_set_color(c_white);
	draw_text(16, 240, shownText);
}