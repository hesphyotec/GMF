state = CHARSTATES.IDLE;
character = undefined;
splash = undefined;
isPlayerTeam = false;


yOff = 0;
hpTextOffX = 32;
playerhpTextOffY = 6;
effOffX = sprite_get_width(sprite_index)/2;
effSpace = 12;
dbOffY = 8;
bOffY = 16;

splashY = display_get_gui_height() - (92 * MENU_GUI_SCALE);

loadSprite = function(char){
	character = char;
	show_debug_message(character[$"sprite"]);
	if (character != undefined){
		if (character[$"sprite"] == "PlayerT"){
			sprite_index = sprBattlePlayerT;
			splash = sprHumanPlayerSplash;
		}
		if (character[$"sprite"] == "archer"){
			sprite_index = sprBattleArcherT;
			splash = sprArcherSplash;
		}
		if (character[$"sprite"] == "healer"){
			sprite_index = sprBattleHealerT;
			splash = sprHealerSplash;
		}
		if (character[$"sprite"] == "vet"){
			sprite_index = sprBattleVetT;
			splash = sprVetSplash;
		}
		if (character[$"sprite"] == "BattleRock"){
			sprite_index = sprBattleRock;
		}
		if (character[$"sprite"] == "BigRock"){
			sprite_index = sprBattleBigRock;
		}
	}
	
	effOffX = sprite_get_width(sprite_index)/2;
}