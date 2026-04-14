// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function createRestoreNumber(actor, tar, quant, col){
	var num = instance_create_layer(actor.x, actor.y, "Effects", objDmgNumber);
	var size = 1.5;
	var rot = random_range(-2, 2);
	var spd = random_range(-1,1);
	num.number = quant;
	num.color = col;
	num.rotSpd = rot;
	num.size = size;
	num.spd = spd;
	num.bounceOffset = sprite_get_height(actor.sprite_index)/2;
	num.float = true;
	num.grav = .1;
	num.alarm[0] = 1 * fps;
}