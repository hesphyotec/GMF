if (DEBUG_ENABLED) show_debug_message("[BController] Create event start");
turn = 0;
isNetBattle = global.isPlayerBattle;
battleInfo = {
	menuState		: BMENUST.ACTION,
	isPlayerTurn	: false,
	team1			: [],
	team2			: [],
	inventory		: global.playerData[0][$"inventory"],
	tarteam			: undefined,
	waiting			: []
};

teams = [instance_create_layer(0,0,"Menu", objBattleTeamManager), instance_create_layer(0,0,"Menu", objBattleTeamManager)];

context = {
	controller	: id,
	menu		: instance_create_layer(0,0, "Menu", objBattleMenu),
	playerTeam	: teams[0],
	qteHandler	: instance_create_layer(0, 0, "Menu", objQteHandler)
}
activeTurn = 0;
//isPlayerTurn = false;
diedMidTurn = false;
//activeFighter = {stats:{},buffs:[],debuffs:[]};
x = room_width / 2;
y = room_height / 2;

outcome = {};

random_set_seed(current_time);


context.menu.battleInfo = battleInfo;
context.menu.context = context;
context.menu.menuBox.battleInfo = battleInfo;
context.menu.menuBox.context = context;
context.qteHandler.context = context;
context.qteHandler.battleInfo = battleInfo;

enemyData = global.data.enemies;
atkData = global.data.moves[$"attacks"];
splData = global.data.moves[$"spells"];
itemData = global.data.items;
bData = global.data.effects[$"buffs"];
dbData = global.data.effects[$"debuffs"];



initBattle = function(){
	if (DEBUG_ENABLED) show_debug_message("Starting Battle");
	show_debug_message(array_length(global.battles));
	if (array_length(global.battles) <= 0) {
	    if (DEBUG_ENABLED) show_debug_message("No battles queued!");
	    return;
	}
	
	var playerTeam = global.battles[0][0];
	var enemy = global.battles[0][1];
	array_delete(global.battles, 0, 1);
	
	battleInfo.team1 = playerTeam;
	if(!global.isPlayerBattle){
		loadEncounter(enemy);
	} else {
		battleInfo.team2 = enemy;	
	}

	context.menu.loadCharacters();
	
	teams[0].loadTeam(battleInfo.team1);
	teams[0].playerTeam = true;
	teams[0].context = context;
	teams[0].battleInfo = battleInfo;
	
	teams[1].loadTeam(battleInfo.team2);
	teams[1].context = context;
	teams[1].battleInfo = battleInfo;
	
	for(var i = 0; i < array_length(teams); ++i){
		teams[i].startTurn();
	}
	//audio_play_sound(sndEggyBreakIn, 1, true);
}

endTeamTurn = function(ftr){
	if (DEBUG_ENABLED) show_debug_message("[BController] " + string(ftr) + " : " + string(battleInfo.team1));
	if(scrCheckTeam(battleInfo.team1, ftr)){
		if (DEBUG_ENABLED) show_debug_message("[BController] Ending turn for team 1");
		teams[0].endTurn();
	} else if(scrCheckTeam(battleInfo.team2, ftr)) {
		if (DEBUG_ENABLED) show_debug_message("[BController] Ending turn for team 2");
		teams[1].endTurn();
	}	
}

loadEnemy = function(enemy){
	if (struct_exists(enemyData, enemy)){
		var foe = variable_clone(struct_get(enemyData, enemy));
		if (DEBUG_ENABLED) show_debug_message("[BController] Loaded Enemy: " + string(foe));
		return foe;
	} else {
		if (DEBUG_ENABLED) show_message("[BController] Error Loading Enemy!");	
	}
}

loadEncounter = function(encounter){
	if (DEBUG_ENABLED) show_debug_message("[BController] Loading encounter id: " + string(encounter));
	var enData = struct_get(global.data.encounters, encounter);
	var foes = variable_clone(enData.foes);
	outcome = enData.outcome;
	objBattleBox.background = asset_get_index(enData.background);
	for (var i = 0; i < array_length(foes); ++i){
		var foe = loadEnemy(foes[i]);
		foe.cid = i + 128;
		array_push(battleInfo.team2,foe);
	}
}

doAttack = function(ftr, atk, tar, team, str, final){
	if (DEBUG_ENABLED) show_debug_message("[BController] " + string(ftr[$"name"]) + " is attacking.");
	if (global.isPlayerBattle){
		//scrNBAttack(ftr.id, atk, tar.id, self?, str, final);	
	} else {
		if (struct_exists(atkData, atk)){
			var attack = struct_get(atkData, atk);
			if (DEBUG_ENABLED) show_debug_message("[BController] Retrieved Attack: " + string(atk) + " : " + string(attack));
			doDamage(ftr, tar, attack, str);
		} else {
			if (DEBUG_ENABLED) show_message("[BController] Error loading attack!");	
		}
		if(final){
			endTeamTurn(ftr);
		}
	}
}
	
