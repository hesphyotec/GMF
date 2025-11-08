var eventId = async_load[?"id"];

if (eventId == socket){
	var type = async_load[?"type"];
	if (type == network_type_data){
		handleData();	
	}
}