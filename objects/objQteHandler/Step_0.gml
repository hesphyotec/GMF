scrGetInput();
if(active){
	switch(mode){
		case QTEMODE.TIMEDHIT:
			if (interactPress){
				if (DEBUG_ENABLED) show_debug_message("[qteHandler] Action pressed!");
				doAction();
				break;
			}
			hitBar.pos += (rate * hitBar.dir);
			if (hitBar.pos < 0 || hitBar.pos > range){
				doMiss();	
			}
			break;
		case QTEMODE.MULTIHIT:
			if (interactPress){
				if (DEBUG_ENABLED) show_debug_message("[qteHandler] Action pressed!");
				doAction();
				break;
			}
			hitBar.pos += rate * hitBar.dir;
			if (hitBar.pos < 0 || hitBar.pos > range){
				doMiss();	
			}
			break;
		case QTEMODE.MULTIAIM:
			if (interactPress){
				if (DEBUG_ENABLED) show_debug_message("[qteHandler] Action pressed!");
				doAction();
				break;
			}
			for(var i = array_length(multiCircle) - 1; i >= 0; --i){
				multiCircle[i].radius -= rate;
				if (multiCircle[0].radius <= 0){
						doMiss();	
				}
			}
			break;
		case QTEMODE.AIM:
			if (interactPress){
				if (chargeCircle.radius > range){
					doMiss();	
				}
				if (DEBUG_ENABLED) show_debug_message("[qteHandler] Action pressed!");
				doAction();
				break;
			}
			chargeCircle.radius -= rate;
			if (chargeCircle.radius <= 0){
				doMiss();	
			}
			break;
		case QTEMODE.SPELLCHARGE:
			if(interactPress){
				charging = true;
				audio_play_sound(sndChargeSpell, 1, false);
			}
			if(charging && interact){
				chargeCircle.radius += rate;
				if (chargeCircle.radius > range){
					if (DEBUG_ENABLED) show_debug_message("[qteHandler] Action pressed!");
					doMiss();	
				}
			}
			if (interactRelease && charging){
				if (DEBUG_ENABLED) show_debug_message("[qteHandler] Action pressed!");
				charging = false;
				audio_stop_sound(sndChargeSpell);
				doAction();
				break;
			}
			break;
	}
}