// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function giveExp(team, ftr, xp){
	var ftrInd = scrTeamCharGetInd(team, ftr);
	team[ftrInd].exp += xp;
	if (team[ftrInd].exp >= team[ftrInd].expCap){
		team[ftrInd].level++;
		team[ftrInd].exp -= team[ftrInd].expCap;
	}
}