options = [];
selection = 0;
active = false;
attacks = [];
spells = [];
//menuState = BMENUST.ACTION;
menuBox = instance_create_layer(64,192, "Menu", objBattleBox);
battleInfo = {};
menuBox.battleInfo = battleInfo;
//fighter = {};
//team1Chars = [];
//team2Chars = [];



actors = [];
actIndex = 0;
action = "";
item = undefined;
operation = -1;
target = undefined;

controller = undefined;

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
	isSpell : false,
	isItem : false
}
getChar = undefined;

atkData = global.data.moves[$"attacks"];
splData = global.data.moves[$"spells"];

alarm[0] = 10;
audio_group_load(audiogroup_default);

turnStart = function(atks, spls){
	attacks = atks;
	spells = spls;
	if (DEBUG_ENABLED) show_debug_message(string(spls));
	options = [BOPS.ATTACK, BOPS.SPELL, BOPS.ITEM, BOPS.FLEE];	
	active = true;
	battleInfo.menuState = BMENUST.ACTION;
	actIndex = array_find_index(actors, actorGetChar(battleInfo.activeFighter));
	actors[actIndex].state = CHARSTATES.SELECTED;
	if (DEBUG_ENABLED) show_debug_message("Menu state: " + string(battleInfo.menuState) + " Active: " + string(active));
	menuBox.loadButtons(options);
	menuBox.selected = selection;
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
			break;
		case BOPS.SPELL:
			if (array_length(battleInfo.activeFighter[$"spells"]) > 0){
				options = spells;
				battleInfo.menuState = BMENUST.SPELL;
				operation = op;
				menuBox.loadButtons(options);
			}
			break;
		case BOPS.ITEM:
			if (array_length(battleInfo.inventory) > 0){
				options = battleInfo.inventory;
				battleInfo.menuState = BMENUST.ITEMS;
				operation = op;
				menuBox.loadButtons(options);
			}
			break;
		case BOPS.FLEE:
			options = ["NO", "YES"];
			battleInfo.menuState = BMENUST.FLEE;
			operation = op;
			menuBox.loadButtons(options);
			break;
		case BOPS.BACK:
			if (battleInfo.menuState == BMENUST.ATTACK || battleInfo.menuState == BMENUST.SPELL || battleInfo.menuState == BMENUST.ITEMS || battleInfo.menuState == BMENUST.FLEE){
				options = [BOPS.ATTACK, BOPS.SPELL, BOPS.ITEM, BOPS.FLEE];
				battleInfo.menuState = BMENUST.ACTION;
			}
			if (battleInfo.menuState == BMENUST.TARGET){
				doFunction(operation);
			}
			menuBox.loadButtons(options);
			break;
		case BOPS.TARGET:
			switch(operation){
				case BOPS.ATTACK:
					doAnimation(action, battleInfo.activeFighter, target, battleInfo.team2, false, false);
					break;
				case BOPS.SPELL:
					var spell = struct_get(splData, action);
					if (DEBUG_ENABLED) show_debug_message(string(spell));
					if (spell[$"type"] == "dmgSpell"){
						doAnimation(action, battleInfo.activeFighter, target, battleInfo.team2, true, false);	
					}
					if (spell[$"type"] == "restoreSpell" || spell[$"type"] == "buffSpell"){
						doAnimation(action, battleInfo.activeFighter, target, battleInfo.team1, true, false);	
					}
					if (spell[$"type"] == "selfSpell"){
						doAnimation(action, battleInfo.activeFighter, target, battleInfo.team1, true, false);	
					}
					break;
				case BOPS.ITEM:
					if (item[$"abil"] == "heal" || item[$"abil"] == "restore"){
						doAnimation(item, battleInfo.activeFighter, target, battleInfo.team1, false, true);	
					} else {
						doAnimation(item, battleInfo.activeFighter, target, battleInfo.team2, false, true);		
					}
					break;
			}
	}
}

doAnimation = function(action, actor, target, team, isSpell, isItem){
	actionWait.act = action;
	actionWait.tar = target;
	actionWait.team = team;
	actionWait.isSpell = isSpell;
	actionWait.isItem = isItem;
	var actor1 = actors[array_find_index(actors, actorGetChar(actor))];
	var actor2 = actors[array_find_index(actors, actorGetChar(target))];
	if (DEBUG_ENABLED) show_debug_message(action);
	actor1.doAnim(action, true);
	++animsWaiting;
	if (actor1 != actor2){
		actor2.doAnim(action, false);
		doEffect(action, actor2, 1);
		++animsWaiting;
	}
	if (DEBUG_ENABLED) show_debug_message("doAnimation Action Wait Act: " + string(actionWait.act));
	if (DEBUG_ENABLED) show_debug_message(string(actionWait));
	battleInfo.menuState = BMENUST.ANIMATE;
	menuBox.loadButtons([BOPS.ATTACK, BOPS.SPELL, BOPS.ITEM, BOPS.FLEE]);
	active = false;
}

doEffect = function(act, tar, spd){
	if (DEBUG_ENABLED) show_debug_message("[5]" + string(act));
	var action = undefined;
	if (variable_struct_exists(atkData, act)){
		action = struct_get(atkData, act);	
	} else if (variable_struct_exists(splData, act)){
		action = struct_get(splData, act);	
	} else {
		action = act;	
	}
	if (DEBUG_ENABLED) show_debug_message("[6]" + string(action));
	var eff = instance_create_layer(0, 0, "Effects", objBattleEffect);
	eff.initEff(action, asset_get_index(action[$"sprite"]), tar, self, spd, true);
	++animsWaiting;
}

animFinish = function(){
	if (--animsWaiting <= 0){
		if (DEBUG_ENABLED) show_debug_message("ANIM FINISH:" + string(actionWait.act) + string(actionWait.tar));
		if (actionWait.isSpell){
			if (actionWait.team == battleInfo.team2){
				controller.doSpell(actionWait.act, actionWait.tar, battleInfo.team2);
			} else {
				controller.doSpell(actionWait.act, actionWait.tar, battleInfo.team1);
			}
		} else if (actionWait.isItem){
			if (actionWait.team == battleInfo.team2){
				controller.doItem(actionWait.act, actionWait.tar, battleInfo.team2);
			} else {
				controller.doItem(actionWait.act, actionWait.tar, battleInfo.team1);
			}
		} else{
			if (actionWait.team == battleInfo.team2){
				controller.doAttack(actionWait.act, actionWait.tar, battleInfo.team2);
			} else {
				controller.doAttack(actionWait.act, actionWait.tar, battleInfo.team1);
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
	battleInfo.menuState = BMENUST.ACTION;
	//fighter = undefined;
}

loadCharacters = function(){
	for (var i = 0; i < array_length(battleInfo.team1); ++i){
		var char = instance_create_layer(charDrawX + i * charXOff, playerCharDrawY, "Actors", objBattleCharacter);
		char.loadSprite(battleInfo.team1[i]);
		char.isPlayerTeam = true;
		array_push(actors, char);
	}
	for (var i = 0; i < array_length(battleInfo.team2); ++i){
		var char = instance_create_layer(enemyCharDrawOffX + i * charXOff, enemyCharDrawY, "Actors", objBattleCharacter);
		char.loadSprite(battleInfo.team2[i]);
		array_push(actors, char);
	}
}

chooseTarget = function(team){
	battleInfo.menuState = BMENUST.TARGET;
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
	//team1Chars = controller.team1;
	//team2Chars = controller.team2;
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

flee = function(){
	turnEnd();
	controller.endBattle(false);
}