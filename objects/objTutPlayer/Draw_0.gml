/// @description Insert description here
// You can write your code in this editor
var distRatio =  clamp(1 - ((y - distForTransform) / startDist), 0, 1);

if(!transformDone){
	twoSprites(sprite_index, sprPlayerChild, distRatio, x, y);
} else {
	draw_self();	
}
