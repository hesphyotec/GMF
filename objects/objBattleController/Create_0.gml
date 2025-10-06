turn = 0;
order = [];
team1 = [];
team2 = [];
fighters = [];
battleState = BSTATES.START;
activeTurn = 0;
isPlayerTurn = false;
diedMidTurn = false;
activeFighter = {stats:{},buffs:[],debuffs:[]};
x = room_width / 2;
y = room_height / 2; 


menu = instance_create_layer(0,0, "Instances", objBattleMenu);

enemyData = global.data.enemies;

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
	team1 = playerTeam;
	loadEncounter(enemy);
	fighters = array_concat(team1, team2);
	
	for (var i = 0; i < array_length(fighters); i++) {
	    show_debug_message("Fighter " + string(i) + ": " + string(fighters[i]));
	    if (!variable_struct_exists(fighters[i], "stats")) {
	        show_debug_message("!! Fighter missing stats struct !!");
	    }
	}
	
	array_sort(fighters, scrCompareOrder);
	show_debug_message("Fight order created: " + string(fighters));
	menu.team1Chars = team1;
	menu.team2Chars = team2;
	menu.loadCharacters();
	startTurn(fighters[0]);
}

loadEnemy = function(enemy){
	var foeData = variable_clone(struct_get(enemyData, enemy));
	var foe = {
		name	: foeData[$"name"],
		hp		: foeData[$"hp"],
		mana	: foeData[$"mana"],
		stats	: foeData[$"stats"],
		attacks : foeData[$"attacks"],
		spells	: foeData[$"spells"],
		buffs	: [],
		debuffs : [],
		sprite	: foeData[$"sprite"]
	}
	show_debug_message("Loaded Enemy: " + string(foe));
	return foe;
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
		array_push(team2,foe);
	}
}

startTurn = function(fighter){
	show_debug_message("Starting turn for" + string(fighter[$"name"]));
	show_debug_message("Current order: " + string(fighters));
	for(var i = 0; i < array_length(fighters); ++i){
		show_debug_message("Current order [" + string(i) + "]: " + string(fighters[i][$"name"]));
	}
	isPlayerTurn = array_contains(team1, fighter);
	++turn;
	activeFighter = fighter;
	if (isPlayerTurn){
		alarm[0] = TURN_LENGTH;
		menu.turnStart(fighter, fighter.attacks, fighter.spells);
		battleState = BSTATES.SELECT;
	} else {
		enemyTurn(fighter);
	}
	for(var i = array_length(activeFighter[$"buffs"]) - 1; i >=0 ; --i){
		doBuff(activeFighter[$"buffs"][i], i);
	}
	for(var i = array_length(activeFighter[$"debuffs"]) - 1; i >=0 ; --i){
		doDebuff(activeFighter[$"debuffs"][i], i);
	}
}

doAttack = function(atk, tar, team){
		menu.turnEnd();
		show_debug_message(string(activeFighter[$"name"]) + " is attacking.");
		battleState = BSTATES.ACTION;
		var attack = struct_get(global.data.moves[$"attacks"], atk);
		show_debug_message("Retrieved Attack: " + string(atk) + " : " + string(attack));
		var dmg  = attack[$"damage"] * (struct_get(activeFighter[$"stats"], attack[$"scale"]) div 2);
		doDamage(tar, dmg);
		if(battleState == BSTATES.ACTION){
			endTurn();
		}
	}
	
