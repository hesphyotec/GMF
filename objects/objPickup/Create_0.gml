item = global.data.equipment.tutSword;
type = NPC.PICKUP;
dir = Dirs.DOWN;
empty = false;
pickupMsg = {
	pickup : {
		dialogue : [
			"You found: " + string(item.name),
			"Would you like to equip it now?"
		],
		choices : [
			"Yes.",
			"No."
		],
		result : [
			{
				op : "openInventory",
			},
			{
				op : "endDiag"
			}
		]
	}
}

onInteract = function(src){
	if (!empty){
		objPlayer.pickupItem(item);
		objDialogue.loadDiag(pickupMsg, "pickup", id);
		audio_play_sound(sndGet, 1, false, global.effVolume);
		image_index = 1;
		empty = true;
	}
}

setItem = function(itemName){
	if (is_string(itemName)){
		item = struct_get(global.data.equipment, itemName);
	} else if (is_struct(itemName)){
		item = itemName;
	}
	//var sprite = asset_get_index(item.sprite);
	//sprite_index = sprite;
	pickupMsg = {
		pickup : {
			dialogue : [
				"You found: " + string(item.name),
				"Would you like to equip it now?"
			],
			choices : [
				"Yes.",
				"No."
			],
			result : [
				{
					op : "openInventory",
				},
				{
					op : "endDiag"
				}
			]
		}
	}
}