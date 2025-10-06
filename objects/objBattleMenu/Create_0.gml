options = [];
selection = 0;
active = false;
attacks = [];
spells = [];
menuState = BMENUST.ACTION;
menuBox = instance_create_layer(64,192, "Menu", objBattleBox);
fighter = {};
team1Chars = [];
team2Chars = [];
actors = [];
actIndex = 0;
action = "";
operation = -1;
target = undefined;

playerCharDrawY = 146;
charDrawX = 128;
charXOff = 64;
enemyCharDrawY = 96;
enemyCharDrawOffX = 256;

animsWaiting = 0;
actionWait = {
	act : undefined,
	tar : undefined,
	team : undefined,
	isSpell : false
}
getChar = undefined;

atkData = global.data.moves[$"attacks"];
splData = global.data.moves[$"spells"];

alarm[0] = 10;
audio_group_load(audiogroup_default);

turnStart = function(ftr, atks, spls){
	attacks = atks;
	spells = spls;
	if (DEBUG_ENABLED) show_debug_message(string(spls));
	options = [BOPS.ATTACK, BOPS.SPELL, BOPS.ITEM, BOPS.FLEE];	
	fighter = ftr;
	active = true;
	menuState = BMENUST.ACTION;
	actIndex = array_find_index(actors, actorGetChar(fighter));
	actors[actIndex].state = CHARSTATES.SELECTED;
	if (DEBUG_ENABLED) show_debug_message("Menu state: " + string(menuState) + " Active: " + string(active));
	menuBox.loadButtons(options);
	menuBox.selected = selection;
}

doFunction = function(op){
	selection = 0;
	menuBox.selected = selection;
	switch(op){
		case BOPS.ATTACK:
			options = attacks;
			menuState = BMENUST.ATTACK;
			operation = op;
			menuBox.loadButtons(options);
			break;
		case BOPS.SPELL:
			if (array_length(fighter[$"spells"]) > 0){
				options = spells;
				menuState = BMENUST.SPELL;
				operation = op;
				menuBox.loadButtons(options);
			}
			break;
		case BOPS.BACK:
			if (menuState == BMENUST.ATTACK || menuState == BMENUST.SPELL){
				options = [BOPS.ATTACK, BOPS.SPELL, BOPS.ITEM, BOPS.FLEE];
				menuState = BMENUST.ACTION;
			}
			if (menuState == BMENUST.TARGET){
				doFunction(operation);
			}
			menuBox.loadButtons(options);
			break;
		case BOPS.TARGET:
			switch(operation){
				case BOPS.ATTACK:
					doAnimation(action, fighter, target, team2Chars, false);
					break;
				case BOPS.SPELL:
					var spell = struct_get(splData, action);
					if (DEBUG_ENABLED) show_debug_message(string(spell));
					if (variable_struct_exists(spell,"damage")){
						doAnimation(action, fighter, target, team2Chars, true);	
					}
					if (variable_struct_exists(spell,"heal")){
						doAnimation(action, fighter, target, team1Chars, true);	
					}
					break;
			}
	}
}

doAnimation = function(action, actor, target, team, isSpell){
	var actor1 = actors[array_find_index(actors, actorGetChar(actor))];
	var actor2 = actors[array_find_index(actors, actorGetChar(target))];
	actor1.doAnim(action, true);
	++animsWaiting;
	if (actor1 != actor2){
		actor2.doAnim(action, false);
		doEffect(action, actor2, 1);
		++animsWaiting;
	}
	actionWait.act = action;
	actionWait.tar = target;
	actionWait.team = team;
	actionWait.isSpell = isSpell;
	if (DEBUG_ENABLED) show_debug_message(string(actionWait));
	menuState = BMENUST.ANIMATE;
	menuBox.loadButtons([BOPS.ATTACK, BOPS.SPELL, BOPS.ITEM, BOPS.FLEE]);
	active = false;
}

doEffect = function(act, tar, spd){
	var action = undefined;
	if (struct_exists(atkData, act)){
		action = struct_get(atkData, act);	
	} else if (struct_exists(splData, act)){
		action = struct_get(splData, act);	
	}
	var eff = instance_create_layer(0, 0, "Effects", objBattleEffect);
	eff.initEff(action, asset_get_index(action[$"sprite"]), tar, self, spd, true);
	++animsWaiting;
}

animFinish = function(){
	if (--animsWaiting <= 0){
		if (DEBUG_ENABLED) show_debug_message(string(actionWait.act) + string(actionWait.tar));
		if (actionWait.isSpell){
			if (actionWait.team == team2Chars){
				objBattleController.doSpell(actionWait.act, actionWait.tar, objBattleController.team2);
			} else {
				objBattleController.doSpell(actionWait.act, actionWait.tar, objBattleController.team1);
			}
		} else {
			if (actionWait.team == team2Chars){
				objBattleController.doAttack(actionWait.act, actionWait.tar, objBattleController.team2);
			} else {
				objBattleController.doAttack(actionWait.act, actionWait.tar, objBattleController.team1);
			}
		}
	}
}

turnEnd = function(){
	if (DEBUG_ENABLED) show_debug_message("Menu Turn End");
	options = [];
	menuBox.loadButtons(options);
	actors[actIndex].state = CHARSTATES.IDLE;
	//alarm[0] = 15;
	selection = 0;
	active = false;
	attacks = [];
	spells = [];
	menuState = BMENUST.ACTION;
	fighter = undefined;
}

loadCharacters = function(){
	for (var i = 0; i < array_length(team1Chars); ++i){
		var char = instance_create_layer(charDrawX + i * charXOff, playerCharDrawY, "Actors", objBattleCharacter);
		char.loadSprite(team1Chars[i]);
		char.isPlayerTeam = true;
		array_push(actors, char);
	}
	for (var i = 0; i < array_length(team2Chars); ++i){
		var char = instance_create_layer(enemyCharDrawOffX + i * charXOff, enemyCharDrawY, "Actors", objBattleCharacter);
		char.loadSprite(team2Chars[i]);
		array_push(actors, char);
	}
}

chooseTarget = function(team){
	menuState = BMENUST.TARGET;
	selection = 0;
	menuBox.selected = selection;
	options = [];
	var names = [];
	for (var i = 0; i < array_length(team); ++i){
		array_push(options, team[i]);
		array_push(names, team[i][$"name"]);
	}
	menuBox.loadButtons(names);
}

charDied = function(){
	//if (DEBUG_ENABLED) show_debug_message("Target: " + string(target) + string(team[target]));
	team1Chars = objBattleController.team1;
	team2Chars = objBattleController.team2;
	//if(DEBUG_ENABLED) show_debug_message("[cDied 0] Enemy Team Remaining: " + string(array_length(objBattleController.team2)));
	//if (team == objBattleController.team1){
	//	array_delete(team1Chars, array_get_index(team1Chars, target), 1);
	//} else {
	//	array_delete(team2Chars, array_get_index(team2Chars, target), 1);
	//}
	//if(DEBUG_ENABLED) show_debug_message("[cDied 1] Enemy Team Remaining: " + string(array_length(objBattleController.team2)));
}

actorGetChar = function(char){
    var data = {char};
    var func = function(e, i) {
        return e.character == self.char;
    };
    return method(data, func);
}

updateSelection = function(sel){
	selection = ((selection + sel) + array_length(options)) mod array_length(options);
	menuBox.selected = selection;
	if (DEBUG_ENABLED) show_debug_message(string(selection));
	if (DEBUG_ENABLED) show_debug_message(string(options[selection]));
	//alarm[0] = 10;
	audio_play_sound(sndSelect,1,false);
}