x += spd;
spd = lerp(spd, 0, .05);

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

rot += rotSpd;
rotSpd = lerp(rotSpd, 0, .1);
if (ySpd == 0 && spd < 0.05 && bounceOffset <= 0.5){
	instance_destroy(id);	
}