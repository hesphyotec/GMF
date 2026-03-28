shader_set(shdBGWave);
var t = current_time / 1000;
var u_time = shader_get_uniform(shdBGWave, "time");
shader_set_uniform_f(u_time, t);
draw_set_alpha(.5)
draw_set_color(c_yellow);
draw_sprite(sprTCasBatBG, 0, 0, 0);
draw_set_color(c_white);
draw_set_alpha(1);
shader_reset();