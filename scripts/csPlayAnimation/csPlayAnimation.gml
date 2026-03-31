// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function csPlayAnimation(obj, sprite, loop){
	if (!animPlaying){
		animPlaying = true;
		obj.sprite_index = sprite;
		obj.image_index = 0;
		obj.image_speed = 1;
	}
	if (!loop){
		if (obj.image_index >= sprite_get_number(sprite) -1){
			animPlaying = false;
			csEndAction();
		}
	} else {
		animPlaying = false;
		csEndAction();	
	}
}