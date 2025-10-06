scrGetInput();
if (active && (alarm[0] <=0)){
	if (leftPress){
		updateSelection(-1);
	}
	if (rightPress){
		updateSelection(1);
	}
	if (upPress){
		updateSelection(-1);
	}
	if (downPress){
		updateSelection(1);
	}
	if (interactPress){
		switch(menuState){
			case BMENUST.ACTION:
				doFunction(options[selection]);
				break;
			case BMENUST.ATTACK:
				action = options[selection];
				chooseTarget(team2Chars);
				break;
			case BMENUST.SPELL:
				action = options[selection];
				var spell = struct_get(global.data.moves[$"spells"], action);
				show_debug_message(string(spell));
				if (variable_struct_exists(spell,"damage")){
					chooseTarget(team2Chars);	
				}
				if (variable_struct_exists(spell,"heal")){
					chooseTarget(team1Chars);	
				}
				break;
			case BMENUST.TARGET:
				target = options[selection];
				doFunction(BOPS.TARGET);
				break;
		}
		audio_play_sound(sndChoose,1,false);
	}
	if (sprint){
		doFunction(BOPS.BACK);
	}

}