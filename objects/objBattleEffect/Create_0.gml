sprite_index = noone;
image_speed = .5;
lifespan = 0;
target = undefined;
menuRef = undefined;
actData = undefined

initEff = function(act, spr, tar, men, spd, onTarget){
	sprite_index = spr;
	image_index = 0;
	image_speed = spd;
	target = tar;
	menuRef = men;
	actData = act;
	
	if(onTarget){
		x = target.x;
		y = target.y - sprite_get_height(target.sprite_index)/2;
	}
	
	//layer = "Effects";
}