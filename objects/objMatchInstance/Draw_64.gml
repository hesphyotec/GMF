draw_text(0, 0, "Connections: " + string(array_length(sockets)));
draw_text(0, 16, "Player 1 Position " + string(ply1Pos[0]) + " : " + string(ply1Pos[1]));
draw_text(0, 32, "Player 2 Position " + string(ply2Pos[0]) + " : " + string(ply2Pos[1]));
if (array_length(global.players) == 2){
	draw_text(0, 48, "Player 1 Companions " + string(array_length(global.players[0].team)));
	draw_text(0, 64, "Player 2 Companions " + string(array_length(global.players[1].team)));
}
draw_text(256, 0, string(global.isServer));