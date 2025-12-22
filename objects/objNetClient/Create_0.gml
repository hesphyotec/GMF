socket = network_create_socket(network_socket_tcp);
global.server = network_connect(socket, "127.0.0.1", 22566);
global.isServer = false;

if (global.server < 0){
	clientLog("Connection to server failed!");
	objGame.generatePlayer(-1, RACE.HUMAN);
	global.players[0].generatePlayer();
} else {
	clientLog("Connected!");
	scrInitPlayer(global.server);
}

//buffer = buffer_create(2048, buffer_grow, 1);
handleData = function(){
	if (DEBUG_ENABLED) clientLog("Packet Recieved!");
	var buff = async_load[?"buffer"];
	var op = buffer_read(buff, buffer_u8);
	switch(op){
		case NET.PLAYERADDED:
			if (DEBUG_ENABLED) clientLog("Player Added");
			var race = buffer_read(buff, buffer_u8);
			addPlayer(race);
			break;
		case NET.OPPONENTADDED:
			if (DEBUG_ENABLED) clientLog("Opponent Added");
			var race = buffer_read(buff, buffer_u8);
			addOpponent(race);
			break;
		case NET.MOVE:
			if (DEBUG_ENABLED) clientLog("Moving Network Player");
			var mTarX = buffer_read(buff, buffer_u16);
			var mTarY = buffer_read(buff, buffer_u16);
			var mTar = [mTarX, mTarY];
			if (DEBUG_ENABLED) clientLog("Moving Network Player");
			global.players[1].character.receiveMove(mTar);
			break;
		case NET.PMOVE:
			if (DEBUG_ENABLED) clientLog("Moving Local Player");
			var mTarX = buffer_read(buff, buffer_u16);
			var mTarY = buffer_read(buff, buffer_u16);
			var mTar = [mTarX, mTarY];
			if (DEBUG_ENABLED) clientLog("Moving Local Player");
			global.players[0].character.receiveMove(mTar);
			break;
		case NET.OPPADDCOMP:
			var comp = buffer_read(buff, buffer_string);
			global.players[1].oppPartyAdd(comp);
			break;
		case NET.STARTBATTLE:
			scrStartBattle(rmHCastleTest, global.players[0].team, global.players[1].team);
			global.isPlayerBattle = true;
			break;
	}
}

addOpponent = function(race){
	objGame.generatePlayer(-1, race);
	global.players[1].generateNetPlayer();
}

addPlayer = function(race){
	objGame.generatePlayer(-1, race);
	global.players[0].generatePlayer();
}