// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scrStartNetBattle(socket){
	if (DEBUG_ENABLED) show_debug_message("[Server] Starting Battle!");
	var buff = buffer_create(1024, buffer_grow, 1);
	buffer_seek(buff, buffer_seek_start, 0);
	buffer_write(buff, buffer_u8, NET.STARTBATTLE);
	if (DEBUG_ENABLED) show_debug_message("Sending Packet!");
	network_send_packet(socket, buff, buffer_tell(buff));
	buffer_delete(buff);
}