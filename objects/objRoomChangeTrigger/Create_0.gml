roomTarget = rmHCastleTest;
active = true;

changeRoom = function(){
	if (active){
		savePos();
		room_goto(roomTarget);	
	} 
}