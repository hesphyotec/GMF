function scrStartBattle(rm, playerTeam, enemy){
	show_debug_message("Starting battle with player: " + string(playerTeam));
	show_debug_message("Starting battle with enemy: " + string(enemy));
    array_insert(global.battles, 0, [playerTeam, enemy]);
    show_debug_message("Battles queued: " + string(array_length(global.battles)));
	room_goto(rmBattle);
}