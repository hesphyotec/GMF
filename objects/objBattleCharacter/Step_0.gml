if (hovered){
	yOff = sin(current_time/150) * 4 - 4;
} else {
	yOff = 0;	
}
if (character[$"hp"] <= 0 && downed == false){
	doDowned();
}

if (character[$"hp"] > 0){
	timerStep();
	tickEffects();
}

if (context.menu != undefined && context.menu.active && battleInfo.menuState == BMENUST.TARGET){
	hovered = (context.menu.options[context.menu.selection] == character);
} else {
	hovered = false;
}

