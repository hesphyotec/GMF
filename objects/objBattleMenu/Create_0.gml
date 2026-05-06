options = [];
selection = 0;
active = false;
attacks = [];
spells = [];
//menuState = BMENUST.ACTION;
menuBox = instance_create_layer(64,192, "Menu", objBattleBox);
battleInfo = {};
menuBox.battleInfo = battleInfo;
fighter = undefined;
//team1Chars = [];
//team2Chars = [];



actors = [];
//activeAnimations = [];
actIndex = 0;
action = "";
item = undefined;
operation = -1;
target = undefined;

context = undefined;
menuBox.context = context;

playerCharDrawY = 146;
charDrawX = 96;
charXOff = 80;
enemyCharDrawY = 96;
enemyCharDrawOffX = 192;

//animsWaiting = 0;
actionWait = {
	act : undefined,
	tar : undefined,
	team : undefined,
	isSpell : false,
	isItem : false
}
getChar = undefined;

atkData = global.data.moves[$"attacks"];
splData = global.data.moves[$"spells"];

alarm[0] = 10;
audio_group_load(audiogroup_default);

turnStart = function(ftr, atks, spls){
	fighter = ftr;
	menuBox.loadFighter(fighter);
	attacks = atks;
	spells = spls;
	if (DEBUG_ENABLED) clientLog(string(spls));
	options = [BOPS.ATTACK, BOPS.SPELL, BOPS.ITEM, BOPS.FLEE];	
	active = true;
	battleInfo.menuState = BMENUST.ACTION;
	if (DEBUG_ENABLED) clientLog("[Menu]" + string(actors));
	actIndex = charGetActorInd(fighter);
	if (DEBUG_ENABLED) clientLog("[Menu]" + string(actIndex) + " : " + string(fighter));
	actors[actIndex].isSelected = true;
	
	if(scrCheckEffects(fighter.debuffs, global.data.effects.debuffs.taunted)){
		var tauntInfo = fighter[$"debuffs"][scrGetEffect(fighter[$"debuffs"], global.data.effects.debuffs[$"taunted"])];
		var tauntSource = tauntInfo.source;
		doAction(array_last(fighter.attacks), fighter, tauntSource, battleInfo.team2, false, false);
		return;
	}
	
	if (DEBUG_ENABLED) clientLog("[Menu] Menu state: " + string(battleInfo.menuState) + " Active: " + string(active));
	menuBox.loadButtons(options);
	menuBox.loadGUICards();
	menuBox.selected = selection;
	menuBox.loadCharInfoMasks();
}

