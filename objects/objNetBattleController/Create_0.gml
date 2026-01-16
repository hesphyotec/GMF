if (DEBUG_ENABLED) serverLog("[BController] Create event start");
turn = 0;

teams = [instance_create_layer(0,0,"Instances", objNetBattleTeamManager),instance_create_layer(0,0,"Instances", objNetBattleTeamManager)];

battleInfo = {
	team1			: [],
	team2			: [],
};

context = {
	controller	: id,
}

activeTurn = 0;
//isPlayerTurn = false;
diedMidTurn = false;
//activeFighter = {stats:{},buffs:[],debuffs:[]};
x = room_width / 2;
y = room_height / 2;

random_set_seed(current_time);


enemyData = global.data.enemies;
atkData = global.data.moves[$"attacks"];
splData = global.data.moves[$"spells"];
itemData = global.data.items;
bData = global.data.effects[$"buffs"];
dbData = global.data.effects[$"debuffs"];

initBattle = function(){
	if (DEBUG_ENABLED) serverLog("Starting Battle");
	serverLog(array_length(global.battles));
	if (array_length(global.battles) <= 0) {
	    if (DEBUG_ENABLED) serverLog("No battles queued!");
	    return;
	}

	array_delete(global.battles, 0, 1);
	
	battleInfo.team1 = global.players[0].team;
	battleInfo.team2 = global.players[1].team;
	
	teams[0].context = context;
	teams[0].player = global.players[0];
	teams[0].loadTeam(battleInfo.team1);
	
	teams[1].context = context;
	teams[1].player = global.players[1];
	teams[1].loadTeam(battleInfo.team2);
	
	for(var i = 0; i < array_length(teams); ++i){
		teams[i].startTurn();
	}
	//audio_play_sound(sndEggyBreakIn, 1, true);
}

endTeamTurn = function(ftr){
	if (DEBUG_ENABLED) serverLog("[BController] " + string(ftr) + " : " + string(battleInfo.team1));
	if(scrCheckTeam(battleInfo.team1, ftr)){
		if (DEBUG_ENABLED) serverLog("[BController] Ending turn for team 1");
		teams[0].endTurn();
	} else if(scrCheckTeam(battleInfo.team2, ftr)) {
		if (DEBUG_ENABLED) serverLog("[BController] Ending turn for team 2");
		teams[1].endTurn();
	}	
}

loadEnemy = function(enemy){
	if (struct_exists(enemyData, enemy)){
		var foe = variable_clone(struct_get(enemyData, enemy));
		if (DEBUG_ENABLED) serverLog("[BController] Loaded Enemy: " + string(foe));
		return foe;
	} else {
		if (DEBUG_ENABLED) serverLog("[BController] Error Loading Enemy!");	
	}
}

loadEncounter = function(encounter){
	if (DEBUG_ENABLED) serverLog("[BController] Loading encounter id: " + string(encounter));
	var foes = [];
	switch(encounter){
		case ENCOUNTERS.TEST:
			foes = ["enemyTest", "bigRock"];
			break;
		case ENCOUNTERS.BANDIT1:
			foes = ["banditGoon", "banditGoon", "banditGoon", "banditThug"];
			break;
	}
	for (var i = 0; i < array_length(foes); ++i){
		var foe = loadEnemy(foes[i]);
		foe.cid = i + 128;
		array_push(battleInfo.team2,foe);
	}
}

doAttack = function(ftr, atk, tar, team, str, final){
		if (DEBUG_ENABLED) serverLog("[BController] " + string(ftr[$"name"]) + " is attacking.");
		if (struct_exists(atkData, atk)){
			var attack = struct_get(atkData, atk);
			if (DEBUG_ENABLED) serverLog("[BController] Retrieved Attack: " + string(atk) + " : " + string(attack));
			doDamage(ftr, tar, attack, str);
		} else {
			if (DEBUG_ENABLED) serverLog("[BController] Error loading attack!");	
		}
		if(final){
			endTeamTurn(ftr);
		}
		
	}
	
