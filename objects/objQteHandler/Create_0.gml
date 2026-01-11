context = undefined;
battleInfo = undefined;

atkData = global.data.moves[$"attacks"];
splData = global.data.moves[$"spells"];

action = undefined;
qteAct = undefined;
mode = undefined;
active = false;


strength = 0;
rate = 0;
range = 0;
start = 0;
charging = false;
rateMod = 1;

actionInfo = undefined

popUp = {
	sprite : undefined,
	X : 32,
	Y : 32
}

hitTarget = {
	active	: false,
	pos		: 0,
	width	: 4,
	height	: sprite_get_height(sprQTETimedHit)
}

hite = 1;

hitBar = {
	active	: false,
	pos		: 0,
	width	: 4,
	height	: sprite_get_height(sprQTETimedHit),
	dir		: 1 // -1 for left, 1 for right
}

chargeCircle = {
	active	: false,
	radius	: 0
}

multiCircle = [];

loadQTE = function(info){
	if (DEBUG_ENABLED) show_debug_message("[qteHandler] Loading QTE");
	if (DEBUG_ENABLED) show_debug_message(string(info));
	actionInfo = info;
	
	if (actionInfo.isSpell){
		action = struct_get(splData, actionInfo.act);	
	} else {
		action = struct_get(atkData, actionInfo.act);	
	}
	
	if (struct_exists(action, "action")){
		qteAct = action[$"action"];	
	} else {
		doMove(true);
		stopQTE();
		return;
	}
	getRateMod();
	startQTE();
}

startQTE = function(){
	if (DEBUG_ENABLED) show_debug_message("[qteHandler] Starting QTE");
	if (qteAct == "instant"){
		strength = 1;
		doMove(true);
		stopQTE();
		return;
	} else if (qteAct == "timedHit"){
		mode = QTEMODE.TIMEDHIT;
		popUp.sprite = sprQTETimedHit;
		range = sprite_get_width(sprQTETimedHit);
		var coords = scrRoomToGui(actionInfo.targetChar.x, actionInfo.targetChar.y - 32);
		popUp.X = coords[0];
		popUp.Y = coords[1];
		if (DEBUG_ENABLED) show_debug_message("[qteHandler]" + string(popUp.sprite));
		hitTarget.active = true;
		hitTarget.pos = irandom_range((range/2) - 16, (range/2) + 16);
		if (hitTarget.pos < (range / 2)){
			start = range;
			hitBar.pos = start;
			hitBar.dir = -1;
		} else {
			start = 0;
			hitBar.pos = start;
			hitBar.dir = 1;
		}
		if (struct_exists(action, "speed")){
			rate = action[$"speed"] * rateMod;
		}
		hitBar.active = true;
	} else if (qteAct == "multiHit"){
		mode = QTEMODE.MULTIHIT;
		popUp.sprite = sprQTETimedHit;
		var coords = scrRoomToGui(actionInfo.targetChar.x, actionInfo.targetChar.y - 32);
		popUp.X = coords[0];
		popUp.Y = coords[1];
		range = sprite_get_width(sprQTETimedHit);
		hits = 3;
		if (struct_exists(action, "hits")){
			hits = action[$"hits"];
		}
		hitTarget.active = true;
		hitTarget.pos = irandom_range((range/2) - 16, (range/2) + 16);
		if (hitTarget.pos < (range / 2)){
			start = range;
			hitBar.pos = start;	
			hitBar.dir = -1;
		} else {
			start = 0;
			hitBar.pos = start;
			hitBar.dir = 1;
		}
		
		if (struct_exists(action, "speed")){
			rate = action[$"speed"] * rateMod;
		}
		hitBar.active = true;
	} else if (qteAct == "multiAim"){
		mode = QTEMODE.MULTIAIM;
		popUp.sprite = sprQTEAim;
		var coords = scrRoomToGui(actionInfo.targetChar.x, actionInfo.targetChar.y - 32);
		popUp.X = coords[0];
		popUp.Y = coords[1];
		range = sprite_get_width(sprQTEAim)/2;
		hits = 5;
		if (struct_exists(action, "hits")){
			hits = action[$"hits"];
		}
		for(var i = 0; i < hits; ++i){
			start = range * (1.5 + .5 * i);
			chargeCircle.radius = start;
			if (struct_exists(action, "speed")){
				rate = action[$"speed"] * rateMod;
			}
		
			if (struct_exists(action, "speed")){
				rate = action[$"speed"] * rateMod;
			}
			chargeCircle.active = true;
			var circ = variable_clone(chargeCircle);
			array_push(multiCircle, circ);
		}
	} else if (qteAct == "aimCharge"){
		mode = QTEMODE.AIM;
		popUp.sprite = sprQTEAim;
		var coords = scrRoomToGui(actionInfo.targetChar.x, actionInfo.targetChar.y - 32);
		popUp.X = coords[0];
		popUp.Y = coords[1];
		range = sprite_get_width(sprQTEAim)/2;
		start = range * 2;
		chargeCircle.radius = start;
		if (struct_exists(action, "speed")){
			rate = action[$"speed"] * rateMod;
		}
		chargeCircle.active = true;
	} else if (qteAct == "spellCharge"){
		mode = QTEMODE.SPELLCHARGE;
		popUp.sprite = sprQTECharge;
		popUp.X = display_get_gui_width() * .5;
		popUp.Y = display_get_gui_height() * .75;
		range = sprite_get_width(sprQTECharge)/2;
		start = 0;
		chargeCircle.radius = start;
		if (struct_exists(action, "speed")){
			rate = action[$"speed"] * rateMod;
		}
		chargeCircle.active = true;
		
	}
	battleInfo.menuState = BMENUST.QTE;
	alarm[0] = 5;
}

