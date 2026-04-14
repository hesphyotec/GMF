// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function savePlayerData(){
	var toSave = {
		playerData	:	global.playerData[0],
		team		:	global.players[0].team,
	}
	var stringInfo = json_stringify(toSave);
	var savBuff = buffer_create(string_byte_length(stringInfo) + 1, buffer_fixed, 1);
	buffer_write(savBuff, buffer_string, stringInfo);
	buffer_save(savBuff, "playerSave.save");
	buffer_delete(savBuff);
}