doSpell = function(ftr, spl, tar, team, str, final){
	if (DEBUG_ENABLED) serverLog("[BController] " + string(ftr[$"name"]) + " is using a spell.");
	if (struct_exists(splData, spl)){
		var spell = struct_get(splData, spl);
		if (DEBUG_ENABLED) serverLog("[BController] Retrieved Spell: " + string(spl) + " : " + string(spell));
		if(spell[$"type"] == "dmgSpell"){
			doDamage(ftr, tar, spell, str);
		} else if(spell[$"type"] == "restoreSpell"){
			doHeal(ftr, tar, spell);
		}
		if (array_length(spell[$"effects"])){
			var spEffs = spell[$"effects"];
			applyEffects(ftr, spEffs, tar);
		}
	} else {
		if (DEBUG_ENABLED) serverLog("[BController] Error loading spell!");	
	}
	if (struct_exists(ftr, "energy")){
		if (ftr[$"energy"] <= 0){
			applyEffects(ftr, ["recharge"], ftr);
		}
	}
	if (final){
		endTeamTurn(ftr);
	}
}

applyEffects = function(ftr, spEffs, tar){
	var effData = global.data.effects;
	for (var i = 0; i < array_length(spEffs); ++i){
		if (variable_struct_exists(effData[$"buffs"], spEffs[i])){
			var buff = variable_clone(struct_get(effData[$"buffs"], spEffs[i]));
			if (DEBUG_ENABLED) serverLog("[BController] Retrieved Buff: " + string(struct_get(effData[$"buffs"], spEffs[i])) + " : " + spEffs[i]);
			if(scrCheckEffects(tar[$"buffs"], buff)){
				array_delete(tar[$"buffs"], array_get_index(tar[$"buffs"], buff), 1);
			}
			buff.duration *= fps;
			array_push(tar[$"buffs"], buff);
			if (DEBUG_ENABLED) serverLog("[BController] Applied Buff: " + spEffs[i]);
		} else if (variable_struct_exists(effData[$"debuffs"], spEffs[i])){
			var debuff = variable_clone(struct_get(effData[$"debuffs"], spEffs[i]));
			if(scrCheckEffects(tar[$"debuffs"], debuff)){
				array_delete(tar[$"debuffs"], array_get_index(tar[$"debuffs"], debuff), 1);
			}
			debuff.duration *= fps;
			debuff.source = ftr;
			array_push(tar[$"debuffs"], debuff);
		}
	}
	var data = {
		tar : tar
	}
	scrSendAllSock(method(data, function(socket){
		scrNBUpdateChar(socket, tar);
	}));
}

doItem = function(ftr, item, tar, team, final){
	if (DEBUG_ENABLED) serverLog("[BController] " + string(ftr[$"name"]) + " uses " + item[$"name"] + " on " + tar[$"name"]);
	if(item[$"abil"] == "heal"){
		doHeal(ftr, tar, item);
	} else if(item[$"abil"] == "restore"){
		doRestore(ftr, tar, item);
	}
	if (array_length(item[$"effects"])){
		var itEffs = item[$"effects"];
		applyEffects(ftr, itEffs, tar);
	}
	if (final){
		endTeamTurn(ftr);
	}
	if(--item[$"quantity"] <= 0){
		array_delete(battleInfo.inventory, scrGetEffect(battleInfo.inventory, item), 1);	
	}
}

doMiss = function(ftr, final){
	if (final){
		endTeamTurn(ftr);
	}
}

endBattle = function(){
	serverLog("Battle Over!");
	with(objNetBattleTeamManager){
		battleOver = true;	
	}
	instance_destroy(id);
}

