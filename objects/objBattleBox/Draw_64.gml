//draw_set_font(fntBattle);

//if (fighter != undefined && battleInfo.menuState != BMENUST.WAIT){
//	draw_sprite(sprCurrentCharBox, 0, 0, display_get_gui_height());
//	var maxTextW = sprite_get_width(sprCurrentCharBox);
//	draw_text_ext(actionBox.menuTextOffX, currNameTextY, fighter[$"name"], spacing, maxTextW);
//	draw_set_font(fntHP);
//	draw_text_ext(actionBox.menuTextOffX, currHPTextY, fighter[$"hp"], spacing, maxTextW);
//	if (struct_exists(fighter, "mana")){
//		draw_text_ext(actionBox.menuTextOffX, currHPTextY + 16, fighter[$"mana"], spacing, maxTextW);
//	}
//	if (struct_exists(fighter, "energy")){
//		draw_text_ext(actionBox.menuTextOffX, currHPTextY + 16, fighter[$"energy"], spacing, maxTextW);
//	}
//	draw_set_font(fntBattle);

//	var header = undefined;
//	switch(battleInfo.menuState){
//		case BMENUST.ACTION:
//			for (var i = 0; i < array_length(options); ++i){
//				var activeY = (i == selected) ? actionBox.activeY : actionBox.inactiveY;
//				draw_sprite(sprActionBox, 0, actionBox.X[i], activeY);
//				maxTextW = sprite_get_width(sprActionBox);
//				var textCol = (i == selected) ? c_yellow : c_white;
//				draw_set_color(textCol);
//				draw_text_ext(actionBox.X[i] + actionBox.menuTextOffX, activeY - actionBox.menuHeaderY, options[i], spacing, maxTextW);
//				draw_set_color(c_white);
//				if (i == selected){
//					switch(i){
//						case 0:
//							for (var j = 0; j < array_length(attacks); j++){
//								draw_text_ext(actionBox.X[i] + actionBox.menuTextOffX, activeY - actionBox.menuTextY + (actionBox.menuTextSpaceY * j), struct_get(attackData, attacks[j])[$"name"], spacing, maxTextW);	
//							}
//							break;
//						case 1:
//							for (var j = 0; j < array_length(spells); j++){
//								draw_text_ext(actionBox.X[i] + actionBox.menuTextOffX, activeY - actionBox.menuTextY + (actionBox.menuTextSpaceY * j), struct_get(spellData, spells[j])[$"name"], spacing, maxTextW);	
//							}
//							break;
//						case 2:
//							for (var j = 0; j < array_length(battleInfo.inventory); j++){
//								draw_text_ext(actionBox.X[i] + actionBox.menuTextOffX, activeY - actionBox.menuTextY + (actionBox.menuTextSpaceY * j), battleInfo.inventory[j][$"name"], spacing, maxTextW);	
//							}
//							break;
//					}
//				}
//			}
//			break;
//		case BMENUST.ATTACK:
//			header ??= "ATTACK";
//			if (header == "ATTACK"){
//				var atk = struct_get(attackData, attacks[selected]);
//				draw_sprite(sprInfoBox, 0, infoBoxX, actionBox.activeY);
//				var infoMaxW = sprite_get_width(sprInfoBox);
//				draw_text_ext(infoBoxX + actionBox.menuTextOffX, actionBox.activeY - actionBox.menuHeaderY, options[selected], spacing, infoMaxW);
//				draw_text_ext(infoBoxX + actionBox.menuTextOffX, actionBox.activeY - actionBox.menuTextY + (actionBox.menuTextSpaceY * 0), "Type: " + string(atk[$"scale"]), spacing, infoMaxW);
//				draw_text_ext(infoBoxX + actionBox.menuTextOffX, actionBox.activeY - actionBox.menuTextY + (actionBox.menuTextSpaceY * 1), "Power: " + string(atk[$"damage"]), spacing, infoMaxW);
//				if (struct_exists(atk, "desc")){
//					draw_text_ext(infoBoxX + actionBox.menuTextOffX, actionBox.activeY - actionBox.menuTextY + (actionBox.menuTextSpaceY * 2), atk[$"desc"], spacing, infoMaxW);
//				}
//			}
//		case BMENUST.SPELL:
//			header ??= "SPELL";
//			if (header == "SPELL"){
//				var spl = struct_get(spellData, spells[selected]);
//				draw_sprite(sprInfoBox, 0, infoBoxX, actionBox.activeY);
//				var infoMaxW = sprite_get_width(sprInfoBox);
//				draw_text_ext(infoBoxX + actionBox.menuTextOffX, actionBox.activeY - actionBox.menuHeaderY, options[selected], spacing, infoMaxW);
//				draw_text_ext(infoBoxX + actionBox.menuTextOffX, actionBox.activeY - actionBox.menuTextY + (actionBox.menuTextSpaceY * 0), "Type: " + string(spl[$"scale"]), spacing, infoMaxW);
//				if (struct_exists(spl, "damage")){
//					draw_text_ext(infoBoxX + actionBox.menuTextOffX, actionBox.activeY - actionBox.menuTextY + (actionBox.menuTextSpaceY * 1), "Power: " + string(spl[$"damage"]) + "  |  " + "Cost: " + string(spl[$"cost"]), spacing, infoMaxW);
//				} else if (struct_exists(spl, "heal")){
//					draw_text_ext(infoBoxX + actionBox.menuTextOffX, actionBox.activeY - actionBox.menuTextY + (actionBox.menuTextSpaceY * 1), "Power: " + string(spl[$"heal"]) + "  |  " + "Cost: " + string(spl[$"cost"]), spacing, infoMaxW);
//				} else {
//					draw_text_ext(infoBoxX + actionBox.menuTextOffX, actionBox.activeY - actionBox.menuTextY + (actionBox.menuTextSpaceY * 1), "Cost: " + string(spl[$"cost"]), spacing, infoMaxW);
//				}
//				if (array_length(spl[$"effects"]) > 0){
//					//draw_text(infoBoxX + actionBox.menuTextOffX, actionBox.activeY - actionBox.menuTextY + (actionBox.menuTextSpaceY * 2), "Applies: ");
//				}
//				if (struct_exists(spl, "desc")){
//					draw_text_ext(infoBoxX + actionBox.menuTextOffX, actionBox.activeY - actionBox.menuTextY + (actionBox.menuTextSpaceY * 2), spl[$"desc"], spacing, infoMaxW);
//				}
//			}
//		case BMENUST.ITEMS:
//			header ??= "ITEMS";
//			if (header == "ITEMS"){
//				var item = battleInfo.inventory[selected];
//				draw_sprite(sprInfoBox, 0, infoBoxX, actionBox.activeY);
//				var infoMaxW = sprite_get_width(sprInfoBox);
//				draw_text_ext(infoBoxX + actionBox.menuTextOffX, actionBox.activeY - actionBox.menuHeaderY, options[selected], spacing, infoMaxW);
//				draw_text_ext(infoBoxX + actionBox.menuTextOffX, actionBox.activeY - actionBox.menuTextY + (actionBox.menuTextSpaceY * 0), "Quantity: " + string(item[$"quantity"]), spacing, infoMaxW);
//				if (item[$"abil"] == "restore"){
//					draw_text_ext(infoBoxX + actionBox.menuTextOffX, actionBox.activeY - actionBox.menuTextY + (actionBox.menuTextSpaceY * 1), "Restores: " + string(item[$"pow"]), spacing, infoMaxW);
//				} else if (item[$"abil"] == "heal"){
//					draw_text_ext(infoBoxX + actionBox.menuTextOffX, actionBox.activeY - actionBox.menuTextY + (actionBox.menuTextSpaceY * 1), "Heals: " + string(item[$"pow"]), spacing, infoMaxW);
//				} 
//			}
//		case BMENUST.FLEE:
//			header ??= "FLEE";
//		case BMENUST.TARGET:
//			header ??= "TARGET";
//			if (header == "TARGET"){
//				var tar = battleInfo.tarteam[selected];
//				draw_sprite(sprInfoBox, 0, infoBoxX, actionBox.activeY);
//				var infoMaxW = sprite_get_width(sprInfoBox);
//				if (tar != undefined){
//					draw_text_ext(infoBoxX + actionBox.menuTextOffX, actionBox.activeY - actionBox.menuHeaderY, options[selected], spacing, infoMaxW);
//					draw_text_ext(infoBoxX + actionBox.menuTextOffX, actionBox.activeY - actionBox.menuTextY + (actionBox.menuTextSpaceY * 0), "HP: " + string(tar[$"hp"]) + "/" + string(tar[$"stats"][$"maxhp"]), spacing, infoMaxW);
//					draw_text_ext(infoBoxX + actionBox.menuTextOffX, actionBox.activeY - actionBox.menuTextY + (actionBox.menuTextSpaceY * 1), tar[$"desc"], spacing, infoMaxW);
//				}
//			}
//			draw_sprite(sprActionBox, 0, actionBox.X[0], actionBox.activeY);
//			maxTextW = sprite_get_width(sprActionBox);
//			draw_text_ext(actionBox.X[0] + actionBox.menuTextOffX, actionBox.activeY - actionBox.menuHeaderY, header, spacing, maxTextW);
//			for (var i = 0; i < array_length(options); i++){
//				var textCol = (i == selected) ? c_yellow : c_white;
//				draw_set_color(textCol);
//				draw_text_ext(actionBox.X[0] + actionBox.menuTextOffX, actionBox.activeY - actionBox.menuTextY + (actionBox.menuTextSpaceY * i), options[i], spacing, maxTextW);	
//				draw_set_color(c_white);
//			}
//			break;
//		case BMENUST.ANIMATE:
//			for (var i = 0; i < array_length(options); ++i){
//				draw_sprite(sprActionBox, 0, actionBox.X[i], actionBox.inactiveY);
//				var textCol = (i == selected) ? c_yellow : c_white;
//				draw_set_color(textCol);
//				draw_text(actionBox.X[i] + actionBox.menuTextOffX, actionBox.inactiveY - actionBox.menuHeaderY, options[i]);
//				draw_set_color(c_white);
//			}
//			break;
	
		
//	}
//}

draw_text(100,16, string(focus));