//team1 = [];
//team2 = [];
turn = 0;
fighters = [];
battleInfo = {
	activeFighter	: undefined,
	battleState		: BSTATES.START,
	menuState		: BMENUST.ACTION,
	isPlayerTurn	: false,
	team1			: [],
	team2			: [],
	inventory		: global.playerData[0][$"inventory"]
};

activeTurn = 0;
//isPlayerTurn = false;
diedMidTurn = false;
//activeFighter = {stats:{},buffs:[],debuffs:[]};
x = room_width / 2;
y = room_height / 2;

random_set_seed(current_time);


menu = instance_create_layer(0,0, "Menu", objBattleMenu);
menu.controller = self;
menu.battleInfo = battleInfo;
menu.menuBox.battleInfo = battleInfo;

enemyData = global.data.enemies;
atkData = global.data.moves[$"attacks"];
splData = global.data.moves[$"spells"];
itemData = global.data.items;
bData = global.data.effects[$"buffs"];
dbData = global.data.effects[$"debuffs"];

//if (DEBUG_ENABLED) show_message(string(battleInfo.inventory[0][$"name"]));

initBattle = function(){
	show_debug_message("Starting Battle");
	show_debug_message(array_length(global.battles));
	if (array_length(global.battles) <= 0) {
	    show_debug_message("No battles queued!");
	    return;
	}

	var playerTeam = global.battles[0][0];
	var enemy = global.battles[0][1];
	array_delete(global.battles, 0, 1);
	
	fighters = [];
	battleInfo.team1 = playerTeam;
	loadEncounter(enemy);
	fighters = array_concat(battleInfo.team1, battleInfo.team2);
	
	for (var i = 0; i < array_length(fighters); i++) {
	    show_debug_message("Fighter " + string(i) + ": " + string(fighters[i]));
	    if (!struct_exists(fighters[i], "stats")) {
	        show_debug_message("!! Fighter missing stats struct !!");
	    }
	}
	
	array_sort(fighters, scrCompareOrder);
	show_debug_message("Fight order created: " + string(fighters));
	//menu.battleInfo.team1Chars = team1;
	//menu.team2Chars = team2;
	menu.loadCharacters();
	startTurn(fighters[0]);
}

loadEnemy = function(enemy){
	if (struct_exists(enemyData, enemy)){
		var foe = variable_clone(struct_get(enemyData, enemy));
		show_debug_message("Loaded Enemy: " + string(foe));
		return foe;
	} else {
		show_message("Error Loading Enemy!");	
	}
}

loadEncounter = function(encounter){
	show_debug_message("Loading encounter id: " + string(encounter));
	var foes = [];
	switch(encounter){
		case ENCOUNTERS.TEST:
			foes = ["enemyTest", "bigRock"];
			break;
	}
	for (var i = 0; i < array_length(foes); ++i){
		var foe = loadEnemy(foes[i]);
		array_push(battleInfo.team2,foe);
	}
}

startTurn = function(fighter){
	if(DEBUG_ENABLED) show_debug_message("Starting turn for" + string(fighter[$"name"]));
	if(DEBUG_ENABLED) show_debug_message("Current order: " + string(fighters));
	if(DEBUG_ENABLED) show_debug_message("Enemy Team Remaining: " + string(array_length(battleInfo.team2)));
	for(var i = 0; i < array_length(fighters); ++i){
		show_debug_message("Current order [" + string(i) + "]: " + string(fighters[i][$"name"]));
	}
	battleInfo.isPlayerTurn = array_contains(battleInfo.team1, fighter);
	++turn;
	battleInfo.activeFighter = fighter;
	if (battleInfo.isPlayerTurn){
		alarm[0] = TURN_LENGTH;
		menu.turnStart(battleInfo.activeFighter.attacks, battleInfo.activeFighter.spells);
		battleInfo.battleState = BSTATES.SELECT;
	} else {
		enemyTurn(battleInfo.activeFighter);
	}
	for(var i = array_length(battleInfo.activeFighter[$"buffs"]) - 1; i >=0 ; --i){
		if(array_length(battleInfo.activeFighter[$"buffs"]) > 0){
			if (DEBUG_ENABLED) show_debug_message("Buff takes effect: " + string(battleInfo.activeFighter[$"buffs"][i]));
			doBuff(battleInfo.activeFighter[$"buffs"][i], i);
		}
	}
	for(var i = array_length(battleInfo.activeFighter[$"debuffs"]) - 1; i >=0 ; --i){
		if(array_length(battleInfo.activeFighter[$"debuffs"]) > 0){
			doDebuff(battleInfo.activeFighter[$"debuffs"][i], i);
		}
	}
}

