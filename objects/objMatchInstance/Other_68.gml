var eventId = async_load[?"id"];
if (DEBUG_ENABLED) show_debug_message("Packet Recieved!");
if (global.server == eventId){
	var type = async_load[?"type"];
	var sock = async_load[?"socket"];
	if (DEBUG_ENABLED) show_debug_message(string(type));
	switch(type){
		case network_type_connect:
			serverLog("Player with socket: " + string(sock) + " Connected!");
			array_push(global.sockets, sock);
			break;
		case network_type_disconnect:
			var sInd = array_get_index(global.sockets, sock); 
			array_delete(global.sockets, sInd, 1);
			var plr = scrGetSockPlayer(sock);
			var playerInd = array_get_index(global.players, plr);
			array_delete(global.players, playerInd, 1);
			serverLog("Player with socket: " + string(sock) + " Disconnected!");
			break;
	}
} else {
	var type = async_load[?"type"];
	if (type == network_type_data){
		handleData();
	}
}