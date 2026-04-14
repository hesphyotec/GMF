// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function createDamageNumber(actor, tar, dmg){
	var num = instance_create_layer(actor.x, actor.y, "Effects", objDmgNumber);
	var redStr = (clamp((dmg / tar.stats.maxhp) * 4, 0, 1)) * 255;
	var size = clamp((dmg / (tar.stats.maxhp / 8)), 1, 5);
	var rot = random_range(-2, 2);
	var spd = random_range(-2,2);
	num.number = dmg;
	num.color = make_colour_rgb(redStr, 0, 0);
	num.rotSpd = rot;
	num.size = size;
	num.spd = spd;
	num.bounceOffset = sprite_get_height(actor.sprite_index)/2;
}