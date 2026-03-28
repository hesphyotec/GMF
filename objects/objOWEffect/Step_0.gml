if (follow){
	x = follow.x;
	y = follow.y
}

if (fade){
	if (fadeIn){
		screenInfo.a = lerp(screenInfo.a, 1, screenInfo.fadeAMT);
	} else {
		screenInfo.a = lerp(screenInfo.a, 0, screenInfo.fadeAMT);
		if (screenInfo.a <= 0.05){
			instance_destroy(id);	
		}
	}
}