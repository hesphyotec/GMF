// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function loadPos(){
	var filename = string(room) + "entPos.save";
	if (file_exists(filename)){
		with (objNPC){
			instance_destroy(id);
		}
		with (objOWPlayer){
			instance_destroy(id);
		}
		var posDataBuff = buffer_load(filename);
		var posDataString = buffer_read(posDataBuff, buffer_string);
		buffer_delete(posDataBuff);
		var posData = json_parse(posDataString);
		
		while(array_length(posData) > 0){
			var toLoad = array_pop(posData);
			var toLoadObj = asset_get_index(toLoad.obj);
			var ent = instance_create_layer(toLoad.x, toLoad.y, "World_Objects", toLoadObj);
			ent.dir = toLoad.dir;
			show_debug_message(string(toLoad));
		}
		file_delete(filename);
	}
}