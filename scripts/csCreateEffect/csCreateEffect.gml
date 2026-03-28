// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function csCreateEffect(X, Y, lay, sprite, wait, follow = undefined, persist = false, color = c_white, fade = false, fadeIn = false, fadeAMT = 0, alpha = 1){
	if(!eff){
		eff = createOWEffect(X, Y, lay, sprite, follow, persist, fade, fadeIn, fadeAMT, color, alpha);
	}
	if(!instance_exists(eff) && wait){
		eff = undefined;
		csEndAction();
	}
	if(!wait){
		eff = undefined;
		csEndAction();	
	}
}