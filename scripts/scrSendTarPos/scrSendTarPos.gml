// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scrSendTarPos(socket, mTarX, mTarY){
	var buffer = buffer_create(1024, buffer_grow, 1);
	buffer_seek(buffer, buffer_seek_start, 0);
	buffer_write(buffer, buffer_u8, NET.MOVE);
	buffer_write(buffer, buffer_u16, mTarX);
	buffer_write(buffer, buffer_u16, mTarY);
	network_send_packet(socket, buffer, buffer_tell(buffer));
	buffer_delete(buffer);
}