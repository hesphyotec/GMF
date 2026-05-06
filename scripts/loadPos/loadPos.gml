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
		with (objCsTrigger){
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
			if (struct_exists(toLoad, "dir")){
				ent.dir = toLoad.dir;	
			}
			if (struct_exists(toLoad, "tSceneInfo")){
				ent.tSceneInfo = toLoad.tSceneInfo;
			}
			if (struct_exists(toLoad, "state")){
				ent.state = toLoad.state;	
			}
			if (struct_exists(toLoad, "line")){
				ent.line = toLoad.line;	
			}
			if (object_get_name(toLoadObj) == object_get_name(objPickup)){
				if (struct_exists(toLoad, "item")){
					//show_debug_message("Item found: " + toLoad.item);
					ent.setItem(toLoad.item);
				}
			}
			if (struct_exists(toLoad, "enemy")){
				ent.enemy = toLoad.enemy;	
			}
			if (struct_exists(toLoad, "diagChar")){
				ent.diagChar = toLoad.diagChar;	
			}
			if (struct_exists(toLoad, "empty")){
				ent.empty = toLoad.empty;	
			}
			if (object_get_name(toLoadObj) == object_get_name(objOWPlayer)){
				ent.mapPos = [floor(toLoad.x / TILE_SIZE), floor(toLoad.y / TILE_SIZE)];
			}
		}
		file_delete(filename);
	}
}
//if (variable_instance_exists(id, "state")){
//			npcPos.state = state;	
//		}
//		if (variable_instance_exists(id, "line")){
//			npcPos.line = line;	
//		}
//		if (variable_instance_exists(id, "item")){
//			npcPos.item = item;	
//		}
//		if (variable_instance_exists(id, "enemy")){
//			npcPos.enemy = enemy;	
//		}
//		if (variable_instance_exists(id, "diagChar")){
//			npcPos.diagChar = diagChar;	
//		}
//		if (variable_instance_exists(id, "empty")){
//			npcPos.empty = empty;	
//		}