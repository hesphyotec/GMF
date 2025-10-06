type = NPC.HOSTILE;
diag = "I'm just a rock. Chillin'.";
enemy = ENCOUNTERS.TEST;
onInteract = function(player){
	scrStartBattle(room, player, enemy);
	instance_destroy(self);
}