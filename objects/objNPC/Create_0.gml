type = NPC.FRIENDLY;
diag = "I'm just a rock. Chillin'.";
interactCd = false;

diagChar = global.data.dialogue.npc_test;
line = "test";

onInteract = function(){
	if (!interactCd){
		with(objDialogue){
			loadDiag(other.diagChar, other.line, other);	
		}
	}
}
image_speed = 0;