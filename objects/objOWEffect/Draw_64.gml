if (isScreen){
	draw_set_colour(screenInfo.col);
	draw_set_alpha(screenInfo.a);
	draw_rectangle(screenInfo.X, screenInfo.Y, screenInfo.W, screenInfo.H, false);
	drawReset();
}