doSpell = function(spl, tar, team){
		menu.turnEnd();
		show_debug_message(string(activeFighter[$"name"]) + " is using a spell.");
		battleState = BSTATES.ACTION;
		var spell = struct_get(global.data.moves[$"spells"], spl);
		show_debug_message("Retrieved Spell: " + string(spl) + " : " + string(spell));
		activeFighter[$"mana"] -= spell[$"cost"];
		if(spell[$"damage"]){
			var dmg  = spell[$"damage"] * (struct_get(activeFighter[$"stats"], spell[$"scale"]) div 2);
			doDamage(tar, dmg);
		} else if(spell[$"heal"]){
			var heal = spell[$"heal"] * (struct_get(activeFighter[$"stats"], spell[$"scale"]) div 2);
			doHeal(tar, heal);
		}
		if (array_length(spell[$"effects"])){
			var effData = global.data.effects;
			var effect = {};
			var spEffs = spell[$"effects"];
			for (var i = 0; i < array_length(spEffs); ++i){
				if (variable_struct_exists(effData[$"buffs"], spEffs[i])){
					array_push(tar[$"buffs"], spEffs[i]);
				} else if (variable_struct_exists(effData[$"debuffs"], spEffs[i])){
					array_push(tar[$"debuffs"], spEffs[i]);
				}
			}
		}
		if(battleState == BSTATES.ACTION){
			endTurn();
		}
	}
	
endTurn = function(){
	show_debug_message("Ending Turn.");
	if(array_contains(fighters, activeFighter)){
		var ind = array_get_index(fighters, activeFighter);
		array_delete(fighters, ind, 1);
		array_push(fighters, activeFighter);
	}
	if (array_length(team2) <= 0){
		endBattle(true);
		return;
	}
	var defeated = 0;
	for (var i = 0; i < array_length(team1); i++){
		if (team1[i].hp <= 0){
			defeated++;	
		}
	}
	if (defeated == array_length(team1)){
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

doDamage = function(target, dmg){
	target.hp -= dmg;
	show_debug_message(string(target[$"name"]) + " takes " + string(dmg) + "damage.");
	var isPlayer = array_contains(team1, target);
	if (target.hp <= 0){
		if (!isPlayer){
			doDeath(target, team2);
		} else {
			doDowned(target, team1);
		}
		array_delete(fighters, array_get_index(fighters, target), 1);
	}
}

doDeath = function(target, team){
	array_delete(team, array_get_index(team, target), 1);
	menu.charDied(target, team);
	if (target == activeFighter){
		menu.turnEnd();
		endTurn();
	}
	show_debug_message(string(target[$"name"]) + " is dead.");
}

doDowned = function(target, team){
	array_delete(team, array_get_index(team, target), 1);
	//menu.charDowned(target, team);
	if (target == activeFighter){
		menu.turnEnd();
		endTurn();
	}
	show_debug_message(string(target[$"name"]) + " is down.");
}

doHeal = function(target, heal){
	target.hp = min(target.stats.maxhp, target.hp + heal);
	show_debug_message(string(target[$"name"]) + " heals " + string(heal) + "hp.");
}

doBuff = function(buff, ind){
		
}
doDebuff = function(db, ind){
	var dbData = global.data.effects[$"debuffs"];
	var debuff = struct_get(dbData, db);
	if (variable_struct_exists(debuff, "dmg")){
		doDamage(activeFighter, debuff[$"dmg"]);
	}
	if(--debuff[$"duration"] <= 0){
		array_delete(activeFighter[$"debuffs"], ind, 1);	
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
		show_debug_message("No actions loaded!");
	}
	var atkData = global.data.moves[$"attacks"];
	var splData = global.data.moves[$"spells"];
	
	if (variable_struct_exists(atkData, action)){
		var tIndex = irandom(array_length(team1) - 1);
		var target = team1[tIndex];
		doAttack(action, target, team1);
	} else if (variable_struct_exists(splData, action)){
		if (variable_struct_exists(struct_get(splData, action), "damage")){
			var tIndex = irandom(array_length(team1) - 1);
			var target = team1[tIndex];
			doSpell(action, target, team1);
		}
		if (variable_struct_exists(struct_get(splData, action), "heal")){
			var tIndex = irandom(array_length(team2) - 1);
			var target = team2[tIndex];
			doSpell(action, target, team2);
		}
	}
	
}