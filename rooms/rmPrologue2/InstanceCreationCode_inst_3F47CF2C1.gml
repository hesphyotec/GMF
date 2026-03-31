type = NPC.HOSTILE;
enemy = ENCOUNTERS.PROLOGUE;
onInteract = function(player){
	scrStartBattle(room, player, enemy);
	instance_destroy(self);
}