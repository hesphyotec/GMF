type = NPC.HOSTILE;
enemy = ENCOUNTERS.BANDIT1;
onInteract = function(player){
	scrStartBattle(room, player, enemy);
	instance_destroy(self);
}