doFunction = function(op){
	selection = 0;
	menuBox.selected = selection;
	switch(op){
		case BOPS.ATTACK:
			options = attacks;
			battleInfo.menuState = BMENUST.ATTACK;
			operation = op;
			menuBox.loadButtons(options);
			menuBox.loadGUIButtons();
			menuBox.loadContainerCard(op);
			break;
		case BOPS.SPELL:
			if (array_length(fighter[$"spells"]) > 0){
				options = spells;
				battleInfo.menuState = BMENUST.SPELL;
				operation = op;
				menuBox.loadButtons(options);
				menuBox.loadGUIButtons();
				menuBox.loadContainerCard(op);
			}
			break;
		case BOPS.ITEM:
			if (array_length(battleInfo.inventory) > 0){
				options = [];
				for (var i = 0; i < array_length(battleInfo.inventory); ++i){
					if (battleInfo.inventory[i] != undefined && struct_exists(battleInfo.inventory[i], "consumable")){
						array_push(options, battleInfo.inventory[i]);	
					}
				}
				battleInfo.menuState = BMENUST.ITEMS;
				operation = op;
				menuBox.loadButtons(options);
				menuBox.loadGUIButtons();
				menuBox.loadContainerCard(op);
			}
			break;
		case BOPS.FLEE:
			options = ["NO", "YES"];
			battleInfo.menuState = BMENUST.FLEE;
			operation = op;
			menuBox.loadButtons(options);
			menuBox.loadGUIButtons();
			menuBox.loadContainerCard(op);
			break;
		case BOPS.BACK:
			if (battleInfo.menuState == BMENUST.ATTACK || battleInfo.menuState == BMENUST.SPELL || battleInfo.menuState == BMENUST.ITEMS || battleInfo.menuState == BMENUST.FLEE){
				options = [BOPS.ATTACK, BOPS.SPELL, BOPS.ITEM, BOPS.FLEE];
				battleInfo.menuState = BMENUST.ACTION;
				menuBox.loadButtons(options);
				menuBox.loadGUIButtons();
				menuBox.loadGUICards();
			}
			if (battleInfo.menuState == BMENUST.TARGET){
				doFunction(operation);
				menuBox.loadButtons(options);
				menuBox.loadGUIButtons();
				menuBox.loadContainerCard(operation);
			}
			break;
		case BOPS.TARGET:
			switch(operation){
				case BOPS.ATTACK:
					doAction(action, fighter, target, battleInfo.team2, false, false);
					break;
				case BOPS.SPELL:
					var spell = struct_get(splData, action);
					if (DEBUG_ENABLED) clientLog("[Menu]" + string(spell));
					if (spell[$"type"] == "dmgSpell" || spell[$"type"] == "debuffSpell"){
						doAction(action, fighter, target, battleInfo.team2, true, false);	
					}
					if (spell[$"type"] == "dmgSpellAll" || spell[$"type"] == "debuffSpellAll"){
						doAction(action, fighter, battleInfo.team2, battleInfo.team2, true, false);	
					}
					if (spell[$"type"] == "restoreSpell" || spell[$"type"] == "buffSpell"){
						doAction(action, fighter, target, battleInfo.team1, true, false);	
					}
					if (spell[$"type"] == "selfSpell"){
						doAction(action, fighter, target, battleInfo.team1, true, false);	
					}
					break;
				case BOPS.ITEM:
					if (item[$"abil"] == "heal" || item[$"abil"] == "restore"){
						doAction(item, fighter, target, battleInfo.team1, false, true);
					} else {
						doAction(item, fighter, target, battleInfo.team2, false, true);		
					}
					break;
			}
			menuBox.loadButtons([BOPS.ATTACK, BOPS.SPELL, BOPS.ITEM, BOPS.FLEE]);
	}
}

doAction = function(action, actor, target, team, isSpell, isItem){
	menuBox.clearButtons();
	menuBox.clearCards();
	menuBox.clearMasks();
	actionInfo = {
		act : action,
		actor : actor,
		tar : target,
		team : team,
		isSpell : isSpell,
		isItem : isItem,
		actorChar : actors[charGetActorInd(actor)],
	};
	if (!is_array(target)){
		actionInfo.targetChar = actors[charGetActorInd(target)]	
	} else {
		var chars = [];
		for(var i = 0; i < array_length(team); ++i){
			array_push(chars, actors[charGetActorInd(team[i])]);
		}
		actionInfo.targetChars = chars;
	}
	if (DEBUG_ENABLED) clientLog("[Menu]" + string(action));
	if (global.isPlayerBattle){
		clientLog("Sending Action!");
		var tempTeam = true;
		if (team == battleInfo.team1){
			tempTeam = false;
		}
		var actData = {
			action : action,
			actor : actor,
			target : target,
			team : tempTeam,
			isSpell : isSpell,
			isItem : isItem
		}
		scrNBActionEvent(global.server, actData);
		return;
	}
	
	if(!isItem){
		if (isSpell){
			var spell = struct_get(splData, action);
			if(struct_exists(fighter, "mana")){
				fighter[$"mana"] -= spell[$"cost"];
			}
			if(struct_exists(fighter, "blood")){
				fighter[$"blood"] -= spell[$"cost"];
			}
			if(struct_exists(fighter, "rage")){
				fighter[$"rage"] -= spell[$"rage"];
			}
			if(struct_exists(fighter, "energy")){
				fighter[$"energy"] -= spell[$"cost"];
			}
		}
		context.qteHandler.loadQTE(actionInfo);
	} else {
		context.controller.doItem(actor, action, target, team, true);
	}
	var activeActor = actors[charGetActorInd(actor)];
	var spdMod = 1;
	for (var i = 0; i < array_length(actor.buffs); ++i){
		var buff = actor.buffs[i];
		if (buff.abil == "speed"){
			spdMod /= buff.pow;	
		}
	}
	for (var i = 0; i < array_length(actor.debuffs); ++i){
		var debuff = actor.debuffs[i];
		if (debuff.abil == "slowness"){
			spdMod /= debuff.pow;	
		}
	}
	activeActor.startTimer(spdMod);
}

