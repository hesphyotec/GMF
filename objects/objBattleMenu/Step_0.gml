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
					}
				} else {
					audio_play_sound(sndNoResource, 1, false);
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