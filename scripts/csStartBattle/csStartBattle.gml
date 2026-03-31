// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function csStartBattle(enemy){
	scrStartBattle(room, global.players[0].team, enemy);
	csEndAction();
}