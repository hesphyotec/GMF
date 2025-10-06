function scrLoadJSON(filename){
	var buff = buffer_load(filename);
	if (buff == -1){
		show_debug_message("Error: Couldn't load" + filename);	
		return {};
	}
	buffer_seek(buff, buffer_seek_start, 0);
	var json = buffer_read(buff, buffer_text);
	buffer_delete(buff);
	
	var data;
	
	try {
		data = json_parse(json);
	} catch (e) {
		show_debug_message("Error: Failed to parse JSON from " + filename);
		return {};
	}
	
	return data;
}