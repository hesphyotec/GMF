draw_self();

draw_set_colour(c_red);
switch(dir){
		case(Dirs.UP):
			draw_rectangle(x - rangeSide / 2, y - rangeDist, x + rangeSide / 2, y, true);
			break;
		case(Dirs.LEFT):
			draw_rectangle(x - rangeDist, y - rangeSide / 2, x, y + rangeSide / 2, true);
			break;
		case(Dirs.RIGHT):
			draw_rectangle(x, y - rangeSide / 2, x + rangeDist , y + rangeSide / 2, true);
			break;
		case(Dirs.DOWN):
			draw_rectangle(x - rangeSide / 2, y, x + rangeSide / 2, y + rangeDist, true);
			break;
	}
drawReset();