doSpell = function(ftr, spl, tar, team, str, final){
	if (DEBUG_ENABLED) show_debug_message("[BController] " + string(ftr[$"name"]) + " is using a spell.");
	if (global.isPlayerBattle){
		//scrNBSpell(ftr.id, spl, tar.id, self?, str, final);		
	} else {
		if (struct_exists(splData, spl)){
			var spell = struct_get(splData, spl);
			if (DEBUG_ENABLED) show_debug_message("[BController] Retrieved Spell: " + string(spl) + " : " + string(spell));
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
			if (DEBUG_ENABLED) show_message("[BController] Error loading spell!");	
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
}

applyEffects = function(ftr, spEffs, tar){
	conAppEffects(ftr, spEffs, tar);
}

doItem = function(ftr, item, tar, team, final){
	if (DEBUG_ENABLED) show_debug_message("[BController] " + string(ftr[$"name"]) + " uses " + item[$"name"] + " on " + tar[$"name"]);
	if(global.isPlayerBattle){
		//scrNBItem(ftr.id, item, tar.id, self?, final);		
	} else {
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
}

doMiss = function(ftr, target, final){
	scrNBQTEMiss(global.server, ftr, final);
	var actor = context.menu.getActor(target);
	createMissText(actor, target);
	if (final){
		endTeamTurn(ftr);
	}
}

endBattle = function(victory){
	if (victory) {
		if (outcome.op == "normal"){
			//give exp and gold
			room_goto(global.lastRoom);
		} else if (outcome.op == "gotoRoom"){
			room_goto(asset_get_index(outcome.dest));	
		}
	} else {
		show_message("You lost!");
		room_goto(global.lastRoom);
	}
	audio_stop_all();
	//room_goto(rmHCastleTest);
}

doDamage = function(ftr, target, action, str = 1){
	var dmg = calcDamage(ftr, target, action, str);
	target.hp -= dmg;
	
	var actor = context.menu.getActor(target);
	createDamageNumber(actor, target, dmg);
	addShaderEffect(new effFlash(1, c_red, .2), actor);
	addShaderEffect(new effShake(10, 0, .2), actor);
	if (DEBUG_ENABLED) show_debug_message("[BController]" + string(target[$"name"]) + " takes " + string(dmg) + "damage.");
	var isPlayer = array_contains(battleInfo.team1, target);
	if(DEBUG_ENABLED) show_debug_message("[BController] Enemy Team Remaining pre death: " + string(array_length(battleInfo.team2)));
	if (target.hp <= 0){
		if (!isPlayer){
			doDeath(ftr, target, battleInfo.team2);
		} else {
			doDowned(ftr, target, battleInfo.team1);
		}
	}
	if(DEBUG_ENABLED) show_debug_message("[BController] Enemy Team Remaining post death: " + string(array_length(battleInfo.team2)));
}

doDeath = function(ftr, target, team){
	var tarInd = 0;
	if (team == battleInfo.team1){
		tarInd = scrTeamCharGetInd(battleInfo.team1, target);
		if (DEBUG_ENABLED) show_debug_message("[BController] Target: " + string(target) + string(team[tarInd]));
		audio_play_sound(sndDowned, 1, false);
		array_delete(battleInfo.team1, tarInd, 1);
		teams[0].charDied(target);
		if(battleInfo.menuState == BMENUST.TARGET && tarteam == team){
			context.menu.chooseTarget(battleInfo.tarteam);
		}
	} else {
		tarInd = scrTeamCharGetInd(battleInfo.team2, target);
		if (DEBUG_ENABLED) show_debug_message("[BController] Target: " + string(target) + string(team[tarInd]));
		if (DEBUG_ENABLED) show_debug_message("[BController] Enemy team before death: " + string(battleInfo.team2));
		array_delete(battleInfo.team2, tarInd, 1);
		teams[1].charDied(target);
		audio_play_sound(sndMonsterDeath, 1, false);
		if (DEBUG_ENABLED) show_debug_message("[BController] Enemy team after death: " + string(battleInfo.team2));
	}
	context.menu.charDied(target);
	if (target == ftr || target == context.menu.fighter){
		endTeamTurn(target);
	}
	if (DEBUG_ENABLED) show_debug_message("[BController]" + string(target[$"name"]) + " is dead.");
}

doDowned = function(ftr, target, team){
	array_delete(team, array_get_index(team, target), 1);
	audio_play_sound(sndDowned, 1, false);
	teams[0].charDowned(target);
	if (target == ftr || target = context.menu.fighter){
		endTeamTurn(target);
	}
	if(battleInfo.menuState == BMENUST.TARGET && tarteam == team){
		context.menu.chooseTarget(battleInfo.tarteam);
	}
	if (DEBUG_ENABLED) show_debug_message("[BController] " + string(target[$"name"]) + " is down.");
}

doNetDowned = function(ftr){
	if(teams[0].fighter != undefined){
		if (ftr.cid == teams[0].fighter.cid){
			clientLog("Aborting turn for: " + ftr.name);
			endTeamTurn(ftr);
		}
	}
	var team = battleInfo.team1;
	var tarManager = teams[0];
	if (scrCheckTeam(battleInfo.team2, ftr)){
		team = battleInfo.team2;
		tarManager = teams[1];
	}
	var realFtr = team[scrTeamCharGetInd(team, ftr)];
	array_delete(team, scrTeamCharGetInd(team, ftr), 1);
	audio_play_sound(sndDowned, 1, false);
	tarManager.charDowned(realFtr);
	if(battleInfo.menuState == BMENUST.TARGET && tarteam == team){
		context.menu.chooseTarget(battleInfo.tarteam);
	}
	for(var i = 0; i < array_length(battleInfo.team1); ++i){
		clientLog("Alive: " + battleInfo.team1[i].name);
	}
	for(var i = 0; i < array_length(battleInfo.team2); ++i){
		clientLog("Alive: " + battleInfo.team2[i].name);
	}
}

doHeal = function(ftr, target, act){
	var newHp = calcHeal(ftr, target, act);
	var change = newHp - target.hp;
	target.hp = newHp
	var actor = context.menu.getActor(target);
	createRestoreNumber(actor, target, change, c_lime);
	addShaderEffect(new effFlash(1, c_lime, .1), actor);
	//if (DEBUG_ENABLED) show_debug_message("[BController] " + string(target[$"name"]) + " heals " + string(heal) + "hp.");
}

doRestore = function(ftr, target, act){
	var res = act[$"pow"];
	var actor = context.menu.getActor(target);
	if (struct_exists(target, "mana")){
		target.mana = min(target.stats.maxmana, target.mana + res);
		createRestoreNumber(actor, target, res, c_aqua);
		addShaderEffect(new effFlash(1, c_aqua, .1), actor);
	} else if (struct_exists(target, "blood")){
		target.blood = min(target.stats.maxblood, target.blood + res);
		createRestoreNumber(actor, target, res, c_purple);
		addShaderEffect(new effFlash(1, c_purple, .1), actor);
	} else if (struct_exists(target, "rage")){
		target.rage = min(target.stats.maxrage, target.rage + res);
		createRestoreNumber(actor, target, res, c_orange);
		addShaderEffect(new effFlash(1, c_orange, .1), actor);
	} else if (struct_exists(target, "energy")){
		target.energy = min(target.stats.maxenergy, target.energy + res);
		createRestoreNumber(actor, target, res, c_yellow);
		addShaderEffect(new effFlash(1, c_yellow, .1), actor);
	}
	if (DEBUG_ENABLED) show_debug_message("[BController] " + string(target[$"name"]) + " regained " + string(res) + " resource.");
}

doBuff = function(ftr, bff, ind){
	var earlyTurnEnd = false;
	if (struct_exists(bData, bff)){
		var buff = struct_get(bData, bff);
		if (DEBUG_ENABLED) show_debug_message("[BController]" + string(buff));
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
			if (DEBUG_ENABLED) show_debug_message("[BController] Aborting turn");
			//menu.turnEnd();
			endTeamTurn(ftr);
		}
	} else {
		if (DEBUG_ENABLED) show_message("[BController] Error loading Debuffs!");	
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
	} else {
		if (DEBUG_ENABLED) show_message("[BController] Error loading Debuffs!");	
	}
}

if (array_length(global.battles) > 0){
	initBattle();
}

netUpdateChar = function(char){
	var ftr = undefined;
	if (scrCheckTeam(battleInfo.team1, char)){
		ftr = battleInfo.team1[scrTeamCharGetInd(battleInfo.team1, char)];
	} else if (scrCheckTeam(battleInfo.team2, char)){
		ftr = battleInfo.team2[scrTeamCharGetInd(battleInfo.team2, char)];
	} else {
		clientLog("Invalid Character Data!");
		return;	
	}
	ftr.hp = char.hp;
	if (struct_exists(ftr, "mana")){
		ftr.mana = char.mana;	
	}
	if (struct_exists(ftr, "energy")){
		ftr.energy = char.energy;	
	}
	if (struct_exists(ftr, "blood")){
		ftr.blood = char.blood;	
	}
	if (struct_exists(ftr, "rage")){
		ftr.rage = char.rage;	
	}
	ftr.buffs = char.buffs;
	ftr.debuffs = char.debuffs;
}