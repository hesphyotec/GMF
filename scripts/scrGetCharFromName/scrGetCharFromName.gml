// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scrGetCharFromName(name){
	var chars = global.data.companions;
	var ftr = struct_get(chars, name);
	return ftr;
}