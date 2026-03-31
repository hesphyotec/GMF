if (isScreen){
	draw_set_colour(screenInfo.col);
	draw_set_alpha(screenInfo.a);
	draw_rectangle(screenInfo.X, screenInfo.Y, screenInfo.W, screenInfo.H, false);
	draw_sprite_stretched(sprite_index, image_index, 0, 0, display_get_gui_width(), display_get_gui_height());
	drawReset();
}