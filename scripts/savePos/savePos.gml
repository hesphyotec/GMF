// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function savePos(){
	var toSave = array_create(0);
	
	with(objNPC){
		var npcPos = {
			obj	:	object_get_name(object_index),
			x	:	x,
			y	:	y,
			dir : dir,
		}
		if (variable_instance_exists(id, "state")){
			npcPos.state = state;	
		}
		if (variable_instance_exists(id, "line")){
			npcPos.line = line;	
		}
		if (variable_instance_exists(id, "item")){
			npcPos.item = item;	
		}
		if (variable_instance_exists(id, "enemy")){
			npcPos.enemy = enemy;	
		}
		if (variable_instance_exists(id, "diagChar")){
			npcPos.diagChar = diagChar;	
		}
		if (variable_instance_exists(id, "empty")){
			npcPos.empty = empty;	
		}
		array_push(toSave, npcPos);
	}
	with(objOWPlayer){
		var playerPos = {
			obj	:	object_get_name(object_index),
			x	:	x,
			y	:	y,
			dir : dir
		}
		array_push(toSave, playerPos);
	}
	with(objCsTrigger){
		var trigPos = {
			obj	:	object_get_name(object_index),
			x	:	x,
			y	:	y
		}
		array_push(toSave, trigPos);
	}
	var stringInfo = json_stringify(toSave);
	var savBuff = buffer_create(string_byte_length(stringInfo) + 1, buffer_fixed, 1);
	buffer_write(savBuff, buffer_string, stringInfo);
	var filename = string(room) + "entPos.save";
	buffer_save(savBuff, filename);
	buffer_delete(savBuff);
}