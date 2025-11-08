// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scrGetEffect(effList, eff){
	for(var i = 0; i < array_length(effList); ++i){
			if (effList[i][$"name"] == eff[$"name"]){
				return i;	
			}
		}
		return -1;
}