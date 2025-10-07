scrDefineMacros();

scrDefineDirs();
scrDefineNPC();
scrDefineMoves();
scrDefineEnemies();
scrDefineBattleStates();
scrDefineMenuOptions();

global.players = [];
global.debug = false;
global.battles = [];

global.data = {
	enemies		: scrLoadJSON("enemies.json"),
	dialogue	: scrLoadJSON("dialogue.json"),
	moves		: scrLoadJSON("moves.json"),
	companions	: scrLoadJSON("companions.json"),
	effects		: scrLoadJSON("effects.json")
};

