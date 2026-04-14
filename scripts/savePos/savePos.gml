// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function savePos(){
	var toSave = array_create(0);
	
	with(objNPC){
		var npcPos = {
			obj	:	object_get_name(object_index),
			x	:	x,
			y	:	y,
			dir : dir
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
	var stringInfo = json_stringify(toSave);
	var savBuff = buffer_create(string_byte_length(stringInfo) + 1, buffer_fixed, 1);
	buffer_write(savBuff, buffer_string, stringInfo);
	var filename = string(room) + "entPos.save";
	buffer_save(savBuff, filename);
	buffer_delete(savBuff);
}