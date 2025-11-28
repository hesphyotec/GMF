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
global.isPlayerBattle = false;

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
	var race = true;
	if(array_length(global.players) > 0){
		race = false;	
	}
	var player = instance_create_layer(0, 0, "Instances", objPlayer);
	player.sockId = sock;
	player.currMap = scrLoadMap("testmap.txt");
	if (!global.isServer){
		global.map = player.currMap;
	}	
	player.mapPos = [floor(player.currMap.width / 2), player.currMap.height-1];
	if(race){
		player.battlePlayer = player.loadCompanion("humanplayer");
	} else {
		player.battlePlayer = player.loadCompanion("impplayer");	
	}
	array_push(global.players, player);
	var playerInfo = {
		stats		: player.battlePlayer,
		inventory	: [global.data.items[$"hppotion"], global.data.items[$"manapotion"]]
	}
	array_push(global.playerData, playerInfo);	
}