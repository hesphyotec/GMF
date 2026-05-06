// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function deleteSaveData(){
	while((file_find_first("*.save", fa_none)) != ""){
		file_delete(file_find_first("*.save", fa_none));
	}
}