#macro PORT 22566
#macro MAXCLIENTS 2
global.isServer = true;
scrNetworkMacros();
server = network_create_server(network_socket_tcp, PORT, MAXCLIENTS);
if (server < 0){
	//Failsafe code here
	
}

clients = {};
sockets = [];

ply1Pos = [0,0];
ply2Pos = [0,0];

handleData = function(){
	if (DEBUG_ENABLED) show_debug_message("Packet Being Handled!");
	var buff = async_load[?"buffer"];
	var sock = async_load[?"id"];
	var op = buffer_read(buff, buffer_u8);
	if (DEBUG_ENABLED) show_debug_message(op);
	switch(op){
		case NET.ADDPLAYER:
			if (DEBUG_ENABLED) show_debug_message("Player connected!");
			for(var i = array_length(sockets) - 1; i >= 0; --i){
				if (sockets[i] == sock){
					if (DEBUG_ENABLED) show_debug_message("Sending player to generate!");
					if(array_length(global.players) > 0){
						addOpponent(sock);
					}
					addPlayer(sock);
					
				} else {
					if (DEBUG_ENABLED) show_debug_message("Sending Opponent to generate!");
					addOpponent(sockets[i]);
				}
			}
			break;
		case NET.KEY:
			if (DEBUG_ENABLED) show_debug_message("Key Received");
			var _up = buffer_read(buff, buffer_u8);
			var _down = buffer_read(buff, buffer_u8);
			var _left = buffer_read(buff, buffer_u8);
			var _right = buffer_read(buff, buffer_u8);
			var plyr = scrGetSockPlayer(sock);
			var mTar = plyr.getMTar(_up, _down, _left, _right);
			if (DEBUG_ENABLED) show_debug_message("Position: " + string(mTar));
			for(var i = array_length(sockets) - 1; i >= 0; --i){
				if (sock != sockets[i]){
					scrSendTarPos(sockets[i], mTar[0][0], mTar[0][1]);
				} else {
					scrSendPlayerTarPos(sockets[i], mTar[0][0], mTar[0][1]);
				}
			}
			if(array_length(global.players) == 2){
				ply1Pos = global.players[0].mapPos;
				ply2Pos = global.players[1].mapPos;
			}
			break;
		case NET.MOVE:
			var _x = buffer_read(buff, buffer_u8);
			var _y = buffer_read(buff, buffer_u8);
			var ply = scrGetSockPlayer(sock);
			ply.X = _x;
			ply.Y = _y;
			for(var i = array_length(sockets) - 1; i >= 0; --i){
				if (sock != sockets[i]){
					scrSendTarPos(sockets[i], ply.X, ply.Y);
				}
			}
			break;
		case NET.ADDCOMP:
			var comp = buffer_read(buff, buffer_string);
			var ply = scrGetSockPlayer(sock);
			ply.partyAdd(comp);
			for(var i = array_length(sockets) - 1; i >= 0; --i){
				if (sock != sockets[i]){
					scrNetUpdateComps(sockets[i], comp);
				}
			}
			if(DEBUG_ENABLED) show_debug_message(string(ply.team));
			break;
	}
}

addPlayer = function(sock){
	if (array_length(global.players) < MAXCLIENTS){
		objGame.generatePlayer(sock);
		scrInitPlayerServ(sock);
	}
}

addOpponent = function(sock){
	scrInitNetPlayerServ(sock);
}