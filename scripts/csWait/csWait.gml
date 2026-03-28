///@description Waits n seconds in cutscene.
function csWait(sec){
	show_debug_message(string(sec));
	show_debug_message(string(timer));
	show_debug_message(string(fps));
	if (timer++ >= (sec * fps)){
		timer = 0;
		csEndAction();
	}
}