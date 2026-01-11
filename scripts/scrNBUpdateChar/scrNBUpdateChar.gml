// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scrNBUpdateChar(socket, char){
	serverLog("Updating" + char.key);
	var buff = buffer_create(1024, buffer_grow, 1);
	buffer_seek(buff, buffer_seek_start, 0);
	buffer_write(buff, buffer_u8, NET.UPDATECHAR);
	var charData = json_stringify(char);
	buffer_write(buff, buffer_string, charData);
	network_send_packet(socket, buff, buffer_tell(buff));
	buffer_delete(buff);
}