if (active){
	if (popUp.sprite != undefined){
		draw_sprite(popUp.sprite, 0, popUp.X, popUp.Y);
		//draw_text(0,64, "POPUP LOADED!!!");	
	} else {
		//draw_text(0,64, "NO POPUP LOADED!!!");	
	}
	switch(mode){
		case QTEMODE.TIMEDHIT:
			draw_set_color(c_red);
			var hTx1 = (popUp.X - sprite_get_width(popUp.sprite)/2) + (hitTarget.pos - hitTarget.width);
			var hTy1 = (popUp.Y - sprite_get_height(popUp.sprite)/2 + hitTarget.height);
			var hTx2 = (popUp.X - sprite_get_width(popUp.sprite)/2) + (hitTarget.pos + hitTarget.width);
			var hTy2 = (popUp.Y - sprite_get_height(popUp.sprite)/2);
			draw_rectangle(hTx1, hTy1, hTx2, hTy2, true);
			draw_set_color(c_white);
			draw_set_color(c_yellow);
			var hBx1 = (popUp.X - sprite_get_width(popUp.sprite)/2) + (hitBar.pos - hitBar.width);
			var hBy1 = (popUp.Y - sprite_get_height(popUp.sprite)/2 + hitBar.height);
			var hBx2 = (popUp.X - sprite_get_width(popUp.sprite)/2) + (hitBar.pos + hitBar.width);
			var hBy2 = (popUp.Y - sprite_get_height(popUp.sprite)/2);
			draw_rectangle(hBx1, hBy1, hBx2, hBy2, false);
			draw_set_color(c_white);
			break;
		case QTEMODE.MULTIHIT:
			draw_set_color(c_red);
			var hTx1 = (popUp.X - sprite_get_width(popUp.sprite)/2) + (hitTarget.pos - hitTarget.width);
			var hTy1 = (popUp.Y - sprite_get_height(popUp.sprite)/2 + hitTarget.height);
			var hTx2 = (popUp.X - sprite_get_width(popUp.sprite)/2) + (hitTarget.pos + hitTarget.width);
			var hTy2 = (popUp.Y - sprite_get_height(popUp.sprite)/2);
			draw_rectangle(hTx1, hTy1, hTx2, hTy2, true);
			var hBx1 = (popUp.X - sprite_get_width(popUp.sprite)/2) + (hitBar.pos - hitBar.width);
			var hBy1 = (popUp.Y - sprite_get_height(popUp.sprite)/2 + hitBar.height);
			var hBx2 = (popUp.X - sprite_get_width(popUp.sprite)/2) + (hitBar.pos + hitBar.width);
			var hBy2 = (popUp.Y - sprite_get_height(popUp.sprite)/2);
			draw_rectangle(hBx1, hBy1, hBx2, hBy2, false);
			draw_set_color(c_white);
			break;
		case QTEMODE.AIM:
			draw_set_color(c_red);
			draw_circle(popUp.X, popUp.Y, chargeCircle.radius, true);
			draw_set_color(c_white);
			break;
		case QTEMODE.MULTIAIM:
			draw_set_color(c_red);
			for(var i = array_length(multiCircle) - 1; i >= 0; i--){
				draw_circle(popUp.X, popUp.Y, multiCircle[i].radius, true);
			}
			draw_set_color(c_white);
			break;
		case QTEMODE.SPELLCHARGE:
			draw_circle(popUp.X, popUp.Y, chargeCircle.radius, false);
			break;
		
	}
}