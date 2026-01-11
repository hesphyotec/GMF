width = 0;
height = 0;

xPos = 0;
yPos = 0;

targetY = 0;
tweenY = 0;

hovered = false;
isKeySelected = false;

data = {};
type = GUI.TEXTBUTTON;
font = fntBattle;

active = true;
master = undefined;

isHovered = function(){
	if (canReceiveInput()){
		var mx = device_mouse_x_to_gui(0);
		var my = device_mouse_y_to_gui(0);
		if ((mx >= xPos && mx <= (xPos + width)) && (my >= yPos && my <= (yPos + height))){
			with(objMenuComponent){
				hovered = false;	
			}
			hovered = true;
			if (master != undefined){
				master.focus = id;	
			}
			isKeySelected = false;
		} else {
			if (!isKeySelected){
				hovered = false;	
				if (master != undefined){
					master.focus = undefined;	
				}
			}
		}
	}
}

canReceiveInput = function(){
	return active && ((master == undefined || master.focus == undefined || master.focus == id));	
}

onClick = function(){}

onHover = function(){}

drawCompBasic = function(){
	var tex = sprite_get_texture(sprite_index, image_index);
	draw_primitive_begin_texture(pr_trianglelist, tex);
	draw_vertex(xPos, yPos);
	draw_vertex(xPos + width, yPos);
	draw_vertex(xPos, yPos + height);
	
	draw_vertex(xPos, yPos + height);
	draw_vertex(xPos + width, yPos + height);
	draw_vertex(xPos + width, yPos);
	draw_primitive_end();
}

onDraw = function(){
	switch(type){
		case GUI.TEXTBUTTON:
			drawTextButton();
			break;
		case GUI.BATTLEOPTION:
			drawText();
			break;
		case GUI.BATTLECARD:
			drawCard();
			break;
		case GUI.BATTLEINFO:
			drawTextButton();
			break;
		case GUI.BATTLECARDCONTAINER:
			drawCardContainer();
			break;
		case GUI.CHARMASK:
			break;
	}
}

drawTextButton = function(){
	if (hovered){
		draw_set_colour(c_yellow);
	}
	draw_rectangle(xPos, yPos, xPos + width, yPos + height, true);
	draw_set_halign(fa_center);
	draw_set_valign(fa_center);
	draw_set_font(fntBattle);
	draw_text(xPos + (width/2), yPos + (height/2), data.text);
	draw_set_font(fntBattle);
	draw_set_halign(fa_left);
	draw_set_valign(fa_bottom);
	draw_set_colour(c_white);
}

drawText = function(){
	if (hovered){
		draw_set_colour(c_yellow);
	}
	draw_set_halign(fa_left);
	draw_set_valign(fa_center);
	draw_set_font(font);
	draw_text(xPos, yPos + (height/2), data.text);
	draw_set_font(fntBattle);
	draw_set_halign(fa_left);
	draw_set_valign(fa_bottom);
	draw_set_colour(c_white);
}

drawCard = function(){
	targetY = data.actionBox.inactiveY;
	var textY = tweenY;
	if (hovered){
		targetY = yPos;
	}
	draw_sprite(sprite_index, image_index, xPos, tweenY);
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	draw_set_font(fntBattle);
	
	draw_text(xPos + 2, textY + 2, data.text);
	
	for(var i = array_length(data.buttons) - 1; i >= 0; --i){
		draw_text_ext(xPos + data.actionBox.menuTextOffX, tweenY + data.actionBox.menuTextSpaceY + (data.actionBox.menuTextSpaceY * i), data.buttons[i].text, data.buttons[i].spacing, sprite_width);	
	}
	
	draw_set_font(fntBattle);
	draw_set_halign(fa_left);
	draw_set_valign(fa_bottom);
	draw_set_colour(c_white);
}

drawCardContainer = function(){
	active = false;
	draw_sprite(sprite_index, image_index, xPos, yPos);
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	draw_set_font(fntBattle);
	
	draw_text(xPos + 2, yPos + 2, data.text);
	
	draw_set_font(fntBattle);
	draw_set_halign(fa_left);
	draw_set_valign(fa_bottom);
	draw_set_colour(c_white);
}