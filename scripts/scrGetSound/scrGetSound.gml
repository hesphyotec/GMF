function scrGetSound(name){
	var sId = asset_get_index("snd"+string(name));
	if (sId < 0){
		sId = asset_get_index(name);	
	}
	return sId;
}