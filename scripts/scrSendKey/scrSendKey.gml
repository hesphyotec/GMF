// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scrSendKey(buffer, socket, up, down, left, right){
	buffer_seek(buffer, buffer_seek_start, 0);
	buffer_write(buffer, buffer_u8, NET.KEY);
	buffer_write(buffer, buffer_u8, up);
	buffer_write(buffer, buffer_u8, down);
	buffer_write(buffer, buffer_u8, left);
	buffer_write(buffer, buffer_u8, right);
	network_send_packet(socket, buffer, buffer_tell(buffer));
}