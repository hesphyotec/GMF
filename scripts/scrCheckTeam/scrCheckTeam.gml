function scrCheckTeam(team, char){
	for(var i = 0; i < array_length(team); ++i){
		if (team[i][$"cid"] == char[$"cid"]){
			return true;
		}
	}
	return false;
}