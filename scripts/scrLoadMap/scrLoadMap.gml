// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scrLoadMap(mapName){
	if (DEBUG_ENABLED) show_message("Loading Map " + mapName);
	var file = file_text_open_read(working_directory + mapName);
	if (DEBUG_ENABLED) show_message("Loading Map " + string(file));
	var map = {
		layout : undefined,
		width : 0,
		height : 0,
	}
	map.width = file_text_read_real(file);
	map.height = file_text_read_real(file);
	map.layout = ds_grid_create(map.width, map.height);
	for(var xx = 0; xx < map.width; ++xx){
		for(var yy = 0; yy < map.height; ++yy){
			map.layout[# xx, yy] = file_text_read_real(file);	
		}
	}
	if (DEBUG_ENABLED) show_message("Map loaded." + string(map.width) + string(map.height));
	return map;
}