// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function calcHeal(ftr, target, act){
	var heal = 0;
	if (struct_exists(act, "heal")){	//If is a spell
		heal = act[$"heal"] * (struct_get(ftr[$"stats"], act[$"scale"]) div 2);
	} else {		// If is an item
		heal = act[$"pow"];
	}
	return min(target.stats.maxhp, target.hp + heal);
}