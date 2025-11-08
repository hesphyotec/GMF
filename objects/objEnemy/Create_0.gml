type = NPC.HOSTILE;
diag = "I'm just a rock. Chillin'.";
enemy = ENCOUNTERS.BANDIT1;
onInteract = function(player){
	scrStartBattle(room, player, enemy);
	instance_destroy(self);
}