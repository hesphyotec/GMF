scrGetInput();
if (sprint){
	spd = 4;	
} else {
	spd = 2;	
}

if (global.server >= 0){
	if ((up || left || right || down ) && !moving){
		scrSendKey(global.server, up, down, left, right);
	}
}

if (!inMenu){
	playerMove();
	playerInteract();
}
