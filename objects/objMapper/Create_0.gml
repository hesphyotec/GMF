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
		height : 0,
		rm : rmTest
	}
	genMap.layout = ds_grid_create(room_width div TILE_SIZE, room_height div TILE_SIZE);
	genMap.width = room_width div TILE_SIZE;
	genMap.height = room_height div TILE_SIZE;
	genMap.rm = room;
	ds_grid_clear(global.map.layout, MAP.EMPTY);
	with(objWall){
		var gX = x div TILE_SIZE;
		var gY = y div TILE_SIZE;
		genMap.layout[# gX, gY] = MAP.WALL;
	}
	with(objNPC){
		var gX = x div TILE_SIZE;
		var gY = y div TILE_SIZE;
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