// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function createMissText(actor, tar){
	var num = instance_create_layer(actor.x, actor.y, "Effects", objDmgNumber);
	var size = 1.5;
	var rot = random_range(-2, 2);
	var spd = irandom_range(-1,1);
	if (spd == 0){
		spd = 1;	
	}
	num.number = "MISS";
	num.color = c_grey;
	num.rotSpd = rot;
	num.size = size;
	num.spd = spd;
	num.bounceOffset = sprite_get_height(actor.sprite_index)/2;
}