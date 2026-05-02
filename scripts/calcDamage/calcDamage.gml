// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function calcDamage(ftr, target, action, str = 1){
	if (DEBUG_ENABLED) show_debug_message("[BController] " + string(ftr[$"stats"]) + " : " + action[$"scale"]);
	var dmgMult = ceil(struct_get(ftr[$"stats"], action[$"scale"])/5);
	var resistMult = 1.0;
	var tarResMult = struct_get(target[$"resistances"], action[$"scale"]);
	var bonusMult = 0.0;
	if (struct_exists(target, "buffs") && struct_exists(target, "debuffs")){
		if (array_length(target[$"buffs"]) > 0){
			for (var i = 0; i < array_length(target[$"buffs"]); ++i){
				var buffData = target[$"buffs"][i];
				if (buffData.abil == "block"){
					if(struct_exists(action, "damage")){
						array_delete(target.buffs, i, 1);
						var actor = objBattleMenu.getActor(target);
						for(var j = 0; j < array_length(actor.effIcons); ++j){
							if (instance_exists(actor.effIcons[j])){
								if (actor.effIcons[j].effect == buffData){
									instance_destroy(actor.effIcons[j]);
									array_delete(actor.effIcons, j, 1);
								}
							}
						}
						dmgMult = 0.0;
					}
				}
				if (struct_exists(buffData, "abil") && struct_exists(buffData, "pow") && struct_exists(buffData, "type")){
					if (buffData[$"abil"] == "resist"){
						if (buffData[$"type"] == action[$"scale"]){
							bonusMult += buffData[$"pow"];
						}
					}
				} else {
					if (DEBUG_ENABLED) show_debug_message("[BController] Error: Malformed Buff Struct!");	
				}
			}
		}
		if (array_length(target[$"debuffs"]) > 0){
			for (var i = 0; i < array_length(target[$"debuffs"]); ++i){
				var debuffData = target[$"debuffs"][i];
				if (struct_exists(debuffData, "abil") && struct_exists(debuffData, "pow") && struct_exists(debuffData, "type")){
					if (debuffData[$"abil"] == "weakness"){
						if (debuffData[$"type"] == action[$"scale"]){
							bonusMult -= debuffData[$"pow"];
						}
					}
				} else {
					if (DEBUG_ENABLED) show_debug_message("[BController] Error: Malformed Debuff Struct!");	
				}
			}
		}
	}
	resistMult = 1.0 - (tarResMult + bonusMult);
	if (DEBUG_ENABLED) show_debug_message("[BController] " +string(action[$"damage"]) + " : " + string(dmgMult) + " : " + string(resistMult) + " : " + string(action));
	var dmg = 0;
	
	if(struct_exists(action, "damage")){
		dmg = max(ceil((action[$"damage"] * dmgMult) * (resistMult) * str), 0);
	} else if (struct_exists(action, "pow")){
		dmg = max(ceil((action[$"pow"] * dmgMult) * (resistMult) * str), 0);
	}
	
	if (scrCheckEffects(ftr.debuffs, global.data.effects.debuffs.dmgLink)){
		var tempFtr = variable_clone(ftr);
		tempFtr.debuffs = [];
		objBattleController.doDamage(tempFtr, ftr, action, .25);
	}
	
	for (var i = 0; i < array_length(ftr.buffs); ++i){
		var buff = ftr.buffs[i];
		if (buff.abil == "critNext"){
			dmg *= 2;	
		}
		array_delete(ftr.buffs, scrGetEffect(ftr.buffs, buff), 1);
	}
	
	return dmg;
}