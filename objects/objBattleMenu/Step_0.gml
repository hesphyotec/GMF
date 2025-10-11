scrGetInput();
if (active && (alarm[0] <=0)){
	if (leftPress){
		updateSelection(-1);
	}
	if (rightPress){
		updateSelection(1);
	}
	if (upPress){
		if (battleInfo.menuState != BMENUST.ACTION && selection == 0){
			doFunction(BOPS.BACK);
			audio_play_sound(sndBack,1,false);
		} else {
			updateSelection(-1);
		}
	}
	if (downPress){
		if (battleInfo.menuState == BMENUST.ACTION){
			doFunction(options[selection]);
			audio_play_sound(sndChoose,1,false);
		} else {
			updateSelection(1);
		}
	}
	if (interactPress){
		switch(battleInfo.menuState){
			case BMENUST.ACTION:
				doFunction(options[selection]);
				break;
			case BMENUST.ATTACK:
				action = options[selection];
				if (DEBUG_ENABLED) show_debug_message("Enemies: " + string(battleInfo.team2));
				chooseTarget(battleInfo.team2);
				break;
			case BMENUST.SPELL:
				action = options[selection];
				var spell = struct_get(splData, action);
				show_debug_message(string(spell));
				if (spell[$"cost"] <= battleInfo.activeFighter[$"mana"]){
					if (variable_struct_exists(spell,"type")){
						if (spell[$"type"] == "dmgSpell"){
							if (DEBUG_ENABLED) show_debug_message("Enemies: " + string(battleInfo.team2) + string(battleInfo.team2));
							chooseTarget(battleInfo.team2);	
						}	
						if (spell[$"type"] == "restoreSpell" || spell[$"type"] == "buffSpell"){
							chooseTarget(battleInfo.team1);	
						}
						if (spell[$"type"] == "selfSpell"){
							chooseTarget([battleInfo.activeFighter]);	
						}
					}
				} else {
					audio_play_sound(sndNoResource, 1, false);
				}
				break;
			case BMENUST.ITEMS:
				item = options[selection];
				show_debug_message(string(item));
				if (variable_struct_exists(item,"abil")){
					if (item[$"abil"] == "heal" || item[$"abil"] == "restore"){
						chooseTarget(battleInfo.team1);	
					} else {
						chooseTarget(battleInfo.team2);	
					}	
				}
				break;
			case BMENUST.FLEE:
				if (selection == 1){
					flee();
				} else {
					doFunction(BOPS.BACK);
					audio_play_sound(sndBack,1,false);
				}
				break;
			case BMENUST.TARGET:
				target = options[selection];
				doFunction(BOPS.TARGET);
				break;
		}
		audio_play_sound(sndChoose,1,false);
	}
	if (sprintPress){
		doFunction(BOPS.BACK);
		audio_play_sound(sndBack,1,false);
	}

}