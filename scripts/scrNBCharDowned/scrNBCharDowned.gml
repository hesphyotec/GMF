// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scrNBCharDowned(socket, char){
	serverLog(char.key + " has been downed!");
	var buff = buffer_create(1024, buffer_grow, 1);
	buffer_seek(buff, buffer_seek_start, 0);
	
	buffer_write(buff, buffer_u8, NET.CHARDOWNED);
	var charData = json_stringify(char);
	buffer_write(buff, buffer_string, charData);
	network_send_packet(socket, buff, buffer_tell(buff));
	buffer_delete(buff);
}