doDamage = function(ftr, target, action, str = 1){
	if (DEBUG_ENABLED) serverLog("[BController] " + string(ftr[$"stats"]) + " : " + action[$"scale"]);
	var dmgMult = ceil(struct_get(ftr[$"stats"], action[$"scale"])/5);
	var resistMult = 1.0;
	var tarResMult = struct_get(target[$"resistances"], action[$"scale"]);
	var bonusMult = 0.0;
	if (struct_exists(target, "buffs") && struct_exists(target, "debuffs")){
		if (array_length(target[$"buffs"]) > 0){
			for (var i = 0; i < array_length(target[$"buffs"]); ++i){
				var buffData = target[$"buffs"][i];
				if (struct_exists(buffData, "abil") && struct_exists(buffData, "pow") && struct_exists(buffData, "type")){
					if (buffData[$"abil"] == "resist"){
						if (buffData[$"type"] == action[$"scale"]){
							bonusMult += buffData[$"pow"];
						}
					}
				} else {
					if (DEBUG_ENABLED) serverLog("[BController] Error: Malformed Buff Struct!");	
				}
			}
		}
		if (array_length(target[$"debuffs"]) > 0){
			for (var i = 0; i < array_length(target[$"debuffs"]); ++i){
				var debuffData = target[$"debuffs"][i];
				if (struct_exists(debuffData, "abil") && struct_exists(debuffData, "pow") && struct_exists(debuffData, "type")){
					if (debuffData[$"abil"] == "weakness"){
						if (debuffData[$"type"] == action[$"scale"]){
							bonusMult -= debuffData[$"pow"];
						}
					}
				} else {
					if (DEBUG_ENABLED) serverLog("[BController] Error: Malformed Debuff Struct!");	
				}
			}
		}
	}
	resistMult = 1.0 - (tarResMult + bonusMult);
	if (DEBUG_ENABLED) serverLog("[BController] " +string(action[$"damage"]) + " : " + string(dmgMult) + " : " + string(resistMult) + " : " + string(action));
	var dmg = 0;
	if(struct_exists(action, "damage")){
		dmg = ceil((action[$"damage"] * dmgMult) * (resistMult) * str);
	} else if (struct_exists(action, "pow")){
		dmg = ceil((action[$"pow"] * dmgMult) * (resistMult) * str);
	}
	target.hp -= dmg;
	
	var data = {
		tar : target
	}
	
	scrSendAllSock(method(data, function(socket){
		scrNBUpdateChar(socket, tar);
	}));
	
	if (DEBUG_ENABLED) serverLog("[BController]" + string(target[$"name"]) + " takes " + string(dmg) + "damage.");
	var tarTeam = battleInfo.team1;
	if (scrCheckTeam(battleInfo.team2, target)){
		tarTeam = battleInfo.team2;	
	}
	if (target.hp <= 0){
		doDowned(ftr, target, tarTeam);
	}
	if(DEBUG_ENABLED) serverLog("[BController] Enemy Team Remaining post death: " + string(array_length(battleInfo.team2)));
}

doDeath = function(ftr, target, team){
	var tarInd = 0;
	if (team == battleInfo.team1){
		tarInd = scrTeamCharGetInd(battleInfo.team1, target);
		if (DEBUG_ENABLED) serverLog("[BController] Target: " + string(target) + string(team[tarInd]));
		audio_play_sound(sndDowned, 1, false);
		array_delete(battleInfo.team1, tarInd, 1);
		teams[0].charDied(target);
		context.menu.chooseTarget(battleInfo.tarteam);
	} else {
		tarInd = scrTeamCharGetInd(battleInfo.team2, target);
		if (DEBUG_ENABLED) serverLog("[BController] Target: " + string(target) + string(team[tarInd]));
		if (DEBUG_ENABLED) serverLog("[BController] Enemy team before death: " + string(battleInfo.team2));
		array_delete(battleInfo.team2, tarInd, 1);
		teams[1].charDied(target);
		audio_play_sound(sndMonsterDeath, 1, false);
		if (DEBUG_ENABLED) serverLog("[BController] Enemy team after death: " + string(battleInfo.team2));
	}
	context.menu.charDied(target);
	if (target == ftr || target == context.menu.fighter){
		endTeamTurn(target);
	}
	if (DEBUG_ENABLED) serverLog("[BController]" + string(target[$"name"]) + " is dead.");
}

doDowned = function(ftr, target, team){
	if (target == ftr  || target.cid == teams[0].fighter.cid || target.cid == teams[1].fighter.cid){
		endTeamTurn(target);
	}
	array_delete(team, array_get_index(team, target), 1);
	audio_play_sound(sndDowned, 1, false);
	var tarManager = teams[0];
	if (team == battleInfo.team2){
		tarManager = teams[1];	
	}
	tarManager.charDowned(target);
	if (DEBUG_ENABLED) serverLog("[BController] " + string(target[$"name"]) + " is down.");
	for(var i = 0; i < array_length(battleInfo.team1); ++i){
		serverLog("Alive: " + battleInfo.team1[i].name);
	}
	for(var i = 0; i < array_length(battleInfo.team2); ++i){
		serverLog("Alive: " + battleInfo.team2[i].name);
	}
}

