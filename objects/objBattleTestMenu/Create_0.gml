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

state = TESTOPS.START;
options = [TESTOPS.BUILDTEAM, TESTOPS.SERVER, TESTOPS.OVERWORLD, TESTOPS.QUIT];
selected = 0;
members = 0;

doOperation = function(op){
	switch(op){
		case TESTOPS.BUILDTEAM:
			state = TESTOPS.BUILDTEAM;
			objGame.generatePlayer(-1);
			options = [CHARS.VETERAN, CHARS.ARCHER, CHARS.ASSASSIN, CHARS.HEALER, CHARS.TINKERER];
			break;
		case TESTOPS.SELECTMEM:
			var mem = getClass(options[selected]);
			array_push(objPlayer.team, objPlayer.loadCompanion(mem));
			array_delete(options, selected, 1);
			if (++members >= 3){
				state = TESTOPS.CHOOSEFIGHT;
				options = [TESTOPS.START];
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
	selected = (selected + dir + array_length(options)) mod array_length(options);
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