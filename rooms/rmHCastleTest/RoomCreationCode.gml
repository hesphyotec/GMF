audio_play_sound(sndBirds, 1, true, global.masVolume * global.musVolume);
global.overworld = true;
if (array_length(global.players) > 1){
	global.players[0].generatePlayer();
	global.players[1].generateNetPlayer();	
}