state = CHARSTATES.WAITING;
isSelected = false;
character = undefined;
splash = undefined;
isPlayerTeam = false;
animating = false;
context = undefined;
battleInfo = undefined;
downed = false;
hovered = false;
tMan = undefined;

yOff = 0;
hpTextOffX = 32;
playerhpTextOffY = 6;
effOffX = sprite_get_width(sprite_index)/2;
effSpace = 12;
dbOffY = 8;
bOffY = 16;
splashY = display_get_gui_height() - (92 * MENU_GUI_SCALE);

atkData = global.data.moves[$"attacks"];
splData = global.data.moves[$"spells"];
itemData = global.data.items;
buffData = global.data.effects[$"buffs"];
debuffData = global.data.effects[$"debuffs"];

timers = {
	wait	: -1,
	channel : -1,
	stun	: -1
}

maxStun = 0;
chanEff = undefined;

loadSprite = function(char){
	character = char;
	if (DEBUG_ENABLED) show_debug_message("[Actor]" + string(character));
	if (character != undefined){
		sprite_index = asset_get_index(character[$"sprite"]);
		if(struct_exists(character, "splash")){
			splash = asset_get_index(character[$"splash"]);
		}
	}
	if (DEBUG_ENABLED) show_debug_message("[Actor] "+ string(sprite_index));
	effOffX = sprite_get_width(sprite_index)/2;
	startTimer(random_range(.2,.7));
	if (DEBUG_ENABLED) show_debug_message("[Actor] " + character[$"name"]);
	if (DEBUG_ENABLED) show_debug_message("[Actor]" + string(character[$"cid"]));
}

doAnim = function(act, actInfo, isActor){
	var prevState = state;
	state = CHARSTATES.ATTACK;
	if (isActor){
		var action = undefined;
		if (struct_exists(atkData, act)){
			action = struct_get(atkData, act);
		} else if (struct_exists(splData, act)){
			if (DEBUG_ENABLED) show_debug_message("[Actor]" + act);
			action = struct_get(splData, act);	
		} else {
			action = act;
		}
		if (DEBUG_ENABLED) show_debug_message("[Actor]" + string(action));
		var anim = undefined;
		anim = asset_get_index(string_concat(character[$"sprite"], act));
		if (DEBUG_ENABLED) show_debug_message("[Actor]" + string(anim));
		if (anim != -1){
			if (DEBUG_ENABLED) show_debug_message("[Actor]" + string(action));
			animating = true;
			sprite_index = anim;
			image_index = 0;
			image_speed = 1;
		}
		var actSound = undefined;
		if (struct_exists(action, "sound")){
			actSound = action[$"sound"];
		}
		if (actSound != undefined){
			var soundId = scrGetSound(actSound);
			if (DEBUG_ENABLED) show_debug_message("[Actor]" + string(soundId));
			if (DEBUG_ENABLED) show_debug_message("[Actor]" + string(action));
			audio_play_sound(soundId, 1, false);
		}
	}
	state = prevState;
}

startTimer = function(bonusSpd){
	state = CHARSTATES.WAITING;
	timers.wait = ceil(((6/character[$"stats"][$"cspd"]) * 400) * bonusSpd);	
}

stun = function(time){
	state = CHARSTATES.STUNNED;
	timers.stun = time;
	maxStun = max(time, maxStun);
}

channel = function(time, effect){
	state = CHARSTATES.CHANNELING;
	timers.channel = time;
}

doDowned = function(){
	downed = true;
	timers.wait = -1;
}

doDied = function(){
	timers.wait = -1;
	instance_destroy(id);
}

timerStep = function(){
	if (timers.wait > 0){
		if (state == CHARSTATES.WAITING){
			if (--timers.wait == 0){
				waitFinish();	
			}
		}
	}
	if (timers.stun > 0){
		if (state == CHARSTATES.STUNNED){
			if (--timers.stun == 0){
				stunFinish();	
			}
		}
	}
	if (timers.channel > 0){
		if (state == CHARSTATES.CHANNELING){
			if (--timers.channel == 0){
				channelFinish();	
			}
		}
	}
}

waitFinish = function(){
	timers.wait = -1;
	state = CHARSTATES.IDLE;
	if(global.isServer){
		tMan.charReady(character);
	} else if(!global.isPlayerBattle){
		if (isPlayerTeam){
			context.controller.teams[0].charReady(character);
		} else {
			context.controller.teams[1].charReady(character);
		}
	}
}

stunFinish = function(){
	timers.stun = -1;
	state = CHARSTATES.IDLE;
	if (timers.wait > 0){
		state = CHARSTATES.WAITING;	
	}
}

channelFinish = function(){
	timers.channel = -1;
	state = CHARSTATES.IDLE;
}

tickEffects = function(){
	var buffs = character[$"buffs"];
	var debuffs = character[$"debuffs"];
	
	for(var i = array_length(buffs) - 1; i >= 0; --i){
		var buff = buffs[i];
		if (buff.duration > 0){
			if ((buff.duration) mod (fps) == 0){
				//if(global.isServer){
					doBuff(buff);
				//}
			}
			--buff.duration;
		} else {
			array_delete(buffs, i, 1);
			if (global.isServer){
				var data = {
					char : character,	
				}
				scrSendAllSock(method(data, function(socket){
					scrNBUpdateChar(socket, char);
				}));	
			}
		}
	}
	
	for(var i = array_length(debuffs) - 1; i >= 0; --i){
		var debuff = debuffs[i];
		if (debuff.duration > 0){
			if ((debuff.duration) mod (fps) == 0){
				//if (global.isServer){
					doDebuff(debuff);
				//}
			}
			--debuff.duration;
		} else {
			array_delete(debuffs, i, 1);	
			if (global.isServer){
				var data = {
					char : character,	
				}
				scrSendAllSock(method(data, function(socket){
					scrNBUpdateChar(socket, char);
				}));	
			}
		}
	}
}

doBuff = function(buff){
	var earlyTurnEnd = false;
	if (DEBUG_ENABLED) show_debug_message("[BCharacter]" + string(buff));
	if (struct_exists(buff, "abil")){
			
	}
	if(earlyTurnEnd && isSelected){
		if (DEBUG_ENABLED) show_debug_message("[BCharacter] Aborting turn");
		//menu.turnEnd();
		context.controller.endTeamTurn(character);
	}
}

doDebuff = function(debuff){
	var earlyTurnEnd = false;
	if (struct_exists(debuff, "abil")){
		if (debuff[$"abil"] == "damage"){
			if (global.isServer){
				context.controller.doDamage(character, character, debuff);
			}
		}
		if (debuff[$"abil"] == "taunt"){
			if(debuff[$"source"].hp <= 0){
				debuff.duration = 0;	
			}
		}
		if (debuff[$"abil"] == "stun"){
			if (state != CHARSTATES.STUNNED){
				stun(debuff.duration);	
			}
		}
		if (debuff[$"abil"] == "recharge"){
			if (state != CHARSTATES.STUNNED){
				stun(debuff.duration);	
			}
			if (DEBUG_ENABLED) show_debug_message("[Actor]" + string(maxStun) + " : " + string(timers.stun) + " : " + string(character.stats[$"maxenergy"]));
			character[$"energy"] = round(((maxStun - timers.stun)) / (maxStun/character.stats[$"maxenergy"]));
		}
	}
	if(earlyTurnEnd && isSelected){
		if (DEBUG_ENABLED) show_debug_message("[BCharacter] Aborting turn");
		//menu.turnEnd();
		context.controller.endTeamTurn(character);
	}
}