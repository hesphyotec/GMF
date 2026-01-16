// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function endNetBattle(socket, win){
	if (DEBUG_ENABLED) serverLog("[Client] Ending Battle!");
	var buff = buffer_create(1024, buffer_grow, 1);
	buffer_seek(buff, buffer_seek_start, 0);
	buffer_write(buff, buffer_u8, NET.ENDBATTLE);
	buffer_write(buff, buffer_bool, win);
	if (DEBUG_ENABLED) show_debug_message("Sending Packet!");
	network_send_packet(socket, buff, buffer_tell(buff));
	buffer_delete(buff);
}