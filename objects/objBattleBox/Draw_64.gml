draw_set_font(fntBattle);

if (battleInfo.isPlayerTurn == true){
	draw_sprite(sprCurrentCharBox, 0, 0, display_get_gui_height());
	draw_text(actionBox.menuTextOffX, currNameTextY, battleInfo.activeFighter[$"name"]);
	draw_set_font(fntHP);
	draw_text(actionBox.menuTextOffX, currHPTextY, battleInfo.activeFighter[$"hp"]);
	draw_text(actionBox.menuTextOffX, currHPTextY + 16, battleInfo.activeFighter[$"mana"]);
	draw_set_font(fntBattle);
}
//draw_text(actionMenuTextOffX, currHPTextY + actionMenuTextSpaceY, currentChar[$"mana"]);
var header = undefined;
switch(battleInfo.menuState){
	case BMENUST.ACTION:
		for (var i = 0; i < array_length(options); ++i){
			var activeY = (i == selected) ? actionBox.activeY : actionBox.inactiveY;
			draw_sprite(sprActionBox, 0, actionBox.X[i], activeY);
			var textCol = (i == selected) ? c_yellow : c_white;
			draw_set_color(textCol);
			draw_text(actionBox.X[i] + actionBox.menuTextOffX, activeY - actionBox.menuHeaderY, options[i]);
			draw_set_color(c_white);
			if (i == selected){
				switch(i){
					case 0:
						for (var j = 0; j < array_length(attacks); j++){
							draw_text(actionBox.X[i] + actionBox.menuTextOffX, activeY - actionBox.menuTextY + (actionBox.menuTextSpaceY * j), struct_get(attackData, attacks[j])[$"name"]);	
						}
						break;
					case 1:
						for (var j = 0; j < array_length(spells); j++){
							draw_text(actionBox.X[i] + actionBox.menuTextOffX, activeY - actionBox.menuTextY + (actionBox.menuTextSpaceY * j), struct_get(spellData, spells[j])[$"name"]);	
						}
						break;
					case 2:
						for (var j = 0; j < array_length(battleInfo.inventory); j++){
							draw_text(actionBox.X[i] + actionBox.menuTextOffX, activeY - actionBox.menuTextY + (actionBox.menuTextSpaceY * j), battleInfo.inventory[j][$"name"]);	
						}
						break;
				}
			}
		}
		break;
	case BMENUST.ATTACK:
		header ??= "ATTACK";
		//if (DEBUG_ENABLED) show_debug_message(string(options[selected]));
		if (header == "ATTACK"){
			var atk = struct_get(attackData, attacks[selected]);
			draw_sprite(sprInfoBox, 0, infoBoxX, actionBox.activeY);
			draw_text(infoBoxX + actionBox.menuTextOffX, actionBox.activeY - actionBox.menuHeaderY, options[selected]);
			draw_text(infoBoxX + actionBox.menuTextOffX, actionBox.activeY - actionBox.menuTextY + (actionBox.menuTextSpaceY * 0), "Type: " + string(atk[$"scale"]));
			draw_text(infoBoxX + actionBox.menuTextOffX, actionBox.activeY - actionBox.menuTextY + (actionBox.menuTextSpaceY * 1), "Power: " + string(atk[$"damage"]));
			if (struct_exists(atk, "desc")){
				draw_text(infoBoxX + actionBox.menuTextOffX, actionBox.activeY - actionBox.menuTextY + (actionBox.menuTextSpaceY * 2), atk[$"desc"]);
			}
		}
	case BMENUST.SPELL:
		header ??= "SPELL";
		if (header == "SPELL"){
			var spl = struct_get(spellData, spells[selected]);
			draw_sprite(sprInfoBox, 0, infoBoxX, actionBox.activeY);
			draw_text(infoBoxX + actionBox.menuTextOffX, actionBox.activeY - actionBox.menuHeaderY, options[selected]);
			draw_text(infoBoxX + actionBox.menuTextOffX, actionBox.activeY - actionBox.menuTextY + (actionBox.menuTextSpaceY * 0), "Type: " + string(spl[$"scale"]));
			if (struct_exists(spl, "damage")){
				draw_text(infoBoxX + actionBox.menuTextOffX, actionBox.activeY - actionBox.menuTextY + (actionBox.menuTextSpaceY * 1), "Power: " + string(spl[$"damage"]) + "  |  " + "Cost: " + string(spl[$"cost"]));
			} else if (struct_exists(spl, "heal")){
				draw_text(infoBoxX + actionBox.menuTextOffX, actionBox.activeY - actionBox.menuTextY + (actionBox.menuTextSpaceY * 1), "Power: " + string(spl[$"heal"]) + "  |  " + "Cost: " + string(spl[$"cost"]));
			} else {
				draw_text(infoBoxX + actionBox.menuTextOffX, actionBox.activeY - actionBox.menuTextY + (actionBox.menuTextSpaceY * 1), "Cost: " + string(spl[$"cost"]));
			}
			if (array_length(spl[$"effects"]) > 0){
				//draw_text(infoBoxX + actionBox.menuTextOffX, actionBox.activeY - actionBox.menuTextY + (actionBox.menuTextSpaceY * 2), "Applies: ");
			}
			if (struct_exists(spl, "desc")){
				draw_text(infoBoxX + actionBox.menuTextOffX, actionBox.activeY - actionBox.menuTextY + (actionBox.menuTextSpaceY * 2), spl[$"desc"]);
			}
		}
	case BMENUST.ITEMS:
		header ??= "ITEMS";
	case BMENUST.FLEE:
		header ??= "FLEE";
	case BMENUST.TARGET:
		header ??= "TARGET";
		if (header == "TARGET"){
			var tar = undefined
			if (battleInfo.team1[selected][$"name"] == options[selected]){
				tar = battleInfo.team1[selected];
			} else {
				tar = battleInfo.team2[selected];
			}
			draw_sprite(sprInfoBox, 0, infoBoxX, actionBox.activeY);
			if (tar != undefined){
				draw_text(infoBoxX + actionBox.menuTextOffX, actionBox.activeY - actionBox.menuHeaderY, options[selected]);
				draw_text(infoBoxX + actionBox.menuTextOffX, actionBox.activeY - actionBox.menuTextY + (actionBox.menuTextSpaceY * 0), "HP: " + string(tar[$"hp"]) + "/" + string(tar[$"stats"][$"maxhp"]));
				draw_text(infoBoxX + actionBox.menuTextOffX, actionBox.activeY - actionBox.menuTextY + (actionBox.menuTextSpaceY * 1), tar[$"desc"]);
			}
		}
		draw_sprite(sprActionBox, 0, actionBox.X[0], actionBox.activeY);
		draw_text(actionBox.X[0] + actionBox.menuTextOffX, actionBox.activeY - actionBox.menuHeaderY, header);
		for (var i = 0; i < array_length(options); i++){
			var textCol = (i == selected) ? c_yellow : c_white;
			draw_set_color(textCol);
			draw_text(actionBox.X[0] + actionBox.menuTextOffX, actionBox.activeY - actionBox.menuTextY + (actionBox.menuTextSpaceY * i), options[i]);	
			draw_set_color(c_white);
		}
		break;
	case BMENUST.ANIMATE:
		for (var i = 0; i < array_length(options); ++i){
			draw_sprite(sprActionBox, 0, actionBox.X[i], actionBox.inactiveY);
			var textCol = (i == selected) ? c_yellow : c_white;
			draw_set_color(textCol);
			draw_text(actionBox.X[i] + actionBox.menuTextOffX, actionBox.inactiveY - actionBox.menuHeaderY, options[i]);
			draw_set_color(c_white);
		}
		break;
	
		
}