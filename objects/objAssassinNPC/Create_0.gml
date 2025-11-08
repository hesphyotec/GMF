type = NPC.FRIENDLY;

onInteract = function(){
	objDialogue.loadDiag(objDialogue.dialogueData[$"assassin"], "recruit", id);
}
image_speed = 0;