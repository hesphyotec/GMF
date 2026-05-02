if (!global.isServer){
	if (hovered){
		yOff = sin(current_time/150) * 4 - 4;
	} else {
		yOff = 0;	
	}
	if (character[$"hp"] <= 0 && downed == false){
		doDowned();
	} else {
		if (context.menu != undefined && context.menu.active && battleInfo.menuState == BMENUST.TARGET){
			if (is_struct(context.menu.options[context.menu.selection])){
				hovered = (context.menu.options[context.menu.selection] == character);
			} else if (is_string(context.menu.options[context.menu.selection])){
				if (context.menu.options[context.menu.selection] == "All Enemies" && !isPlayerTeam){
					hovered = true;	
				}
			}
		} else {
			hovered = false;
		}
	}
	
}

if (character[$"hp"] > 0){
	timerStep();
	tickEffects();
}

sEffectStep();