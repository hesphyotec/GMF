///@description Wait timer
if (isPlayerTeam){
	context.controller.teams[0].charReady(character);
} else {
	context.controller.teams[1].charReady(character);
}
//show_message(character[$"name"] + "is ready!");