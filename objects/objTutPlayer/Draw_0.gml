/// @description Insert description here
// You can write your code in this editor
var distRatio =  clamp(1 - ((y - distForTransform) / startDist), 0, 1);

if(!transformDone){
	twoSprites(sprTutPlayerSpirit, sprite_index, distRatio, x, y);
} else {
	draw_self();	
}
