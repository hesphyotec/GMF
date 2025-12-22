// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scrNetUpdateComps(sock, companion){
	if (DEBUG_ENABLED) show_debug_message("Companion add start!");
	if (DEBUG_ENABLED) serverLog("[Server] Companion being added!");
	var buff = buffer_create(1024, buffer_grow, 1);
	buffer_seek(buff, buffer_seek_start, 0);
	buffer_write(buff, buffer_u8, NET.OPPADDCOMP);
	buffer_write(buff, buffer_string, companion);
	if (DEBUG_ENABLED) show_debug_message("Sending Packet!");
	network_send_packet(sock, buff, buffer_tell(buff));
	buffer_delete(buff);
}