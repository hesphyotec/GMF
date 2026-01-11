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
				selectAttack();
				break;
			case BMENUST.SPELL:
				selectSpell();
				break;
			case BMENUST.ITEMS:
				selectItem();
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
				selectTarget();
				break;
		}
		audio_play_sound(sndChoose,1,false);
	}
	if (sprintPress || mouse_check_button_pressed(mb_right)){
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