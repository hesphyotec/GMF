type = NPC.FRIENDLY;
diag = "I'm just a rock. Chillin'.";

onInteract = function(){
	with(objDialogue){
		loadDiag(dialogueData[$"npc_test"]);	
	}
}