doAttack = function(atk, tar, team){
		menu.turnEnd();
		show_debug_message(string(battleInfo.activeFighter[$"name"]) + " is attacking.");
		battleInfo.battleState = BSTATES.ACTION;
		if (struct_exists(atkData, atk)){
			var attack = struct_get(atkData, atk);
			show_debug_message("Retrieved Attack: " + string(atk) + " : " + string(attack));
			doDamage(tar, attack);
		} else {
			show_message("Error loading attack!");	
		}
		if(battleInfo.battleState == BSTATES.ACTION){
			endTurn();
		}
	}
	
doSpell = function(spl, tar, team){
	menu.turnEnd();
	show_debug_message(string(battleInfo.activeFighter[$"name"]) + " is using a spell.");
	battleInfo.battleState = BSTATES.ACTION;
	if (struct_exists(splData, spl)){
		var spell = struct_get(splData, spl);
		show_debug_message("Retrieved Spell: " + string(spl) + " : " + string(spell));
		battleInfo.activeFighter[$"mana"] -= spell[$"cost"];
		if(spell[$"type"] == "dmgSpell"){
			doDamage(tar, spell);
		} else if(spell[$"type"] == "restoreSpell"){
			doHeal(tar, spell);
		}
		if (array_length(spell[$"effects"])){
			var effData = global.data.effects;
			var effect = {};
			var spEffs = spell[$"effects"];
			for (var i = 0; i < array_length(spEffs); ++i){
				if (variable_struct_exists(effData[$"buffs"], spEffs[i])){
					if (DEBUG_ENABLED) show_debug_message("Retrieved Buff: " + string(struct_get(effData[$"buffs"], spEffs[i])) + " : " + spEffs[i]);
					array_push(tar[$"buffs"], spEffs[i]);
					if (DEBUG_ENABLED) show_debug_message("Applied Buff: " + spEffs[i]);
				} else if (variable_struct_exists(effData[$"debuffs"], spEffs[i])){
					array_push(tar[$"debuffs"], spEffs[i]);
				}
			}
		}
	} else {
		show_message("Error loading spell!");	
	}
	if(battleInfo.battleState == BSTATES.ACTION){
		endTurn();
	}
}

doItem = function(item, tar, team){
	menu.turnEnd();
	show_debug_message(string(battleInfo.activeFighter[$"name"]) + " uses " + item[$"name"] + " on " + tar[$"name"]);
	battleInfo.battleState = BSTATES.ACTION;
	if(item[$"abil"] == "heal"){
		doHeal(tar, item);
	} else if(item[$"abil"] == "restore"){
		doRestore(tar, item);
	}
	if (array_length(item[$"effects"])){
		var effData = global.data.effects;
		var effect = {};
		var itEffs = item[$"effects"];
		for (var i = 0; i < array_length(itEffs); ++i){
			if (variable_struct_exists(effData[$"buffs"], itEffs[i])){
				if (DEBUG_ENABLED) show_debug_message("Retrieved Buff: " + string(struct_get(effData[$"buffs"], spEffs[i])) + " : " + spEffs[i]);
				array_push(tar[$"buffs"], itEffs[i]);
				if (DEBUG_ENABLED) show_debug_message("Applied Buff: " + itEffs[i]);
			} else if (variable_struct_exists(effData[$"debuffs"], itEffs[i])){
				array_push(tar[$"debuffs"], itEffs[i]);
			}
		}
	}
	if(battleInfo.battleState == BSTATES.ACTION){
		endTurn();
	}
}

endTurn = function(){
	if(DEBUG_ENABLED) show_debug_message("Ending Turn.");
	if(DEBUG_ENABLED) show_debug_message("[7] Enemy Team Remaining: " + string(array_length(battleInfo.team2)));
	if(array_contains(fighters, battleInfo.activeFighter)){
		var ind = array_get_index(fighters, battleInfo.activeFighter);
		array_delete(fighters, ind, 1);
		array_push(fighters, battleInfo.activeFighter);
	}
	if(DEBUG_ENABLED) show_debug_message("Enemy Team Remaining: " + string(array_length(battleInfo.team2)));
	if (array_length(battleInfo.team2) <= 0){
		endBattle(true);
		return;
	}
	var defeated = 0;
	for (var i = 0; i < array_length(battleInfo.team1); i++){
		if (battleInfo.team1[i].hp <= 0){
			defeated++;	
		}
	}
	if (defeated == array_length(battleInfo.team1)){
		endBattle(false);
		return;
	}
	startTurn(fighters[0]);
}

