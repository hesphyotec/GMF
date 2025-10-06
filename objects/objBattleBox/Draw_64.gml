draw_set_font(fntBattle);

draw_sprite(sprCurrentCharBox, 0, 0, display_get_gui_height());
draw_text(actionMenuTextOffX, currNameTextY, currentChar[$"name"]);
draw_set_font(fntHP);
draw_text(actionMenuTextOffX, currHPTextY, currentChar[$"hp"]);
draw_text(actionMenuTextOffX, currHPTextY + 16, currentChar[$"mana"]);
draw_set_font(fntBattle);
//draw_text(actionMenuTextOffX, currHPTextY + actionMenuTextSpaceY, currentChar[$"mana"]);

switch(menuState){
	case BMENUST.ACTION:
		for (var i = 0; i < array_length(options); ++i){
			var activeY = (i == selected) ? actionBoxActiveY : actionBoxInactiveY;
			draw_sprite(sprActionBox, 0, actionBoxX[i], activeY);
			var textCol = (i == selected) ? c_yellow : c_white;
			draw_set_color(textCol);
			draw_text(actionBoxX[i] + actionMenuTextOffX, activeY - actionMenuHeaderY, options[i]);
			draw_set_color(c_white);
			if (i == selected){
				switch(i){
					case 0:
						for (var j = 0; j < array_length(attacks); j++){
							draw_text(actionBoxX[i] + actionMenuTextOffX, activeY - actionMenuTextY + (actionMenuTextSpaceY * j), struct_get(attackData, attacks[j])[$"name"]);	
						}
						break;
					case 1:
						for (var j = 0; j < array_length(spells); j++){
							draw_text(actionBoxX[i] + actionMenuTextOffX, activeY - actionMenuTextY + (actionMenuTextSpaceY * j), struct_get(spellData, spells[j])[$"name"]);	
						}
						break;
				}
			}
		}
		break;
	case BMENUST.ATTACK:
		draw_sprite(sprActionBox, 0, actionBoxX[0], actionBoxActiveY);
		draw_sprite(sprInfoBox, 0, infoBoxX, actionBoxActiveY);
		draw_text(actionBoxX[0] + actionMenuTextOffX, actionBoxActiveY - actionMenuHeaderY, "ATTACK");
		for (var i = 0; i < array_length(options); i++){
			var textCol = (i == selected) ? c_yellow : c_white;
			draw_set_color(textCol);
			draw_text(actionBoxX[0] + actionMenuTextOffX, actionBoxActiveY - actionMenuTextY + (actionMenuTextSpaceY * i), options[i]);	
			draw_set_color(c_white);
		}
		break;
	case BMENUST.SPELL:
		draw_sprite(sprActionBox, 0, actionBoxX[0], actionBoxActiveY);
		draw_sprite(sprInfoBox, 0, infoBoxX, actionBoxActiveY);
		draw_text(actionBoxX[0] + actionMenuTextOffX, actionBoxActiveY - actionMenuHeaderY, "SPELL");
		for (var i = 0; i < array_length(options); i++){
			var textCol = (i == selected) ? c_yellow : c_white;
			draw_set_color(textCol);
			draw_text(actionBoxX[0] + actionMenuTextOffX, actionBoxActiveY - actionMenuTextY + (actionMenuTextSpaceY * i), options[i]);	
			draw_set_color(c_white);
		}
		break;
	case BMENUST.TARGET:
		draw_sprite(sprActionBox, 0, actionBoxX[0], actionBoxActiveY);
		draw_sprite(sprInfoBox, 0, infoBoxX, actionBoxActiveY);
		draw_text(actionBoxX[0] + actionMenuTextOffX, actionBoxActiveY - actionMenuHeaderY, "TARGET");
		for (var i = 0; i < array_length(options); i++){
			var textCol = (i == selected) ? c_yellow : c_white;
			draw_set_color(textCol);
			draw_text(actionBoxX[0] + actionMenuTextOffX, actionBoxActiveY - actionMenuTextY + (actionMenuTextSpaceY * i), options[i]);	
			draw_set_color(c_white);
		}
		break;
	
		
}