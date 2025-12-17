type = NPC.FRIENDLY;

onInteract = function(){
	objDialogue.loadDiag(objDialogue.dialogueData[$"warlock"], "recruit", id);
}
image_speed = 0;