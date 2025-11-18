character = undefined;
sockId = -1;
currMap = {};

generatePlayer = function(){
	character = instance_create_layer(room_width/2, room_height-32,"Instances", objOWPlayer);
}

generateNetPlayer = function(){
	character = instance_create_layer(room_width/2, room_height-32,"Instances", objNetPlayer);
}

battlePlayer = {
	cid		: 0,
	level	: 1,
	name	: "Player",
	hp		: 100,
	mana	: 100,
	stats	: {
		maxhp	: 100,
		maxmana : 100,
		str		: 5,
		dex		: 5,
		cspd	: 5,
		int		: 5
	},
	attacks	: ["slash", "jab"],
	spells	: ["heal"],
	buffs	: [],
	debuffs : [],
	sprite	: "sprBattlePlayerT",
	splash	: "sprHumanPlayerSplash",
	resistances : {
		str : 0.00,
		dex : 0.10,
		int : 0.00
	},
	desc : "It's you!."
};

loadCompanion = function(comp){
	if (struct_exists(global.data.companions, comp)){
		var companion = variable_clone(struct_get(global.data.companions, comp));
		return companion;
	} else {
		show_debug_message("FAILED TO LOAD COMPANION");
		return {};
	}
};

team = [battlePlayer];

partyAdd = function(comp){
	var companion = struct_get(global.data.companions, comp);
	array_push(team, variable_clone(companion));
	if (!global.isServer){
		with(character){
			var compChar = instance_create_layer(x, y, "Instances", objCompanion);
			array_push(companions, compChar);
		}
		scrNetAddComp(global.server, comp);
	}
}

oppPartyAdd = function(comp){
	var companion = struct_get(global.data.companions, comp);
	array_push(team, variable_clone(companion));
	with(character){
		var compChar = instance_create_layer(x, y, "Instances", objCompanion);
		array_push(companions, compChar);
	}
}

mapPos = [0, 0];

getMTar = function(_up, _down, _left, _right){
		var dir = 0;
		var moveTarget = mapPos;
		if (_up){
			dir = Dirs.UP;
			if(scrMapCanMove(currMap, mapPos[0], mapPos[1]-1)){
				moveTarget[1]--;
			}
		} else if (_left){
			dir = Dirs.LEFT;
			if(scrMapCanMove(currMap, mapPos[0]-1, mapPos[1])){
				moveTarget[0]--;
			}
		} else if (_right){
			dir = Dirs.RIGHT;
			if(scrMapCanMove(currMap, mapPos[0]+1, mapPos[1])){
				moveTarget[0]++;
			}
		} else if (_down){
			dir = Dirs.DOWN;
			if(scrMapCanMove(currMap, mapPos[0], mapPos[1]+1)){
				moveTarget[1]++;
			}
		}
		mapPos = moveTarget;
		return [moveTarget, dir];
	}