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
	with(objOWPlayer){
		show_message("Creating companion!");
		var compChar = instance_create_layer(x, y, "World_Objects", objCompanion);
		compChar.baseSpriteName = companion.owSprite;
		compChar.sprite_index = asset_get_index(companion.owSprite + "Down");
		array_push(companions, compChar);
	}
	scrNetAddComp(global.server, comp);
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

pickupItem = function(item){
	var inv = global.playerData[0].inventory;
	
	var prevLen = array_length(inv);
	array_push(inv, item);
	if (objInventoryMenu.open){
		objInventoryMenu.refreshMenu();
	}
	//if (array_length(inv) != prevLen) {
	//	var mult = ceil(array_length(inv) / 8);
	//	array_resize(inv, 8 * mult);	
	//}
}

equipItem = function(item, ind){
	audio_play_sound(sndGet, 1, false, global.effVolume);
	var ftr = team[ind];
	if (array_length(ftr.equipment) < ftr.stats.equipMax){
		var equipped = item;
		array_push(ftr.equipment, equipped);
		if (struct_exists(equipped, "strResist")){
			ftr.resistances.str += equipped.strResist;	
		}
		if (struct_exists(equipped, "dexResist")){
			ftr.resistances.dex += equipped.dexResist;	
		}
		if (struct_exists(equipped, "intResist")){
			ftr.resistances.int += equipped.intResist;	
		}
		if (struct_exists(equipped, "hpBonus")){
			ftr.hp += equipped.hpBonus;
			ftr.stats.maxhp += equipped.hpBonus;	
		}
		if (struct_exists(equipped, "strBonus")){
			ftr.stats.str += equipped.strBonus;	
		}
		if (struct_exists(equipped, "dexBonus")){
			ftr.stats.dex += equipped.dexBonus;	
		}
		if (struct_exists(equipped, "intBonus")){
			ftr.stats.int += equipped.intBonus;	
		}
		if (struct_exists(equipped, "attack")){
			array_insert(ftr.attacks, 0, equipped.attack);
		}
		if (struct_exists(equipped, "spell")){
			array_insert(ftr.spells, 0, equipped.spell);
		}
		if (struct_exists(equipped, "spdBonus")){
			ftr.stats.cspd += equipped.spdBonus;	
		}
		if (struct_exists(equipped, "buff")){
			array_push(ftr.buffs, equipped.buff);
		}
		if (struct_exists(equipped, "debuff")){
			array_push(ftr.debuffs, equipped.debuff);
		}
		if (objInventoryMenu.open){
			objInventoryMenu.refreshMenu();	
		}
		return true;
	}
	return false;
}

unequipItem = function(charInd, itemInd){
	audio_play_sound(sndBack, 1, false, global.effVolume);
	var ftr = team[charInd];
	var equipped = ftr.equipment[itemInd];
	if (struct_exists(equipped, "strResist")){
		ftr.resistances.str -= equipped.strResist;	
	}
	if (struct_exists(equipped, "dexResist")){
		ftr.resistances.dex -= equipped.dexResist;	
	}
	if (struct_exists(equipped, "intResist")){
		ftr.resistances.int -= equipped.intResist;	
	}
	if (struct_exists(equipped, "strBonus")){
		ftr.stats.str -= equipped.strBonus;	
	}
	if (struct_exists(equipped, "dexBonus")){
		ftr.stats.dex -= equipped.dexBonus;	
	}
	if (struct_exists(equipped, "intBonus")){
		ftr.stats.int -= equipped.intBonus;	
	}
	if (struct_exists(equipped, "spdBonus")){
		ftr.stats.cspd -= equipped.spdBonus;	
	}
	if (struct_exists(equipped, "hpBonus")){
		ftr.hp -= equipped.hpBonus;
		ftr.stats.maxhp -= equipped.hpBonus;	
	}
	if (struct_exists(equipped, "attack")){
		array_delete(ftr.attacks, array_get_index(ftr.attacks, equipped.attack), 1);
	}
	if (struct_exists(equipped, "spell")){
		array_delete(ftr.spells, array_get_index(ftr.spells, equipped.spell), 1);
	}
	//if (struct_exists(equipped, "buff")){
	//	array_delete(ftr.attacks, array_get_index(ftr.attacks, equipped.attack), 1);
	//}
	array_delete(ftr.equipment, itemInd, 1);
	if (objInventoryMenu.open){
		objInventoryMenu.refreshMenu();	
	}
}

getCompanionChars = function(){
	var comps = [];
	for(var i = 1; i < array_length(team); ++i){
		var compChar = instance_create_layer(objOWPlayer.x, objOWPlayer.y, "World_Objects", objCompanion);
		compChar.baseSpriteName = team[i].owSprite;
		compChar.sprite_index = asset_get_index(team[i].owSprite + "Down");
		array_push(comps, compChar);
	}
	return comps;
}