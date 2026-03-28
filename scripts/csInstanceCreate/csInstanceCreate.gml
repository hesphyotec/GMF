// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function csInstanceCreate(xx, yy, lay, obj){
	var inst = instance_create_layer(xx, yy, lay, obj);
	csEndAction();
	return inst;
}