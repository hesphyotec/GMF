type = NPC.FRIENDLY;

onInteract = function(){
	objDialogue.loadDiag(objDialogue.dialogueData[$"witch"], "recruit", id);
}
image_speed = 0;