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

startTurn = function(){
	if (array_length(activeTeamQueue) > 0){
		fighter = activeTeamQueue[0];
		array_delete(activeTeamQueue, 0, 1);
		if(DEBUG_ENABLED) show_debug_message("[TeamMan] " + string(fighter));
		if(DEBUG_ENABLED) show_debug_message("[TeamMan] Starting turn for" + string(fighter[$"name"]));
		if(DEBUG_ENABLED) show_debug_message("[TeamMan] Enemy Team Remaining: " + string(array_length(battleInfo.team2)));
		for(var i = 0; i < array_length(activeTeamQueue); ++i){
			if (DEBUG_ENABLED) show_debug_message("[TeamMan] Current order [" + string(i) + "]: " + string(activeTeamQueue[i][$"name"]));
		}
		
		//scrNBStartTurn(player, fighter.id);
	}
}

loadTeam = function(tm){
	team = tm;
	array_copy(waiting, 0, team, 0, array_length(team));
}

endTurn = function(){
	if(DEBUG_ENABLED) show_debug_message("[TeamMan] Enemy Team Remaining: " + string(array_length(battleInfo.team2)));
	array_push(waiting, fighter);
	if(DEBUG_ENABLED) show_debug_message("[TeamMan] Enemy Team Remaining: " + string(array_length(battleInfo.team2)));
	
	//scrNBEndTurn(player);
	if (array_length(activeTeamQueue) <= 0){
		allwait = true;
	} else {
		startTurn();
	}
}


charReady = function(ftr){
	if (DEBUG_ENABLED) show_debug_message("[BController]" + ftr[$"name"] + " Check Ready!");
	if (scrCheckTeam(waiting, ftr)){
		if (DEBUG_ENABLED) show_debug_message("[BController]" + ftr[$"name"] + " was waiting in this team!");
		var readyInd = scrTeamCharGetInd(waiting, ftr);
		var ready = array_get(waiting, readyInd);
		array_delete(waiting, readyInd, 1);
		array_push(activeTeamQueue, ready);
		if (allwait){
			allwait = false;
			startTurn();
		}
	}
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
	//scrNBCharDowned(sock, ftr.id);
	if (array_length(activeTeamQueue) == 0 && array_length(waiting) == 0){
		//scrNBEndBattle( not this player );
	}
}


