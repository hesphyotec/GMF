x += spd;
spd = lerp(spd, 0, .05);
aSize = lerp(aSize, size, .5);

rot += rotSpd;
rotSpd = lerp(rotSpd, 0, .1);
	
if (!float){
	ySpd += grav;
	bounceOffset -= ySpd;

	if (bounceOffset <= 0){
		bounceOffset = 0;
	
		if (ySpd > .5) {
			ySpd = -ySpd * bDamp;	
		} else {
			ySpd = 0;
		}
	}

	if (ySpd == 0 && spd < 0.05 && bounceOffset <= 0.5){
		instance_destroy(id);	
	}
} else {
	ySpd = lerp(ySpd, 0, grav);
	bounceOffset -= ySpd;
}