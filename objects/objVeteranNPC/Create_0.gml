event_inherited();
type = NPC.FRIENDLY;
baseSpriteName = "sprVeteran"
onInteract = function(){
	objDialogue.loadDiag(objDialogue.dialogueData[$"veteran"], "recruit", id);
}
image_speed = 0;