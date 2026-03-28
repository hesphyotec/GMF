// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function twoSprites(sprite1, sprite2, ratio, xx, yy){
	shader_set(shdTwoSprite);
	
	var shdSprite = shader_get_sampler_index(shdTwoSprite, "sprite2");
	var shdRatio = shader_get_uniform(shdTwoSprite, "ratio");
	
	texture_set_stage(shdSprite, sprite_get_texture(sprite2, image_index));
	shader_set_uniform_f(shdRatio, ratio);
	
	draw_sprite(sprite1, image_index, xx, yy);
	shader_reset();
}