type = NPC.FRIENDLY;

onInteract = function(){
	objDialogue.loadDiag(objDialogue.dialogueData[$"enchantress"], "recruit", id);
}
image_speed = 0;