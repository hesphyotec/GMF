scrGetInput();
isHovered();
if (hovered){
	onHover();
	if (mouse_check_button_pressed(mb_left)){
		onClick();	
	}
}
tweenY = lerp(tweenY, targetY, .5);