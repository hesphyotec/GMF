if(state != CHARSTATES.IDLE && state != CHARSTATES.SELECTED && animating){
	state = CHARSTATES.IDLE;
	animating = false;
	sprite_index = asset_get_index(character[$"sprite"]);
	objBattleMenu.animFinish();
}