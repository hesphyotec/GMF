context = undefined;
battleInfo = undefined;

player = undefined;
netTeam = false;
allwait = true;

atkData = global.data.moves[$"attacks"];
splData = global.data.moves[$"spells"];
effData = global.data.effects;
itemData = global.data.items;

fighter = undefined;

activeTeamQueue = [];
team = [];
waiting = [];
actors = [];

startTurn = function(){
	if (array_length(activeTeamQueue) > 0){
		fighter = activeTeamQueue[0];
		array_delete(activeTeamQueue, 0, 1);
		if(DEBUG_ENABLED) serverLog("[TeamMan] " + string(fighter));
		if(DEBUG_ENABLED) serverLog("[TeamMan] Starting turn for" + string(fighter[$"name"]));
		//if(DEBUG_ENABLED) serverLog("[TeamMan] Enemy Team Remaining: " + string(array_length(battleInfo.team2)));
		for(var i = 0; i < array_length(activeTeamQueue); ++i){
			if (DEBUG_ENABLED) serverLog("[TeamMan] Current order [" + string(i) + "]: " + string(activeTeamQueue[i][$"name"]));
		}
	}
}

loadTeam = function(tm){
	team = tm;
	array_copy(waiting, 0, team, 0, array_length(team));
	loadCharacters();
}

endTurn = function(){
	//if(DEBUG_ENABLED) serverLog("[TeamMan] Enemy Team Remaining: " + string(array_length(battleInfo.team2)));
	array_push(waiting, fighter);
	//if(DEBUG_ENABLED) serverLog("[TeamMan] Enemy Team Remaining: " + string(array_length(battleInfo.team2)));
	
	var actor = getActor(fighter);
	actor.startTimer(1);
	scrNBEndTurn(player.sockId, fighter);
	if (array_length(activeTeamQueue) <= 0){
		allwait = true;
	} else {
		startTurn();
	}
}


charReady = function(ftr){
	if (DEBUG_ENABLED) serverLog("[BController]" + ftr[$"name"] + " Check Ready!");
	if (scrCheckTeam(waiting, ftr)){
		if (DEBUG_ENABLED) serverLog("[BController]" + ftr[$"name"] + " was waiting in this team!");
		var readyInd = scrTeamCharGetInd(waiting, ftr);
		var ready = array_get(waiting, readyInd);
		array_delete(waiting, readyInd, 1);
		array_push(activeTeamQueue, ready);
		if (allwait){
			allwait = false;
			startTurn();
		}
	}
	scrNBCharReady(player.sockId, ftr.key);
}

charDied = function(ftr){
	var ind = -1;
	if (scrCheckTeam(activeTeamQueue, ftr)){
		ind = scrTeamCharGetInd(activeTeamQueue, ftr);
		array_delete(activeTeamQueue, ind, 1);
	} else if (scrCheckTeam(waiting, ftr)){
		ind = scrTeamCharGetInd(waiting, ftr);
		array_delete(waiting, ind, 1);	
	}
	//scrNBCharDied(sock, ftr.id);
	if (array_length(activeTeamQueue) == 0 && array_length(waiting) == 0){
		//scrNBEndBattle( not this player );
	}
}

charDowned = function(ftr){
	var ind = -1;
	if (scrCheckTeam(activeTeamQueue, ftr)){
		ind = scrTeamCharGetInd(activeTeamQueue, ftr);
		array_delete(activeTeamQueue, ind, 1);	
	} else if (scrCheckTeam(waiting, ftr)){
		ind = scrTeamCharGetInd(waiting, ftr);
		array_delete(waiting, ind, 1);	
	}
	var data = {
		ftr : ftr	
	}
	scrSendAllSock(method(data, function(socket){
		scrNBCharDowned(socket, ftr);
	}));
	if (array_length(activeTeamQueue) == 0 && array_length(waiting) == 0){
		//scrNBEndBattle( not this player );
	}
}

loadCharacters = function(){
	for (var i = 0; i < array_length(team); ++i){
		var char = instance_create_layer(0, 0, "Instances", objBattleCharacter);
		char.loadSprite(team[i]);
		char.isPlayerTeam = true;
		char.context = context;
		char.battleInfo = battleInfo;
		char.tMan = id;
		array_push(actors, char);
	}
}

charGetActorInd = function(char){
	for(var i = 0; i < array_length(actors); ++i){
		if (actors[i].character[$"cid"] == char[$"cid"]){
			return i;	
		}
	}
	return -1;
}

getActor = function(char){
	return actors[charGetActorInd(char)];
}