endBattle = function(victory){
	if (victory) {
		show_message("You won!");
		// Give gold and exp.	
	} else {
		show_message("You lost!");
		// Send back to last town	
	}
	room_goto(rmTest);
}

doDamage = function(target, action){
	if (DEBUG_ENABLED) show_debug_message(string(battleInfo.activeFighter[$"stats"]) + " : " + action[$"scale"]);
	var dmgMult = ceil(struct_get(battleInfo.activeFighter[$"stats"], action[$"scale"]) / 2);
	var resistMult = 1.0;
	var tarResMult = struct_get(target[$"resistances"], action[$"scale"]);
	var bonusMult = 0.0;
	if (struct_exists(target, "buffs") && struct_exists(target, "debuffs")){
		if (array_length(target[$"buffs"]) > 0){
			for (var i = 0; i < array_length(target[$"buffs"]); ++i){
				var buff = target[$"buffs"][i];
				var buffData = struct_get(bData, buff);
				if (struct_exists(buffData, "abil") && struct_exists(buffData, "pow") && struct_exists(buffData, "type")){
					if (buffData[$"abil"] == "resist"){
						if (buffData[$"type"] == action[$"scale"]){
							bonusMult += buffData[$"pow"];
						}
					}
				} else {
					show_debug_message("Error: Malformed Buff Struct!");	
				}
			}
		}
		if (array_length(target[$"debuffs"]) > 0){
			for (var i = 0; i < array_length(target[$"debuffs"]); ++i){
				var debuff = target[$"debuffs"][i];
				var debuffData = struct_get(dbData, debuff);
				if (struct_exists(debuffData, "abil") && struct_exists(debuffData, "pow") && struct_exists(debuffData, "type")){
					if (debuffData[$"abil"] == "weakness"){
						if (debuffData[$"type"] == action[$"scale"]){
							bonusMult -= debuffData[$"pow"];
						}
					}
				} else {
					show_debug_message("Error: Malformed Debuff Struct!");	
				}
			}
		}
	}
	resistMult = 1.0 - (tarResMult + bonusMult);
	if (DEBUG_ENABLED) show_debug_message(string(action[$"damage"]) + " : " + string(dmgMult) + " : " + string(resistMult) + " : " + string(action));
	var dmg = 0;
	if(struct_exists(action, "damage")){
		dmg = ceil((action[$"damage"] * dmgMult) * (resistMult));
	} else if (struct_exists(action, "pow")){
		dmg = ceil((action[$"pow"] * dmgMult) * (resistMult));
	}
	target.hp -= dmg;
	show_debug_message(string(target[$"name"]) + " takes " + string(dmg) + "damage.");
	var isPlayer = array_contains(battleInfo.team1, target);
	if(DEBUG_ENABLED) show_debug_message("[1] Enemy Team Remaining: " + string(array_length(battleInfo.team2)));
	if (target.hp <= 0){
		if (!isPlayer){
			doDeath(target, battleInfo.team2);
		} else {
			doDowned(target, battleInfo.team1);
		}
		array_delete(fighters, array_get_index(fighters, target), 1);
	}
	if(DEBUG_ENABLED) show_debug_message("[6] Enemy Team Remaining: " + string(array_length(battleInfo.team2)));
}

doDeath = function(target, team){
	var tarInd = 0;
	if (team == battleInfo.team1){
		tarInd = array_get_index(battleInfo.team1, target);
		if (DEBUG_ENABLED) show_debug_message("Target: " + string(target) + string(team[tarInd]));
		audio_play_sound(sndDowned, 1, false);
		array_delete(battleInfo.team1, tarInd, 1);
	} else {
		tarInd = array_get_index(battleInfo.team2, target);
		if (DEBUG_ENABLED) show_debug_message("Target: " + string(target) + string(team[tarInd]));
		if (DEBUG_ENABLED) show_debug_message("Enemy team before death: " + string(battleInfo.team2));
		array_delete(battleInfo.team2, tarInd, 1);
		audio_play_sound(sndMonsterDeath, 1, false);
		if (DEBUG_ENABLED) show_debug_message("Enemy team after death: " + string(battleInfo.team2));
	}
	menu.charDied();
	if (target == battleInfo.activeFighter){
		menu.turnEnd();
		endTurn();
	}
	show_debug_message(string(target[$"name"]) + " is dead.");
}

