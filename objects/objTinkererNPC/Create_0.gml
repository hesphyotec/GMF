type = NPC.FRIENDLY;

onInteract = function(){
	objDialogue.loadDiag(objDialogue.dialogueData[$"tinkerer"], "recruit", id);
}
image_speed = 0;