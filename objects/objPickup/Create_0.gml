item = "chestpiece1";

onInteract = function(src){
	if (global.players[0].equipItem(item, 0)){
		audio_play_sound(sndGet, 1, false, global.effVolume);
		instance_destroy(id);
	}
}