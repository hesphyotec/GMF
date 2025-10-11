if (room == rmTest){
	character = instance_create_layer(0,0,"Instances",objOWPlayer);
}
battlePlayer = {
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
	attacks	: ["slash"],
	spells	: ["lightning", "devsmite", "meditate"],
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

team = [battlePlayer, loadCompanion("veteran"), loadCompanion("healer"), loadCompanion("archer")];

