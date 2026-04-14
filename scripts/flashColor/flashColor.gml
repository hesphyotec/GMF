// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function flashColor(color, spd){
	if (!variable_instance_exists(id, "shdFlashAmt")){
		shdFlashAmt = 1;
		shdActive = true;
	}
	shader_set(shdSolidColor);
	var amt = shader_get_uniform(shdSolidColor, "amount");
	shdFlashAmt = lerp(shdFlashAmt, 0, spd);
	shader_set_uniform_f(amt, shdFlashAmt);
	draw_set_colour(color);
	shakeSprite(spd, spd);
	drawReset();
	shader_reset();
	if (shdFlashAmt <= 0.05){
		shdFlashAmt = 0;
		shdActive = false;
		if (variable_instance_exists(id, "dmgFlash")){
			dmgFlash = false;
		}
	}
}