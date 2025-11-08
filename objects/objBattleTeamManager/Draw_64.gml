if (DEBUG_ENABLED){
	if(playerTeam){
		for (var i = 0; i < array_length(activeTeamQueue); ++i){
			draw_text(0, 48 + 16*i, activeTeamQueue[i][$"name"]);	
		}
		for (var i = 0; i < array_length(waiting); ++i){
			draw_text(0, 128 + 16*i, waiting[i][$"name"]);	
		}
	}
}