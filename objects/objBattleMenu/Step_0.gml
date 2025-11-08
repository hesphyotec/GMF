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
				if (DEBUG_ENABLED) show_debug_message("[Menu] Enemies: " + string(battleInfo.team2));
				chooseTarget(battleInfo.team2);
				break;
			case BMENUST.SPELL:
				action = options[selection];
				var spell = struct_get(splData, action);
				if (DEBUG_ENABLED) show_debug_message("[Menu]" + string(spell));
				if (spell[$"cost"] <= fighter[$"mana"] || spell[$"cost"] <= fighter[$"energy"] || !(struct_exists(fighter, "mana")) || struct_exists(fighter, "energy")){
					if (variable_struct_exists(spell,"type")){
						if (spell[$"type"] == "dmgSpell" || spell[$"type"] == "debuffSpell"){
							if (DEBUG_ENABLED) show_debug_message("[Menu] Enemies: " + string(battleInfo.team2) + string(battleInfo.team2));
							chooseTarget(battleInfo.team2);	
						}	
						if (spell[$"type"] == "restoreSpell" || spell[$"type"] == "buffSpell"){
							chooseTarget(battleInfo.team1);	
						}
						if (spell[$"type"] == "selfSpell"){
							chooseTarget([fighter]);	
						}
					}
				} else {
					audio_play_sound(sndNoResource, 1, false);
				}
				break;
			case BMENUST.ITEMS:
				item = options[selection];
				if (DEBUG_ENABLED) show_debug_message("[Menu]" + string(item));
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
				if (DEBUG_ENABLED) show_debug_message("[Menu]" + string(target[$"cid"]));
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

if (fighter != undefined){
	if (fighter[$"hp"] <= 0){
		turnEnd();
		context.playerTeam.endTurn();
	}
}