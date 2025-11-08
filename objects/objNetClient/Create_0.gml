socket = network_create_socket(network_socket_tcp);
server = network_connect(socket, "127.0.0.1", 22566);

if (server < 0){
	show_message("Connection to server failed!");	
} else {
	show_message("Connected!");
	scrInitPlayer(socket);
}

//buffer = buffer_create(2048, buffer_grow, 1);
handleData = function(){
	var buff = async_load[?"buffer"];
	var op = buffer_read(buff, buffer_u8);
	switch(op){
		case NET.PLAYERADDED:
			break;
		case NET.OPPONENTADDED:
			addOpponent();
			break;
	}
}

addOpponent = function(){
	var opp = instance_create_layer(64, 64, "Instances", objNetPlayer);
	array_push(global.players, opp);
}