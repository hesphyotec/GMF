// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function csDialogue(diagChar, diagId, source){
	if(!inDiag){
		var diagCharData = struct_get(global.data.dialogue, diagChar);
		objDialogue.loadDiag(diagCharData, diagId, source);
		inDiag = true;
	} else {
		if(!objDialogue.active){
			csEndAction();	
		}
	}
}