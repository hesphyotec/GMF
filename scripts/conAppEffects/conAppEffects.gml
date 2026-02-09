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
			if (DEBUG_ENABLED) serverLog("[BController] Applied Buff: " + spEffs[i]);
		} else if (variable_struct_exists(effData[$"debuffs"], spEffs[i])){
			var debuff = variable_clone(struct_get(effData[$"debuffs"], spEffs[i]));
			if(scrCheckEffects(tar[$"debuffs"], debuff)){
				array_delete(tar[$"debuffs"], array_get_index(tar[$"debuffs"], debuff), 1);
			}
			debuff.duration *= fps;
			debuff.source = ftr;
			array_push(tar[$"debuffs"], debuff);
		}
	}
}