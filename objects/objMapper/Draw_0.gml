for(var xx = 0; xx < global.map.width; ++xx){
	for(var yy = 0; yy < global.map.height; ++yy){
		draw_text(xx * TILE_SIZE, yy * TILE_SIZE, global.map.layout[# xx, yy]);	
		draw_text(xx * TILE_SIZE, yy * TILE_SIZE + 8, string(xx) + string(yy));	
	}
}