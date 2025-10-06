if (global.debug){
	draw_set_color(c_red);
	for(var _col = 0; _col * TILE_SIZE <= room_height; ++_col){
		draw_line_width(0, _col * TILE_SIZE, room_width, _col * TILE_SIZE, 2);
	}
	for(var _row = 0; _row * TILE_SIZE <= room_width; ++_row){
		draw_line_width(_row * TILE_SIZE, 0, _row * TILE_SIZE, room_height, 2);
	}
	draw_set_color(c_white);
}