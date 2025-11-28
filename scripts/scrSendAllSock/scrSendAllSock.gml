// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scrSendAllSock(func){
	for(var i = 0; i < array_length(global.sockets); ++i){
		func(global.sockets[i]);	
	}
}