doMiss = function(){
	if (DEBUG_ENABLED) show_debug_message("[qteHandler] Missed QTE");
	switch(mode){
		case QTEMODE.TIMEDHIT:
			audio_play_sound(sndNoResource, 1, false);
			context.controller.doMiss(actionInfo.actor, true);
			stopQTE();
			break;
			//tell controller that we missed
		case QTEMODE.MULTIHIT:
			audio_play_sound(sndNoResource, 1, false);
			if (--hits > 0){
				if (hitTarget.pos < range/2){
					hitBar.pos = range;	
					hitBar.dir = -1;
				} else {
					hitBar.pos = 0;
					hitBar.dir = 1;
				}
			} else {
				context.controller.doMiss(actionInfo.actor, true);
				stopQTE();
				//tell controller that we missed
			}
			break;
		case QTEMODE.AIM:
			audio_play_sound(sndNoResource, 1, false);
			context.controller.doMiss(actionInfo.actor, true);
			stopQTE();
			break;
			//tell controller that we missed
		case QTEMODE.MULTIAIM:
			audio_play_sound(sndNoResource, 1, false);
			array_delete(multiCircle,0,1);
			if (--hits > 0){
				//--hits;
			} else {
				context.controller.doMiss(actionInfo.actor, true);
				stopQTE();
				//tell controller that we missed
			}
			break;
		case QTEMODE.SPELLCHARGE:
			audio_play_sound(sndNoResource, 1, false);
			context.controller.doMiss(actionInfo.actor, true);
			stopQTE();
			break;
			//tell controller that we missed
	}
}

doAction = function(){
	if (DEBUG_ENABLED) show_debug_message("[qteHandler] Finishing QTE");
	switch(mode){
		case QTEMODE.TIMEDHIT:
			strength = (1.5 * clamp(1 - (abs(hitTarget.pos - hitBar.pos) / abs(hitTarget.pos - start)), 0, 1));
			doMove(true);
			stopQTE();
			break;
		case QTEMODE.MULTIHIT:
			strength = (1.5 * clamp(1 - (abs(hitTarget.pos - hitBar.pos) / abs(hitTarget.pos - start)), 0, 1));
			if (--hits > 0){
				doMove(false);
				if (target[$"hp"] <= 0){
					stopQTE();
					context.playerTeam.endTurn();
				}
				hitTarget.active = true;
				hitTarget.pos = irandom_range((range/2) - 16, (range/2) + 16);
				if (hitTarget.pos < (range / 2)){
					start = range;
					hitBar.pos = start;	
					hitBar.dir = -1;
				} else {
					start = 0;
					hitBar.pos = start;
					hitBar.dir = 1;
				}
				hitBar.active = true;
			} else {
				doMove(true);
				stopQTE();	
			}
			break;
		case QTEMODE.AIM:
			strength = (1.5 * clamp(1 - (abs(chargeCircle.radius) / abs(range)), 0, 1));
			doMove(true);
			stopQTE();
			break;
		case QTEMODE.MULTIAIM:
			strength = (1.5 * clamp(1 - (abs(multiCircle[0].radius) / abs(range)), 0, 1));
			array_delete(multiCircle, 0, 1);
			if (--hits > 0){
				doMove(false);
				if (target[$"hp"] <= 0){
					stopQTE();
					context.playerTeam.endTurn();
				}
			} else {
				doMove(true);
				stopQTE();	
			}
			break;
		case QTEMODE.SPELLCHARGE:
			strength = (1.5 * clamp(1 - (abs(chargeCircle.radius - range) / abs(range - start)), 0, 1));
			doMove(true);
			stopQTE();
			break;
	}
}

doMove = function(final){
	if (actionInfo.isSpell){
		context.menu.doAnimation(actionInfo);
		clientLog("Action strength: " + string(strength));
		if(global.server >= 0){
			scrNBDoSpell(global.server, actionInfo, strength, final);
		} else {
			context.controller.doSpell(actionInfo.actor, actionInfo.act, actionInfo.tar, actionInfo.team, strength, final);
		}
	} else {
		context.menu.doAnimation(actionInfo);
		if(global.server >= 0){
			scrNBDoAttack(global.server, actionInfo, strength, final);
		} else {
			context.controller.doAttack(actionInfo.actor, actionInfo.act, actionInfo.tar, actionInfo.team, strength, final);
		}
	}
}

stopQTE = function(){
	if (DEBUG_ENABLED) show_debug_message("[qteHandler] Ending QTE");
	battleInfo.menuState = BMENUST.ACTION;
	qteAct = undefined;
	mode = undefined;
	active = false;
	strength = 0;
	rate = 0;
	rateMod = 1;
	range = 256;
	popUp = {
		sprite : undefined,
		X : display_get_gui_width()/2,
		Y : 640
	}
}

getRateMod = function(){
	var buffs = actionInfo.actor[$"buffs"];
	var debuffs = actionInfo.actor[$"debuffs"];
	
	for(var i = array_length(buffs) - 1; i >= 0; --i){
		var buff = buffs[i];
		if (buff.abil == "focus"){
			rateMod -= buff.pow;	
		}
	}
}