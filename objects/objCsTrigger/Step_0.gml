if (!instance_exists(objCutscene)){
	if (place_meeting(x, y, target)){
		createCutscene(tSceneInfo);
		instance_destroy(id);
	}
}