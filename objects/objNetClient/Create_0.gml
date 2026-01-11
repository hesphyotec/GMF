socket = network_create_socket(network_socket_tcp);
global.server = network_connect(socket, "127.0.0.1", 22566);
global.isServer = false;


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
			var sock = buffer_read(buff, buffer_u8);
			global.socket = sock;
			break;
		case NET.OPPONENTADDED:
			if (DEBUG_ENABLED) clientLog("Opponent Added");
			var race = buffer_read(buff, buffer_u8);
			addOpponent(race);
			break;
		case NET.INITEXISTING:
			var oppData = json_parse(buffer_read(buff, buffer_string));
			clientLog("Loading Opponent (Existing)");
			addExistingOpponent(oppData);
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
		case NET.READYCHAR:
			var fname = buffer_read(buff, buffer_string);
			clientLog(fname + " is ready!");
			objBattleController.context.playerTeam.charReady(scrGetCharFromName(fname));	
			break;
		case NET.UPDATECHAR:
			var char = json_parse(buffer_read(buff, buffer_string));
			clientLog("Update incoming for: " + char.key);
			objBattleController.netUpdateChar(char);
			break;
		case NET.STARTQTE:
			objBattleMenu.netStartQTE();
			break;
		case NET.ENDTURN:
			var char = json_parse(buffer_read(buff, buffer_string));
			objBattleController.endTeamTurn(char);
			var actor = objBattleMenu.getActor(char);
			actor.startTimer(1);
			break;
		case NET.DOANIM:
			var actInfo = json_parse(buffer_read(buff, buffer_string));
			objBattleMenu.doAnimation(actInfo);
			break;
		case NET.CHARDOWNED:
			var char = json_parse(buffer_read(buff, buffer_string));
			objBattleController.doNetDowned(char);
			break;
			
	}
}

addOpponent = function(race){
	var opp = objGame.generatePlayer(-1, race);
	opp.generateNetPlayer();
}

addExistingOpponent = function(opp){
	var opponent = objGame.generatePlayer(opp.sockId, opp.race);
	opponent.team = opp.team;
	opponent.mapPos = opp.mapPos
	opponent.generateNetPlayer();
	opponent.character.x = opp.mapPos[0] * TILE_SIZE;
	opponent.character.y = opp.mapPos[1] * TILE_SIZE;
}

addPlayer = function(race){
	var player = objGame.generatePlayer(global.socket, race);
	player.generatePlayer();
}

if (global.server < 0){
	//global.server = network_connect(socket, "25.48.104.187", 22566);
	//scrInitPlayer(global.server);
	addPlayer(RACE.HUMAN);
} else {
	clientLog("Connected!");
	scrInitPlayer(global.server);
}
