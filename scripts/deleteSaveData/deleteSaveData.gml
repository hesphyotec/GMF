// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function deleteSaveData(){
	if (file_exists("playerSave.save")){
		file_delete("playerSave.save");
	}
	if (file_exists("savefile.save")){
		file_delete("savefile.save");
	}
	if (file_exists("entityPosition.save")){
		file_delete("entityPosition.save");
	}
}