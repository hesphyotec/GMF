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
atkData = global.data.moves[$"attacks"];
splData = global.data.moves[$"spells"];

splashY = display_get_gui_height() - (92 * MENU_GUI_SCALE);

loadSprite = function(char){
	character = char;
	show_debug_message(character[$"sprite"]);
	if (character != undefined){
		sprite_index = asset_get_index(character[$"sprite"]);
		if(struct_exists(character, "splash")){
			splash = asset_get_index(character[$"splash"]);
		}
	}
	show_debug_message(sprite_index);
	effOffX = sprite_get_width(sprite_index)/2;
}

doAnim = function(act, isActor){
	if (isActor){
		var action = undefined;
		var isSpl = false;
		if (struct_exists(atkData, act)){
			action = struct_get(atkData, act);	
		} else if (struct_exists(splData, act)){
			action = struct_get(splData, act);	
			isSpl = true;
		}
		var actSound = action[$"sound"];
		var soundId = scrGetSound(actSound);
		if (DEBUG_ENABLED) show_debug_message(string(soundId));
		alarm[0] = ceil(audio_sound_length(soundId))*45;
		audio_play_sound(soundId, 1, false);
	} else {
		if (alarm[0] <= 0){
			alarm[0] = 5;
		}
	}
}