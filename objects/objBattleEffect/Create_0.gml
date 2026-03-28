sprite_index = noone;
image_speed = .5;
lifespan = 0;
target = undefined;
source = undefined;
menuRef = undefined;
actData = undefined;
srcToTar = false;

stretchX = 1;
stretchY = 1;
tarAngle = 0;

initEff = function(act, anim, tar, men, spd, onTarget, src = undefined){
	var spr = asset_get_index(anim.sprite);
	var cTC = anim.charToChar;
	sprite_index = spr;
	image_index = 0;
	image_speed = spd;
	target = tar;
	source = src;
	menuRef = men;
	actData = act;
	
	if(onTarget){
		x = target.x;
		y = target.y - sprite_get_height(target.sprite_index)/2;
	}
	if (cTC){
		x = source.x;
		y = source.y;
		srcToTar = true;
		attLength = point_distance(source.x, source.y, target.x, target.y - sprite_get_height(target.sprite_index)/2);
		tarAngle = point_direction(source.x, source.y, target.x, target.y - sprite_get_height(target.sprite_index)/2);
		stretchX = max(abs(lengthdir_x(attLength, tarAngle)) / sprite_get_width(sprite_index), 1);
		stretchY = abs(lengthdir_y(attLength, tarAngle)) / sprite_get_height(sprite_index);
	}
}