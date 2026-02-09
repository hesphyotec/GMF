draw_set_color(c_black);
draw_text(0, 16, string(mouse_x) + " : " + string(mouse_y));
draw_text(0, 32, string(mapSpace[0]) + " : " + string(mapSpace[1]));
draw_text(0, 48, global.isServer);
draw_set_color(c_white);
