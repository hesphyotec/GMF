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

if (lClickRelease){
	with (objMenuComponent){
		active = true;
	}
}
// TODO: make these variable based upon tweenspeed
tweenX = lerp(tweenX, targetX, tweenSpeed);
if (abs(tweenX - targetX) < .01) tweenX = targetX;
tweenY = lerp(tweenY, targetY, tweenSpeed);
if (abs(tweenY - targetY) < .01) tweenY = targetY;

if (parent != undefined){
	if (type == GUI.HOVERINFO){
		try{
			if (!parent.hovered){
				instance_destroy(id);	
			}
		} catch (e) {
			instance_destroy(id);
		}
	}
}

if (type == GUI.INVDRAGBOX || type == GUI.BACKPACKINVBOX){
	if (!is_struct(data.item)){
		data.item = undefined;	
	}
}

onStep();