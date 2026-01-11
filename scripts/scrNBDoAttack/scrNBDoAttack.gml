// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scrNBDoAttack(socket, actInfo, str, final){
	clientLog("Sending action to server: " + actInfo.act);
	var buff = buffer_create(1024, buffer_grow, 1);
	buffer_seek(buff, buffer_seek_start, 0);
	buffer_write(buff, buffer_u8, NET.DOATTACK);
	
	var actData = json_stringify(actInfo);
	buffer_write(buff, buffer_string, actData);
	buffer_write(buff, buffer_u8, str);
	buffer_write(buff, buffer_bool, final);
	network_send_packet(socket, buff, buffer_tell(buff));
	buffer_delete(buff);
}