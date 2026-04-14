// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function loadFull(){
	if (file_exists("savefile.save")){
		var dataBuff = buffer_load("savefile.save");
		var dataString = buffer_read(dataBuff, buffer_string);
		buffer_delete(dataBuff);
		var data = json_parse(dataString);
		global.loadPosBuffer = {
			x	:	data.x,
			y	:	data.y,
			loading : true
		}
		if (array_length(global.players) == 0){
			objGame.storyGenPlayer();	
		}
		global.playerData[0] = data.playerData;
		global.players[0].team = data.team;
		
		room_goto(data.room);
	}
}