enum TESTOPS{
	START,
	SERVER,
	OVERWORLD,
	BUILDTEAM,
	SELECTMEM,
	CHOOSEFIGHT,
	QUIT
}

enum CHARS{
	VETERAN,
	HEALER,
	ARCHER,
	ASSASSIN,
	TINKERER
}

buttXpos = display_get_gui_width() * .5 - 64;
buttYpos = display_get_gui_height() * .45;
state = TESTOPS.START;
options = [TESTOPS.BUILDTEAM, TESTOPS.SERVER, TESTOPS.OVERWORLD, TESTOPS.QUIT];
selected = 0;
members = 0;
buttons = [];

doOperation = function(op){
	switch(op){
		case TESTOPS.BUILDTEAM:
			state = TESTOPS.BUILDTEAM;
			objGame.generatePlayer(-1, RACE.HUMAN);
			options = [CHARS.VETERAN, CHARS.ARCHER, CHARS.ASSASSIN, CHARS.HEALER, CHARS.TINKERER];
			loadButtons();
			break;
		case TESTOPS.SELECTMEM:
			var mem = getClass(options[selected]);
			array_push(objPlayer.team, objPlayer.loadCompanion(mem));
			array_delete(options, selected, 1);
			loadButtons();
			if (++members >= 3){
				state = TESTOPS.CHOOSEFIGHT;
				options = [TESTOPS.START];
				loadButtons();
			}
			break;
		case TESTOPS.START:
			scrStartBattle(rmTestSelect, objPlayer.team, ENCOUNTERS.BANDIT1);
			break;
		case TESTOPS.SERVER:
			room_goto(rmServer);
			break;
		case TESTOPS.OVERWORLD:
			room_goto(rmHCastleTest);
			break;
		case TESTOPS.QUIT:
			game_end(0);
			break;
	}
}

getClass = function(char){
	var mem = "";
	switch(char){
		case CHARS.ARCHER:
			mem = "archer";
			break;
		case CHARS.ASSASSIN:
			mem = "assassin";
			break;
		case CHARS.HEALER:
			mem = "mage";
			break;
		case CHARS.TINKERER:
			mem = "tinkerer";
			break;
		case CHARS.VETERAN:
			mem = "veteran";
			break;
	}
	return mem;
}

updateSelection = function(dir){
	buttons[selected].hovered = false;
	selected = (selected + dir + array_length(options)) mod array_length(options);
	buttons[selected].isKeySelected = true;
	buttons[selected].hovered = true;
}

getOpText = function(op){
	if (op == TESTOPS.BUILDTEAM){
		return "Build Team.";
	}
	if (op == TESTOPS.SERVER){
		return "Start Server";
	}
	if (op == TESTOPS.OVERWORLD){
		return "Start Client";
	}
	if (op == TESTOPS.QUIT){
		return "Quit";
	}
}

loadButtons = function(){
	buttons = [];
	instance_destroy(objMenuComponent);
	switch(state){
		case TESTOPS.START:
			for(var i = 0; i < array_length(options); ++i){
				var butt = createButton(buttXpos, buttYpos + (36 * i), 128, 32, sprButtonTest, GUI.TEXTBUTTON, {text : getOpText(options[i]), op : options[i]});
				with(butt){
					onClick = function(){
						objBattleTestMenu.doOperation(data.op);
					}
				}
				array_push(buttons, butt);
			}
			break;
		case TESTOPS.BUILDTEAM:
			for(var i = 0; i < array_length(options); ++i){
				var butt = createButton(buttXpos, buttYpos + (36 * i), 128, 32, sprButtonTest, GUI.TEXTBUTTON, {text : getClass(options[i]), char : options[i], index : i});
				with(butt){
					onClick = function(){
						objBattleTestMenu.doOperation(TESTOPS.SELECTMEM);
					}
					onHover = function(){
						objBattleTestMenu.selected = data.index;
					}
				}
				array_push(buttons, butt);
			}
			break;
		case TESTOPS.CHOOSEFIGHT:
			for(var i = 0; i < array_length(options); ++i){
				var butt = createButton(buttXpos, buttYpos + (36 * i), 128, 32, sprButtonTest, GUI.TEXTBUTTON, {text : "Start Battle"});
				with(butt){
					onClick = function(){
						objBattleTestMenu.doOperation(TESTOPS.START);
					}
				}
				array_push(buttons, butt);
			}
	}
}
loadButtons();