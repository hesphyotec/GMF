// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function conAppEffects(ftr, spEffs, tar){
	var effData = global.data.effects;
	for (var i = 0; i < array_length(spEffs); ++i){
		if (variable_struct_exists(effData[$"buffs"], spEffs[i])){
			var buff = variable_clone(struct_get(effData[$"buffs"], spEffs[i]));
			if (DEBUG_ENABLED) serverLog("[BController] Retrieved Buff: " + string(struct_get(effData[$"buffs"], spEffs[i])) + " : " + spEffs[i]);
			if(scrCheckEffects(tar[$"buffs"], buff)){
				array_delete(tar[$"buffs"], array_get_index(tar[$"buffs"], buff), 1);
			}
			buff.duration *= fps;
			array_push(tar[$"buffs"], buff);
			var actor = objBattleMenu.getActor(tar);
			for(var j = 0; j < array_length(actor.effIcons); ++j){
				if (instance_exists(actor.effIcons[j])){
					if (actor.effIcons[j].effect == buff){
						instance_destroy(actor.effIcons[j]);
						array_delete(actor.effIcons, j, 1);
					}
				}
			}
			var icoX = actor.x - 16 + 12 * (array_get_index(tar.buffs, buff));
			var icoY = actor.y - 16 - (sprite_get_width(actor.sprite_index));
			if (scrCheckTeam(objBattleController.battleInfo.team2, tar)){
				icoY =  actor.y + 16;
			}
			var buffIco = instance_create_layer(icoX , icoY, "effects", objEffectIco);
			buffIco.effect = buff;
			buffIco.sprite_index = asset_get_index(buff.icon);
			array_push(actor.effIcons, buffIco);
			if (DEBUG_ENABLED) serverLog("[BController] Applied Buff: " + spEffs[i]);
			
			if(buff.abil == "tempAttack"){
				array_insert(ftr.attacks, 0, buff.type);	
			}
		} else if (variable_struct_exists(effData[$"debuffs"], spEffs[i])){
			var debuff = variable_clone(struct_get(effData[$"debuffs"], spEffs[i]));
			if(scrCheckEffects(tar[$"debuffs"], debuff)){
				array_delete(tar[$"debuffs"], array_get_index(tar[$"debuffs"], debuff), 1);
			}
			debuff.duration *= fps;
			debuff.source = ftr;
			var actor = objBattleMenu.getActor(tar);
			for(var j = 0; j < array_length(actor.effIcons); ++j){
				if (instance_exists(actor.effIcons[j])){
					if (actor.effIcons[j].effect == debuff){
						instance_destroy(actor.effIcons[j]);
						array_delete(actor.effIcons, j, 1);
					}
				}
			}
			var icoX = actor.x - 16 + 12 * (array_get_index(tar.debuffs, debuff));
			var icoY = actor.y - 8 - (sprite_get_width(actor.sprite_index));
			if (scrCheckTeam(objBattleController.battleInfo.team2, tar)){
				icoY =  actor.y + 24;
			}
			var debuffIco = instance_create_layer(icoX, icoY, "effects", objEffectIco);
			debuffIco.effect = debuff;
			debuffIco.sprite_index = asset_get_index(debuff.icon);
			array_push(tar[$"debuffs"], debuff);
			if(debuff.abil == "stun"){
				actor.startTimer(1);
			}
			array_push(actor.effIcons, debuffIco);
		}
	}
}