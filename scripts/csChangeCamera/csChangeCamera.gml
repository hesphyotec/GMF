// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function csChangeCamera(obj = undefined, xx = -1, yy = -1){
	if(obj){
		objCamera.lockedPos = false;
		objCamera.follow = obj;	
	} else if (xx != -1 && yy != -1){
		objCamera.lockedPos = true;
		objCamera.lookAtX = xx;
		objCamera.lookAtY = yy;
	}
	csEndAction();
}