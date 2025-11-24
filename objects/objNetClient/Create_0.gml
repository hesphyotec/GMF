socket = network_create_socket(network_socket_tcp);
global.server = network_connect(socket, "127.0.0.1", 22566);
global.isServer = false;

if (global.server < 0){
	show_message("Connection to server failed!");
	objGame.generatePlayer(-1);
	global.players[0].generatePlayer();
} else {
	if (DEBUG_ENABLED) show_debug_message("Connected!");
	scrInitPlayer(global.server);
}

//buffer = buffer_create(2048, buffer_grow, 1);
handleData = function(){
	if (DEBUG_ENABLED) show_debug_message("Packet Recieved!");
	var buff = async_load[?"buffer"];
	var op = buffer_read(buff, buffer_u8);
	switch(op){
		case NET.PLAYERADDED:
			if (DEBUG_ENABLED) show_debug_message("Player Added");
			addPlayer();
			break;
		case NET.OPPONENTADDED:
			if (DEBUG_ENABLED) show_debug_message("Opponent Added");
			addOpponent();
			break;
		case NET.MOVE:
			if (DEBUG_ENABLED) show_debug_message("Moving Network Player");
			var mTarX = buffer_read(buff, buffer_u16);
			var mTarY = buffer_read(buff, buffer_u16);
			var mTar = [mTarX, mTarY];
			if (DEBUG_ENABLED) show_debug_message("Moving Network Player");
			global.players[1].character.receiveMove(mTar);
			break;
		case NET.PMOVE:
			if (DEBUG_ENABLED) show_debug_message("Moving Local Player");
			var mTarX = buffer_read(buff, buffer_u16);
			var mTarY = buffer_read(buff, buffer_u16);
			var mTar = [mTarX, mTarY];
			if (DEBUG_ENABLED) show_debug_message("Moving Local Player");
			global.players[0].character.receiveMove(mTar);
			break;
		case NET.OPPADDCOMP:
			var comp = buffer_read(buff, buffer_string);
			global.players[1].oppPartyAdd(comp);
			break;
	}
}

addOpponent = function(){
	var opp = instance_create_layer(0,0, "Instances", objPlayer);
	array_push(global.players, opp);
	objGame.generatePlayer(-1);
	global.players[1].generateNetPlayer();
}

addPlayer = function(){
	objGame.generatePlayer(-1);
	global.players[0].generatePlayer();
}