doDowned = function(target, team){
	array_delete(team, array_get_index(team, target), 1);
	audio_play_sound(sndDowned, 1, false);
	//menu.charDowned(target, team);
	if (target == battleInfo.activeFighter){
		menu.turnEnd();
		endTurn();
	}
	show_debug_message(string(target[$"name"]) + " is down.");
}

doHeal = function(target, act){
	var heal = 0;
	if (struct_exists(act, "heal")){	//If is a spell
		heal = act[$"heal"] * (struct_get(battleInfo.activeFighter[$"stats"], act[$"scale"]) div 2);
	} else {		// If is an item
		heal = act[$"pow"];
	}
	target.hp = min(target.stats.maxhp, target.hp + heal);
	show_debug_message(string(target[$"name"]) + " heals " + string(heal) + "hp.");
}

doRestore = function(target, act){
	var res = act[$"pow"];
	target.mana = min(target.stats.maxmana, target.mana + res);
	show_debug_message(string(target[$"name"]) + " regained " + string(res) + "mana.");
}

doBuff = function(bff, ind){
	var earlyTurnEnd = false;
	if (struct_exists(bData, bff)){
		var buff = struct_get(bData, bff);
		if (DEBUG_ENABLED) show_debug_message(string(buff));
		if (struct_exists(buff, "abil")){
			if (buff[$"abil"] == "meditate"){
				doRestore(battleInfo.activeFighter, buff);
				earlyTurnEnd = true;
			}
		}
		if(--buff[$"duration"] <= 0){
			array_delete(battleInfo.activeFighter[$"buffs"], ind, 1);	
		}
		if(earlyTurnEnd){
			if (DEBUG_ENABLED) show_debug_message("Aborting turn");
			menu.turnEnd();
			endTurn();
		}
	} else {
		show_message("Error loading Debuffs!");	
	}
}
doDebuff = function(db, ind){
	var earlyTurnEnd = false;
	if (struct_exists(dbData, db)){
		var debuff = struct_get(dbData, db);
		if (struct_exists(debuff, "abil")){
			if (debuff[$"abil"] == "damage"){
				doDamage(battleInfo.activeFighter, debuff);
			}
		}
		if(--debuff[$"duration"] <= 0){
			array_delete(battleInfo.activeFighter[$"debuffs"], ind, 1);	
		}
		if(earlyTurnEnd){
			menu.turnEnd();
			endTurn();
		}
	} else {
		show_message("Error loading Debuffs!");	
	}
}
if (array_length(global.battles) > 0){
	initBattle();
}

enemyTurn = function(enemy){
	var actions = array_concat(enemy[$"attacks"], enemy[$"spells"]);
	var choice = -1;
	var action = "";
	if (array_length(actions) > 0){
		choice = irandom(array_length(actions) - 1);
		action = actions[choice];
	} else {
		// UH WTF ERROR?????	
		show_message("No actions loaded!");
	}
	
	battleInfo.battleState = BSTATES.ACTION;
	if(DEBUG_ENABLED) show_debug_message("Animations waiting at enemy turn: " + string(objBattleMenu.animsWaiting));
	
	if (struct_exists(atkData, action)){
		var tIndex = irandom(array_length(battleInfo.team1) - 1);
		var target = battleInfo.team1[tIndex];
		menu.doAnimation(action, enemy, target, battleInfo.team1, false);
	} else if (struct_exists(splData, action)){
		if (struct_exists(struct_get(splData, action), "damage")){
			var tIndex = irandom(array_length(battleInfo.team1) - 1);
			var target = battleInfo.team1[tIndex];
			menu.doAnimation(action, enemy, target, battleInfo.team1, true);
		}
		if (struct_exists(struct_get(splData, action), "heal")){
			var tIndex = irandom(array_length(battleInfo.team2) - 1);
			var target = battleInfo.team2[tIndex];
			menu.doAnimation(action, enemy, target, battleInfo.team2, true);
		}
	}
	
}