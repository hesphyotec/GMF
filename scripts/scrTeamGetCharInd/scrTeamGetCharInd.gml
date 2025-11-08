function scrTeamCharGetInd(team, char){
	for(var i = 0; i < array_length(team); ++i){
		if (team[i][$"cid"] == char[$"cid"]){
			return i;
		}
	}
	return -1;
}