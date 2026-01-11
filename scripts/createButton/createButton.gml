// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function createButton(X, Y, w, h, spr, type, data){
	var button = instance_create_layer(0, 0, "Instances", objMenuComponent);
	button.xPos = X;
	button.yPos = Y;
	button.width = w;
	button.height = h;
	button.sprite_index = spr;
	button.data = data;
	button.type = type;
	return button;
}