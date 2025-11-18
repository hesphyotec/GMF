enum MAP {
	EMPTY,
	WALL,
	PLAYER,
	NPC,
}

getRoomMap = function(){
	var genMap = {
		layout : ds_grid_create(0,0),
		width : 0,
		height : 0
	}
	genMap.width = floor(room_width / TILE_SIZE);
	genMap.height = floor(room_height / TILE_SIZE);
	genMap.layout = ds_grid_create(genMap.width+1, genMap.height+1);
	ds_grid_clear(global.map.layout, MAP.EMPTY);
	with(objWall){
		var gX = floor(x / TILE_SIZE);
		var gY = floor(y / TILE_SIZE);
		genMap.layout[# gX, gY] = MAP.WALL;
	}
	with(objNPC){
		var gX = floor(x / TILE_SIZE);
		var gY = floor(y / TILE_SIZE);
		genMap.layout[# gX, gY] = MAP.NPC;
	}
	saveMap(genMap);
	return genMap;
}

saveMap = function(map){
	var file = file_text_open_write(working_directory + "testmap.txt");
	file_text_write_real(file, map.width);
	file_text_write_real(file, map.height);
	for(var xx = 0; xx < map.width; ++xx){
		for(var yy = 0; yy < map.height; ++yy){
			var tile = map.layout[# xx, yy];
			file_text_write_real(file, tile);
		}
		file_text_writeln(file);
	}
	file_text_close(file);	
}