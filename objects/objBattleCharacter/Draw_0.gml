if (character[$"hp"] > 0){
	var hp = character[$"hp"];
	draw_sprite(sprite_index, image_index, x , y + yOff);
	//draw_set_color(c_red);
	//draw_rectangle(x, y - 8, x + (16 * hp/character[$"stats"][$"maxhp"]), y - 12, false);
	//draw_set_color(c_white);
	draw_set_font(fntHP);
	if (!isPlayerTeam){
		draw_text(x-hpTextOffX, y-sprite_get_height(sprite_index), string(hp) + " / " + string(character[$"stats"][$"maxhp"]));
	} else {
		draw_text(x-hpTextOffX, y+playerhpTextOffY, string(hp) + " / " + string(character[$"stats"][$"maxhp"]));		
	}
	draw_set_font(fntBattle);
	
	for(var i = 0; i < array_length(character[$"debuffs"]); ++i){
		var debuffIco = scrStrToIco(character[$"debuffs"][i]);
		draw_sprite(debuffIco, 0, x - effOffX + (effSpace * i), y - sprite_get_height(sprite_index) - dbOffY);
	}
	
	for(var i = 0; i < array_length(character[$"buffs"]); ++i){
		var buffIco = scrStrToIco(character[$"buffs"][i]);
		draw_sprite(buffIco, 0, x - effOffX + (effSpace * i), y - sprite_get_height(sprite_index) - bOffY);
	}
}

