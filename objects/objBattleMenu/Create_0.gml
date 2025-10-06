options = [];
selection = 0;
active = false;
attacks = [];
spells = [];
menuState = BMENUST.ACTION;
menuBox = instance_create_layer(64,192, "Instances", objBattleBox);
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

alarm[0] = 10;
turnStart = function(ftr, atks, spls){
	attacks = atks;
	spells = spls;
	if (DEBUG_ENABLED) show_debug_message(string(spls));
	options = [BOPS.ATTACK, BOPS.SPELL, BOPS.ITEM, BOPS.FLEE];	
	fighter = ftr;
	active = true;
	menuState = BMENUST.ACTION;
	actIndex = array_find_index(actors, function(e, i){
		return e.character == fighter;	
	})
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
					with(objBattleController){
						doAttack(other.action, other.target, team2);
					}
					break;
				case BOPS.SPELL:
					with(objBattleController){
						var spell = struct_get(global.data.moves[$"spells"], other.action);
						if (DEBUG_ENABLED) show_debug_message(string(spell));
						if (variable_struct_exists(spell,"damage")){
							doSpell(other.action, other.target, team2);	
						}
						if (variable_struct_exists(spell,"heal")){
							doSpell(other.action, other.target, team1);	
						}
					}
					break;
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
		var char = instance_create_layer(charDrawX + i * charXOff, playerCharDrawY, "Instances", objBattleCharacter);
		char.loadSprite(team1Chars[i]);
		char.isPlayerTeam = true;
		array_push(actors, char);
	}
	for (var i = 0; i < array_length(team2Chars); ++i){
		var char = instance_create_layer(enemyCharDrawOffX + i * charXOff, enemyCharDrawY, "Instances", objBattleCharacter);
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

charDied = function(target, team){
	array_delete(team, target, 1);	
}

updateSelection = function(sel){
	selection = ((selection + sel) + array_length(options)) mod array_length(options);
	menuBox.selected = selection;
	if (DEBUG_ENABLED) show_debug_message(string(selection));
	if (DEBUG_ENABLED) show_debug_message(string(options[selection]));
	//alarm[0] = 10;
	audio_play_sound(sndSelect,1,false);
}