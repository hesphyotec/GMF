// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scrInitExistingNetPlayerServ(socket, player){
	serverLog("Loading Existing Player");
	var buff = buffer_create(1024, buffer_grow, 1);
	buffer_seek(buff, buffer_seek_start, 0);
	buffer_write(buff, buffer_u8, NET.INITEXISTING);
	var playerData = json_stringify(player);
	buffer_write(buff, buffer_string, playerData);
	network_send_packet(socket, buff, buffer_tell(buff));
	buffer_delete(buff);
}