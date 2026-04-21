character = undefined;
race = RACE.HUMAN;
sockId = -1;
currMap = {};

generatePlayer = function(){
	character = instance_create_layer(room_width/2, room_height-32,"Instances", objOWPlayer);
	character.baseSpriteName = (race == RACE.HUMAN ? "sprPlayerTemp" : "sprImpPlayerTemp");
}

generateNetPlayer = function(){
	character = instance_create_layer(room_width/2, room_height-32,"Instances", objNetPlayer);
	character.baseSpriteName = (race == RACE.HUMAN ? "sprPlayerTemp" : "sprImpPlayerTemp");
}

findPlayer = function(){
	character = instance_find(objOWPlayer, 1);
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
		companion.equipment = [];
		companion.stats.equipMax = 4;
		companion.exp = 0;
		companion.expCap = 100;
		return companion;
	} else {
		show_debug_message("FAILED TO LOAD COMPANION");
		return {};
	}
};

team = [];

partyAdd = function(comp){
	var companion = struct_get(global.data.companions, comp);
	companion.equipment = [];
	companion.stats.equipMax = 4;
	companion.exp = 0;
	companion.expCap = 100;
	array_push(team, variable_clone(companion));
	if (!global.isServer){
		with(character){
			var compChar = instance_create_layer(x, y, "Instances", objCompanion);
			array_push(companions, compChar);
		}
		scrNetAddComp(global.server, comp);
	}
	savePlayerData();
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
		moveTarget[1]--;
	} else if (_left){
		dir = Dirs.LEFT;
		moveTarget[0]--;
	} else if (_right){
		dir = Dirs.RIGHT;
		moveTarget[0]++;
	} else if (_down){
		dir = Dirs.DOWN;
		moveTarget[1]++;
	}
	mapPos = moveTarget;
	return [moveTarget, dir];
}

getSnapshot = function(){
	return {
		race : race,
		sockId : sockId,
		team : team,
		mapPos : mapPos
	}
}

equipItem = function(item, ind){
	var ftr = team[ind];
	if (array_length(ftr.equipment) < ftr.stats.equipMax){
		var equipped = struct_get(global.data.equipment, item);
		array_push(ftr.equipment, equipped);
		if (struct_exists(equipped, "pResist")){
			ftr.resistances.str += equipped.pResist;	
		}
		if (struct_exists(equipped, "hpBonus")){
			ftr.hp += equipped.hpBonus;
			ftr.stats.maxhp += equipped.hpBonus;	
		}
		if (struct_exists(equipped, "pResist")){
			ftr.resistances.str += equipped.pResist;	
		}
		if (struct_exists(equipped, "strBonus")){
			ftr.stats.str += equipped.strBonus;	
		}
		if (struct_exists(equipped, "attack")){
			array_insert(ftr.attacks, 0, equipped.attack);
		}
		if (objInventoryMenu.open){
			objInventoryMenu.refreshMenu();	
		}
		return true;
	}
	return false;
}

unequipItem = function(charInd, itemInd){
	var ftr = team[charInd];
	var equipped = ftr.equipment[itemInd];
	if (struct_exists(equipped, "pResist")){
		ftr.resistances.str -= equipped.pResist;	
	}
	if (struct_exists(equipped, "hpBonus")){
		ftr.hp -= equipped.hpBonus;
		ftr.stats.maxhp -= equipped.hpBonus;	
	}
	if (struct_exists(equipped, "pResist")){
		ftr.resistances.str -= equipped.pResist;	
	}
	if (struct_exists(equipped, "strBonus")){
		ftr.stats.str -= equipped.strBonus;	
	}
	array_delete(ftr.equipment, itemInd, 1);
	if (objInventoryMenu.open){
		objInventoryMenu.refreshMenu();	
	}
}