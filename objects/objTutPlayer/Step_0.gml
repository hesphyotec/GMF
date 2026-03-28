event_inherited();

var distRatio =  clamp(1 - ((y - distForTransform) / startDist), 0, 1);
if (distRatio == 1){
	transformDone = true;
	sprite_index = sprPlayerChild;
}