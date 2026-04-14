// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function loadPlayerData(){
	if (file_exists("playerSave.save")){
		var playerDataBuff = buffer_load("playerSave.save");
		var playerDataString = buffer_read(playerDataBuff, buffer_string);
		buffer_delete(playerDataBuff);
		var playerData = json_parse(playerDataString);
		
		global.playerData[0] = playerData.playerData;
		global.players[0].team = playerData.team;
	}
}