doAnimation = function(info){
	var actor1 = actors[charGetActorInd(info.actor)];
	actor1.doAnim(info.act, info, true);
	if(is_array(info.tar)){
		for(var i = 0; i < array_length(info.tar); ++i){
			var actor2 = actors[charGetActorInd(info.tar[i])];
			doEffect(info.act, actor1, actor2, 1);
			actor2.doAnim(info.act, info, false);
		}
	} else {
		if(charGetActorInd(info.tar) != -1){
			var actor2 = actors[charGetActorInd(info.tar)];
			actor2 = actors[charGetActorInd(info.tar)];
			doEffect(info.act, actor1, actor2, 1);
			actor2.doAnim(info.act, info, false);
		}
	}
}

doEffect = function(act, src, tar, spd){
	var action = undefined;
	if (variable_struct_exists(atkData, act)){
		action = struct_get(atkData, act);
	} else if (variable_struct_exists(splData, act)){
		action = struct_get(splData, act);	
	} else {
		action = act;	
	}
	try {
		var eff = instance_create_layer(0, 0, "Effects", objBattleEffect);
		eff.initEff(action, struct_get(global.data.anims, action[$"sprite"]), tar, self, spd, true, src);
	} catch (_ex) {
		clientLog(_ex);
	}
}

turnEnd = function(){
	if (DEBUG_ENABLED) clientLog("[Menu] Turn End");
	options = [];
	menuBox.loadButtons(options);
	menuBox.clearCards();
	menuBox.clearButtons();
	menuBox.clearMasks();
	if (instance_exists(actors[actIndex])){
		actors[actIndex].isSelected = false;
	}
	selection = 0;
	active = false;
	attacks = [];
	spells = [];
	battleInfo.menuState = BMENUST.ACTION;
	fighter = undefined;
}

loadCharacters = function(){
	for (var i = 0; i < array_length(battleInfo.team1); ++i){
		var char = instance_create_layer(charDrawX + i * charXOff, playerCharDrawY, "Actors", objBattleCharacter);
		char.loadSprite(battleInfo.team1[i]);
		char.isPlayerTeam = true;
		char.context = context;
		char.battleInfo = battleInfo;
		array_push(actors, char);
	}
	for (var i = 0; i < array_length(battleInfo.team2); ++i){
		var char = instance_create_layer(enemyCharDrawOffX + i * charXOff, enemyCharDrawY, "Actors", objBattleCharacter);
		char.loadSprite(battleInfo.team2[i]);
		char.context = context;
		char.battleInfo = battleInfo;
		array_push(actors, char);
	}
}

chooseTarget = function(team){
	battleInfo.menuState = BMENUST.TARGET;
	selection = 0;
	menuBox.selected = selection;
	options = [];
	var names = [];
	if (is_string(team[0])){
		options = ["all"];
		array_push(names, team[0]);
	} else {
		for (var i = 0; i < array_length(team); ++i){
			battleInfo.tarteam = team;
			if (!scrCheckEffects(team[i].buffs, global.data.effects.buffs.stealth1)){
				array_push(options, team[i]);
				array_push(names, team[i][$"name"]);
			}
		}
		menuBox.loadCharMasks(team);
	}
	menuBox.loadButtons(names);
	menuBox.loadGUIButtons();
	menuBox.loadContainerCard("TARGET");
	
}

