sndwidth = 0;
height = 0;

xPos = 0;
yPos = 0;

targetX = 0;
targetY = 0;
tweenY = 0;
tweenX = 0;
tweenSpeed = 0;

hovered = false;
isKeySelected = false;

data = {};
type = GUI.TEXTBUTTON;
font = fntBattle;

active = true;
master = undefined;
parent = undefined;

a = 1;
color = c_white;

slideVal = 1.0;

currLine = 0;
textProgress = 0;

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

onHold = function(){}

onHover = function(){}

onStep = function(){}

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
	draw_set_alpha(a);
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
		case GUI.BOXCONTAINER:
			drawBoxContainer();
			break;
		case GUI.SLIDER:
			drawSlider();
			break;
		case GUI.INVCONTAINER:
			drawInvContainer();
			break;
		case GUI.INVDRAGBOX:
			drawInvDragBox();
			break;
		case GUI.INFOBOX:
			drawInfoBox();
			break;
		case GUI.BACKPACKCONTAINER:
			drawBpContainer();
			break;
		case GUI.BACKPACKINVBOX:
			drawBpBox();
			break;
	}
	draw_set_alpha(1);
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

drawBoxContainer = function(){
	active = false;
	draw_set_colour(data.col)
	draw_set_alpha(data.a);
	draw_rectangle(data.X, data.Y, tweenX, data.h, false);
	draw_set_colour(c_white);
	draw_set_alpha(1);
}

drawSlider = function(){
	draw_set_colour(c_gray);
	draw_rectangle(xPos, yPos + (height * .75), xPos + width, yPos + height, false);
	draw_set_colour(c_white);
	draw_rectangle(xPos, yPos + (height * .75), xPos + (width * slideVal), yPos + height, false);
	draw_set_halign(fa_center);
	draw_set_valign(fa_center);
	draw_set_font(fntBattle);
	draw_text(xPos + (width/2), yPos + (height/4), data.text);
	draw_set_font(fntBattle);
	draw_set_halign(fa_center);
	draw_set_valign(fa_bottom);
	draw_set_colour(c_black);
	draw_text(xPos + (width / 2), yPos + height + 3, string(round(slideVal * 100)) + " %");
	drawReset();
}

drawInvContainer = function(){
	active = false;
	draw_sprite_stretched(sprite_index, image_index, tweenX, yPos, width * (tweenX / targetX), height);
	var charSprite = asset_get_index(data.r_char.sprite);
	draw_sprite(charSprite, 0, tweenX + width - (sprite_get_width(charSprite)), yPos + (sprite_get_width(charSprite)));
}

drawBpContainer = function(){
	active = false;
	draw_sprite_stretched(sprite_index, image_index, xPos, tweenY, width, height * (tweenY / targetY));
}

drawInvDragBox = function(){
	if (hovered){
		color = c_yellow;	
	} else {
		color = c_white;	
	}
	draw_set_alpha(1);
	draw_set_color(color);
	draw_sprite_stretched(sprButtonTest, image_index, tweenX, yPos, width, height);
	draw_set_colour(c_white);
	draw_set_alpha(1);
	if (data.item != undefined){
		if (moving){
			draw_sprite(sprite_index, image_index, device_mouse_x_to_gui(0), device_mouse_y_to_gui(0));
		} else {
			draw_sprite(sprite_index, image_index, tweenX, yPos + (sprite_height));
		}
	}
}

drawBpBox = function(){
	if (hovered){
		color = c_yellow;	
	} else {
		color = c_white;	
	}
	draw_set_alpha(1);
	draw_set_color(color);
	draw_sprite_stretched(sprButtonTest, image_index, xPos, tweenY, width, height);
	//draw_rectangle(xPos, tweenY, xPos + width, tweenY + height, true);
	draw_set_colour(c_white);
	draw_set_alpha(1);
	if (data.item != undefined){
		if (moving){
			draw_sprite(sprite_index, image_index, device_mouse_x_to_gui(0), device_mouse_y_to_gui(0));
		} else {
			draw_sprite(sprite_index, image_index, xPos, tweenY + (sprite_height));
		}
	}

}

drawInfoBox = function(){
	var textPad = 8;
	var text = "";
	for(var i = currLine; i < 3; ++i){
		text = string_concat(text, data.lines[i], "\n");	
	}
	draw_sprite_stretched(sprite_index, image_index, xPos, yPos, width, height);
	draw_set_valign(fa_top);
	if (textProgress < string_length(text)){
		textProgress++;
		audio_play_sound(sndSelect, 1, false, global.effVolume);
	}
	var showText = string_copy(text, 0, textProgress);
	draw_text_ext(xPos + textPad, yPos + textPad, showText, 16, width - textPad);
	drawReset();
}

drawHoverInfo = function(){
	xPos = device_mouse_x_to_gui(0);
	yPos = device_mouse_y_to_gui(0) - height;
	var iconBuffer = 16;
	var titleBufferX = 8;
	var lineBufferY = 24;
	var sep = 16
	var drawX = xPos;
	var drawY = yPos;
	draw_set_halign(fa_left);
	draw_set_valign(fa_bottom);
	if (xPos > display_get_gui_width() / 2){
		drawX = xPos - width;
		draw_set_halign(fa_right);
	}
	
	if (yPos < display_get_gui_height() / 2){
		drawY = yPos + height;
	}
	
	draw_sprite_stretched(sprite_index, image_index, drawX, drawY, width, height);
	if (struct_exists(data, "icon")){
		draw_sprite(data.icon, image_index, drawX + iconBuffer, drawY + iconBuffer);
		titleBufferX = iconBuffer + sprite_get_width(data.icon);
		lineBufferY = 8 + sprite_get_height(data.icon);
	}
	draw_set_font(fntBattle);
	draw_set_halign(fa_left);
	draw_set_valign(fa_bottom);
	if (struct_exists(data, "title")){
		draw_text_ext(drawX + titleBufferX, drawY + iconBuffer, data.title, sep, drawX + width - titleBufferX);
	}
	draw_set_font(fntHP);
	if (struct_exists(data, "lines")){
		for (var i = 0; i < array_length(data.lines); ++i){
			draw_text_ext(drawX + iconBuffer, drawY + lineBufferY + (sep * i), data.lines[i], sep, drawX + width - iconBuffer);
		}
	}
	draw_set_font(fntBattle);
	drawReset();
}