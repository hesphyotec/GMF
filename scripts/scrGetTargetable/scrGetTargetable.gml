// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scrGetTargetable(team){
	var targetable = [];
	for(var i = 0; i < array_length(team); ++i){
		var ftr = team[i];
		var canTar = true;
		for (var j = array_length(ftr[$"buffs"])-1; j >= 0; --j){
			var buff = ftr[$"buffs"][j];
			if (buff[$"abil"] == "stealth"){
				canTar = false;
			}
		}
		if (ftr[$"hp"] <= 0){
			canTar = false;	
		}
		if (canTar){
			array_push(targetable, ftr);	
		}
	}
	return targetable;
}