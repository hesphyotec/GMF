// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function createCutscene(info){
	var cs = instance_create_layer(0,0, "Backend", objCutscene);
	with (cs){
		sceneInfo = info;
		event_perform(ev_other, ev_user0);
	}
}