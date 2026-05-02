// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function giveExp(team, ftr, xp){
	var msg = [(ftr.name) + " got " + string(xp) + " exp."];
	var ftrInd = scrTeamCharGetInd(team, ftr);
	team[ftrInd].exp += xp;
	if (team[ftrInd].exp >= team[ftrInd].expCap){
		var newSpell = levelUp(team[ftrInd]);
		team[ftrInd].exp -= team[ftrInd].expCap;
		array_push(msg, (ftr.name + " has reached level " + string(ftr.level) + "!"));
		if (newSpell != undefined){
			var spellName = struct_get(global.data.moves.spells, newSpell).name;
			array_push(msg, (ftr.name + " learned " + spellName + "!"));
		}
	}
	return msg;
}