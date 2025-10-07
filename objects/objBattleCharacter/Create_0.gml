state = CHARSTATES.IDLE;
character = undefined;
splash = undefined;
isPlayerTeam = false;
animating = false;


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
	state = CHARSTATES.ATTACK;
	if (DEBUG_ENABLED) show_debug_message("[2]" + act);
	if (isActor){
		var action = undefined;
		var isSpl = false;
		if (struct_exists(atkData, act)){
			action = struct_get(atkData, act);	
		} else if (struct_exists(splData, act)){
			action = struct_get(splData, act);	
			isSpl = true;
		}
		if (DEBUG_ENABLED) show_debug_message("[3]" + string(action));
		var anim = undefined;
		anim = asset_get_index(string_concat(character[$"sprite"], act));
		if (DEBUG_ENABLED) show_debug_message("[3b]" + string(anim));
		if (anim != -1){
			if (DEBUG_ENABLED) show_debug_message("[3b]" + string(action));
			animating = true;
			sprite_index = anim;
			image_index = 0;
			image_speed = 1;
		}
		var actSound = action[$"sound"];
		var soundId = scrGetSound(actSound);
		if (DEBUG_ENABLED) show_debug_message(string(soundId));
		if (DEBUG_ENABLED) show_debug_message("[4]" + string(action));
		audio_play_sound(soundId, 1, false);
		if (anim == -1){
			alarm[0] = (audio_sound_length(soundId) * room_speed) * .75;
		}
	} else {
		alarm[0] = 1;
	}
}