item = {};
type = NPC.PICKUP;
dir = Dirs.DOWN;
onInteract = function(src){
	objPlayer.pickupItem(item);
	audio_play_sound(sndGet, 1, false, global.effVolume);
	instance_destroy(id);
}

setItem = function(itemName){
	item = struct_get(global.data.equipment, itemName);
	var sprite = asset_get_index(item.sprite);
	sprite_index = sprite;
}