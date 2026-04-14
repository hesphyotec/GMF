// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function sEffectInitialize(){
	effects = [];
}

function effFlash(str, col, dec) constructor{
	type = "flash";
	strength = str;
	color = col;
	decay = dec;
}

function sEffectStep(){
	for(var i = array_length(effects) - 1; i >= 0; --i){
		var eff = effects[i];
		
		if (eff.type == "flash"){
			eff.strength = lerp(eff.strength, 0, eff.decay);
			if (eff.strength <= 0.05){
				array_delete(effects, i, 1);	
			}
		}
		
		if (eff.type == "shake"){
			eff.xStrength = lerp(eff.xStrength, 0, eff.decay);
			eff.yStrength = lerp(eff.yStrength, 0, eff.decay);
			if (eff.xStrength <= 0.05 && eff.yStrength <= 0.05){
				array_delete(effects, i, 1);	
			}
		}
	}
}
//function effShake(str, spd, d

function sEffectDraw(){
	var drawColor = c_white;
	var xOff = 0;
	var yOff = 0;
	for(var i = array_length(effects) - 1; i >= 0; --i){
		var eff = effects[i];
		
		if (eff.type == "outline"){
			var outlineColor = eff.color;
			shader_set(shdSolidColor);
			var amt = shader_get_uniform(shdSolidColor, "amount");
			shader_set_uniform_f(amt, 1.0);
			draw_sprite_ext(sprite_index, image_index, x - eff.width, y, 1, 1, 0, outlineColor, 1);
			draw_sprite_ext(sprite_index, image_index, x + eff.width, y, 1, 1, 0, outlineColor, 1);
			draw_sprite_ext(sprite_index, image_index, x, y - eff.width, 1, 1, 0, outlineColor, 1);
			draw_sprite_ext(sprite_index, image_index, x, y - eff.width, 1, 1, 0, outlineColor, 1);
			shader_reset();
		}
		if (eff.type == "flash"){
			shader_set(shdSolidColor);
			var amt = shader_get_uniform(shdSolidColor, "amount");
			shader_set_uniform_f(amt, eff.strength);
			drawColor = eff.color;
		}
		if (eff.type == "shake"){
			xOff = random_range(-eff.xStrength, eff.xStrength);
			yOff = random_range(-eff.yStrength, eff.yStrength);
		}
	}
	draw_sprite_ext(sprite_index, image_index, x + xOff, y + yOff, 1, 1, 0, drawColor, 1);
	shader_reset();
}

function effOutline(w, col) constructor{
	type = "outline";
	width = w;
	color = col;
}

function effGlow(w, col, spd) constructor{
	type = "outline";
	width = w;
	color = col;
	gSpeed = spd;
}

function effShake(xStr, yStr, dec) constructor{
	type = "shake";
	xStrength = xStr;
	yStrength = yStr
	decay = dec;
}