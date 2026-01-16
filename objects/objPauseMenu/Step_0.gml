scrGetInput();

if (!open){
	if(escPress){
		openMenu();	
	}
}
if(open){	
	if ((bg.tweenX == bg.targetX) && opening){
		active = true;
		opening = false;
	}
	if ((bg.tweenX == bg.targetX) && closing){
		open = false;
		closing = false;
		instance_destroy(bg);
	}
	if (active){
		// Menu stuff here
		if(escPress && !opening){
			closeMenu();	
		}
	}
}
