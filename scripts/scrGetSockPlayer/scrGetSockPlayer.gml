// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scrGetSockPlayer(sock){
	for(var i = 0; i < array_length(global.players); ++i){
		if(global.players[i].sockId == sock){
			return global.players[i];	
		}
	}
	return undefined;
}