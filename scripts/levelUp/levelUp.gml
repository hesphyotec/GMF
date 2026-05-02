// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function levelUp(fighter){
	fighter.level++;
	if (fighter.level - 1 < array_length(fighter.lvlRewards)){
		array_push(fighter.spells, fighter.lvlRewards[fighter.level - 1]);
		return fighter.lvlRewards[fighter.level - 1];
	}
	return undefined;
}