// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function csScreenFade(col, fadeIn, fadeAmt, wait){
	if(!eff){
		if (fadeIn){
			eff = createOWScreenFadeIn(0,0, fadeAmt, col);
		} else {
			eff = createOWScreenFadeOut(0,0, fadeAmt, col);
		}
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