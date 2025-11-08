scrDefineMacros();

scrDefineDirs();
scrDefineNPC();
scrDefineMoves();
scrDefineEnemies();
scrDefineBattleStates();
scrDefineMenuOptions();


global.debug = false;
global.battles = [];
global.overworld = false;

global.data = {
	enemies		: scrLoadJSON("enemies.json"),
	dialogue	: scrLoadJSON("dialogue.json"),
	moves		: scrLoadJSON("moves.json"),
	companions	: scrLoadJSON("companions.json"),
	effects		: scrLoadJSON("effects.json"),
	items		: scrLoadJSON("items.json")
};

global.players = [instance_create_layer(0,0, "Instances", objPlayer)];
global.playerData = [
	{
		stats		: global.players[0].battlePlayer,
		inventory	: [global.data.items[$"hppotion"], global.data.items[$"manapotion"]]
	}
];
