type = NPC.FRIENDLY;

onInteract = function(){
	objDialogue.loadDiag(objDialogue.dialogueData[$"veteran"], "recruit", id);
}
image_speed = 0;