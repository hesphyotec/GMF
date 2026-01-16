scrGetInput();
isHovered();
if (hovered){
	onHover();
	if (mouse_check_button_pressed(mb_left)){
		onClick();
	}
	if (lClick){
		onHold();	
	}
}
// TODO: make these variable based upon tweenspeed
tweenX = lerp(tweenX, targetX, tweenSpeed);
if (abs(tweenX - targetX) < .5) tweenX = targetX;
tweenY = lerp(tweenY, targetY, tweenSpeed);
if (abs(tweenY - targetY) < .5) tweenY = targetY;