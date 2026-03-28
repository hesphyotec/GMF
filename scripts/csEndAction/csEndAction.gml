// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function csEndAction(){
	show_debug_message("Ending cutscene action!");
	scene++;
	if (scene > array_length(sceneInfo) - 1){
		instance_destroy(id);
		return;
	}
	event_perform(ev_other, ev_user0);
}