charDied = function(ftr){
	var ind = charGetActorInd(ftr);
	actors[ind].doDied();
	array_delete(actors, ind, 1);
}

charGetActorInd = function(char){
	for(var i = 0; i < array_length(actors); ++i){
		if (actors[i].character[$"cid"] == char[$"cid"]){
			return i;	
		}
	}
	return -1;
}

updateSelection = function(sel){
	selection = ((selection + sel) + array_length(options)) mod array_length(options);
	menuBox.selected = selection;
	if (DEBUG_ENABLED) clientLog("[Menu] " + string(selection));
	if (DEBUG_ENABLED) clientLog("[Menu] " + string(options[selection]));
	audio_play_sound(sndSelect,1,false);
}

flee = function(){
	turnEnd();
	context.controller.endBattle(false);
}

getActor = function(char){
	return actors[charGetActorInd(char)];
}

netStartQTE = function(){
	objQteHandler.loadQTE(actionInfo);	
}

selectAttack = function(){
	action = options[selection];
	if (DEBUG_ENABLED) show_debug_message("[Menu] Enemies: " + string(battleInfo.team2));
	chooseTarget(battleInfo.team2);
}

selectSpell = function(){
	action = options[selection];
	var spell = struct_get(splData, action);
	if (DEBUG_ENABLED) show_debug_message("[Menu]" + string(spell));
	if (spell[$"cost"] <= fighter[$"mana"] || spell[$"cost"] <= fighter[$"energy"] || !(struct_exists(fighter, "mana")) || struct_exists(fighter, "energy")){
		if (variable_struct_exists(spell,"type")){
			if (spell[$"type"] == "dmgSpell" || spell[$"type"] == "debuffSpell"){
				if (DEBUG_ENABLED) show_debug_message("[Menu] Enemies: " + string(battleInfo.team2) + string(battleInfo.team2));
				chooseTarget(battleInfo.team2);	
			}	
			if (spell[$"type"] == "dmgSpellAll" || spell[$"type"] == "debuffSpellAll"){
				chooseTarget(["All Enemies"]);	
			}	
			if (spell[$"type"] == "restoreSpell" || spell[$"type"] == "buffSpell"){
				chooseTarget(battleInfo.team1);	
			}
			if (spell[$"type"] == "selfSpell"){
				chooseTarget([fighter]);	
			}
		}
	} else {
		audio_play_sound(sndNoResource, 1, false);
	}
}

selectItem = function(){
	item = options[selection];
	if (DEBUG_ENABLED) show_debug_message("[Menu]" + string(item));
	if (variable_struct_exists(item,"abil")){
		if (item[$"abil"] == "heal" || item[$"abil"] == "restore"){
			chooseTarget(battleInfo.team1);	
		} else {
			chooseTarget(battleInfo.team2);	
		}	
	}
}

selectTarget = function(){
	target = options[selection];
	if (DEBUG_ENABLED) show_debug_message("[Menu]" + string(target));
	doFunction(BOPS.TARGET);
	menuBox.clearMasks();
}

showRewards = function(xpShare){
	var lines = ["You Win!"];

	for(var i = 0; i < array_length(context.playerTeam.team); ++i){
		var ftr = context.playerTeam.team[i];
		if (ftr.hp > 0){
			var xpMsg = giveExp(global.players[0].team, ftr, xpShare);
			for (var j = 0; j < array_length(xpMsg); ++j){
				array_push(lines, xpMsg[j]);	
			}
		}
	}
	menuBox.loadInfoBox(lines);
}
audio_stop_all();
audio_play_sound(sndLvl1, 2, true, global.musVolume);