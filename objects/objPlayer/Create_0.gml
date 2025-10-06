if (room == rmTest){
	character = instance_create_layer(0,0,"Instances",objOWPlayer);
}
battlePlayer = {
	name : "Player",
	hp : 100,
	mana : 100,
	stats : {
		maxhp : 100,
		maxmana : 100,
		str : 5,
		dex : 5,
		cspd : 5,
		int : 5
	},
	attacks : ["slash"],
	spells : ["lightning", "devsmite"],
	buffs : [],
	debuffs : [],
	sprite : "sprBattlePlayerT",
	splash : "sprHumanPlayerSplash"
};

loadCompanion = function(comp){
	var compData = struct_get(global.data.companions, comp);
	var companion = {
		name	: compData[$"name"],
		hp		: compData[$"hp"],
		mana	: compData[$"mana"],
		stats	: compData[$"stats"],
		attacks : compData[$"attacks"],
		spells	: compData[$"spells"],
		buffs	: [],
		debuffs : [],
		sprite	: compData[$"sprite"],
		splash	: compData[$"splash"]
	}
	return companion;
}

team = [battlePlayer, loadCompanion("veteran"), loadCompanion("healer"), loadCompanion("archer")];