doHeal = function(ftr, target, act){
	var heal = 0;
	if (struct_exists(act, "heal")){	//If is a spell
		heal = act[$"heal"] * (struct_get(ftr[$"stats"], act[$"scale"]) div 2);
	} else {		// If is an item
		heal = act[$"pow"];
	}
	target.hp = min(target.stats.maxhp, target.hp + heal);
	var data = {
		tar : target	
	}
	scrSendAllSock(method(data, function(socket){
		scrNBUpdateChar(socket, tar);
	}));
	if (DEBUG_ENABLED) serverLog("[BController] " + string(target[$"name"]) + " heals " + string(heal) + "hp.");
}

doRestore = function(ftr, target, act){
	var res = act[$"pow"];
	target.mana = min(target.stats.maxmana, target.mana + res);
	var data = {
		tar : target	
	}
	scrSendAllSock(method(data, function(socket){
		scrNBUpdateChar(socket, tar);
	}));
	if (DEBUG_ENABLED) serverLog("[BController] " + string(target[$"name"]) + " regained " + string(res) + "mana.");
}

doBuff = function(ftr, bff, ind){
	var earlyTurnEnd = false;
	if (struct_exists(bData, bff)){
		var buff = struct_get(bData, bff);
		if (DEBUG_ENABLED) serverLog("[BController]" + string(buff));
		if (struct_exists(buff, "abil")){
			if (buff[$"abil"] == "meditate"){
				doRestore(ftr, ftr, buff);
				earlyTurnEnd = true;
			}
		}
		if(--buff[$"duration"] <= 0){
			array_delete(ftr[$"buffs"], ind, 1);	
		}
		if(earlyTurnEnd){
			if (DEBUG_ENABLED) serverLog("[BController] Aborting turn");
			//menu.turnEnd();
			endTeamTurn(ftr);
		}
		var data = {
			ftr : ftr	
		}
		scrSendAllSock(method(data, function(socket){
			scrNBUpdateChar(socket, ftr);
		}));
	} else {
		if (DEBUG_ENABLED) serverLog("[BController] Error loading Debuffs!");	
	}
}

doDebuff = function(ftr, db, ind){
	var earlyTurnEnd = false;
	if (struct_exists(dbData, db)){
		var debuff = struct_get(dbData, db);
		if (struct_exists(debuff, "abil")){
			if (debuff[$"abil"] == "damage"){
				doDamage(ftr, ftr, debuff);
			}
		}
		if(--debuff[$"duration"] <= 0){
			array_delete(ftr[$"debuffs"], ind, 1);	
		}
		if(earlyTurnEnd){
			endTeamTurn(ftr);
		}
		var data = {
			ftr : ftr	
		}
		scrSendAllSock(method(data, function(socket){
			scrNBUpdateChar(socket, ftr);
		}));
	} else {
		if (DEBUG_ENABLED) serverLog("[BController] Error loading Debuffs!");	
	}
}

doNetAction = function(actInfo){
	
	//actionInfo = {
	//	act : action,
	//	actor : actor,
	//	tar : target,
	//	team : team,
	//	isSpell : isSpell,
	//	isItem : isItem,
	//	actorChar : actors[charGetActorInd(actor)],
	//	targetChar : actors[charGetActorInd(target)]
	//};
	var player = actInfo.player;
	
	serverLog(string(player));
	serverLog(string(actInfo));
	
	var actorTeam = battleInfo.team1;
	if (scrCheckTeam(battleInfo.team2, actInfo.actor)){
		actorTeam = battleInfo.team2;	
	}
	
	var charInd = scrTeamCharGetInd(actorTeam, actInfo.actor);
	var fighter = actorTeam[charInd];
	
	var targetTeam = battleInfo.team2;
	if (scrCheckTeam(battleInfo.team1, actInfo.target)){
		targetTeam = battleInfo.team1;	
	}
	charInd = scrTeamCharGetInd(targetTeam, actInfo.target);
	var target = targetTeam[charInd];
	
	if(!actInfo.isItem){
		if (actInfo.isSpell){
			var spell = struct_get(splData, actInfo.action);
			if(struct_exists(fighter, "mana")){
				fighter[$"mana"] -= spell[$"cost"];
			}
			if(struct_exists(fighter, "energy")){
				fighter[$"energy"] -= spell[$"cost"];
			}
		}
		//context.qteHandler.loadQTE(actor, target, action, team, isSpell, actionInfo);
		var data = {
			ftr : fighter	
		}
		
		scrSendAllSock(method(data, function(socket){
			scrNBUpdateChar(socket, ftr);
		}));
		scrStartQTE(player.sockId);
	} else {
		//doItem(actor, action, target, team, true);
	}
}


initBattle();

