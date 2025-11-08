if (character[$"hp"] > 0){
	var hp = character[$"hp"];
	
	var total_wait = (6 / character[$"stats"][$"cspd"]) * 400;
	var ratio = 1 - clamp(timers.wait / total_wait, 0, 1); // 1 = ready, 0 = just acted
	//var bar_w = sprite_width / 2;
	//var bar_x1 = x - (sprite_width / 2);
	//var bar_x2 = bar_x1 + (bar_w * ratio);
	//draw_rectangle(bar_x1, y - 40, bar_x2, y - 48, false);
	var wcRad = 32;
	var wcThick = 3;
	var wcAngStart = 1;
	var wcAngEnd = (ratio * 360);
	var wcColor = c_white;
	if (ratio == 1) wcColor = c_yellow;
	if (state = CHARSTATES.STUNNED) wcColor = c_aqua;
	scrDrawArc(x, y, ratio, 1, wcColor, wcRad, 1, .4, -15, wcThick);
	
	var hpRatio = clamp(hp / character.stats[$"maxhp"], 0, 1);
	var hpRad = 22;
	var hpCol = c_red;
	scrDrawArc(x, y, hpRatio, 1, hpCol, hpRad, 1, .4, -15, 8);
	
	if(struct_exists(character, "mana")){
		var manaRatio = clamp(character[$"mana"] / character.stats[$"maxmana"], 0, 1);
		var manaRad = 16;
		var manaCol = c_aqua;
		scrDrawArc(x, y, manaRatio, 1, manaCol, manaRad, 1, .4, -15, 4);
	}
	
	if(struct_exists(character, "energy") && struct_exists(character.stats, "maxenergy")){
		var energyRatio = clamp(character[$"energy"] / character.stats[$"maxenergy"], 0, 1);
		var energyRad = 16;
		var energyCol = c_yellow;
		var maxEnergy = character.stats[$"maxenergy"];
		var energy = character[$"energy"];
		for(var i = energy - 1; i >= 0; --i){
			var segStart = (360 / maxEnergy) - 10;
			var segRot = ((360 / maxEnergy) * i);
			scrDrawArc(x, y, segStart, 360, energyCol, energyRad, 1, .4, segRot, 4);
		}
	}
	
	var stunRatio = clamp(timers.stun / maxStun, 0, 1);
	var stunRad = 36;
	var stunCol = c_purple;
	scrDrawArc(x, y, stunRatio, 1, stunCol, stunRad, 1, .4, -15, 2);
	
	
	draw_sprite(sprite_index, image_index, x , y + yOff);
	//draw_set_color(c_red);
	//draw_rectangle(x, y - 8, x + (16 * hp/character[$"stats"][$"maxhp"]), y - 12, false);
	//draw_set_color(c_white);
	draw_set_font(fntHP);
	if (!isPlayerTeam){
		//draw_text(x-hpTextOffX, y-sprite_get_height(sprite_index), string(hp) + " / " + string(character[$"stats"][$"maxhp"]));
	} else {
		//draw_text(x-hpTextOffX, y+playerhpTextOffY, string(hp) + " / " + string(character[$"stats"][$"maxhp"]));		
	}
	draw_set_font(fntBattle);
	
	for(var i = 0; i < array_length(character[$"debuffs"]); ++i){
		var debuffIco = scrGetEffIco(character[$"debuffs"][i]);
		draw_sprite(debuffIco, 0, x - effOffX + (effSpace * i), y - sprite_get_height(sprite_index) - dbOffY);
	}
	
	for(var i = 0; i < array_length(character[$"buffs"]); ++i){
		var buffIco = scrGetEffIco(character[$"buffs"][i]);
		draw_sprite(buffIco, 0, x - effOffX + (effSpace * i), y - sprite_get_height(sprite_index) - bOffY);
	}
}




