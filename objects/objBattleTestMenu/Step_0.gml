scrGetInput();

if (upPress){
	updateSelection(-1);
	audio_play_sound(sndSelect, 1, false);
}
if (downPress){
	updateSelection(1);
	audio_play_sound(sndSelect, 1, false);
}

if (interactPress){
	switch(state){
		case TESTOPS.START:
			doOperation(options[selected]);
			break;
		case TESTOPS.BUILDTEAM:
			doOperation(TESTOPS.SELECTMEM);
			break;
		case TESTOPS.CHOOSEFIGHT:
			doOperation(TESTOPS.START);
			break;
	}
	audio_play_sound(sndChoose, 1, false);
}