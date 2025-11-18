scrDefineMacros();
scrNetworkMacros();
scrDefineDirs();
scrDefineNPC();
scrDefineMoves();
scrDefineEnemies();
scrDefineBattleStates();
scrDefineMenuOptions();

global.isServer = false;
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

global.map = undefined;
global.players = [];
global.playerData = [];

generatePlayer = function(sock){
	var player = instance_create_layer(0, 0, "Instances", objPlayer);
	player.sockId = sock;
	player.currMap = scrLoadMap("testmap.txt");
	if (!global.isServer){
		global.map = player.currMap;
	}	
	player.mapPos = [floor(player.currMap.width / 2), player.currMap.height-1];
	array_push(global.players, player);
	var playerInfo = {
		stats		: global.players[0].battlePlayer,
		inventory	: [global.data.items[$"hppotion"], global.data.items[$"manapotion"]]
	}
	array_push(global.playerData, playerInfo);	
}