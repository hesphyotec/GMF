// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function shakeSprite(str, spd){
	var offset = str * sin(current_time/1000 * spd);
	draw_sprite(sprite_index, image_index, x + offset, y);
}