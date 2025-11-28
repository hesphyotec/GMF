// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scrSendAllButSource(sock, func1, func2){
	for(var i = array_length(global.sockets) - 1; i >= 0; --i){
		if (global.sockets[i] == sock){
			func1(sock);
		} else {
			func2(global.sockets[i]);
		}
	}
}