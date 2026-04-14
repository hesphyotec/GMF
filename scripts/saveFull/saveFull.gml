// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function saveFull(){
	var toSave = {
		playerData	:	global.playerData[0],
		team		:	global.players[0].team,
		room		:	room,
		x			:	objOWPlayer.x,
		y			:	objOWPlayer.y
	}
	var stringInfo = json_stringify(toSave);
	var savBuff = buffer_create(string_byte_length(stringInfo) + 1, buffer_fixed, 1);
	buffer_write(savBuff, buffer_string, stringInfo);
	buffer_save(savBuff, "savefile.save");
	buffer_delete(savBuff);
}