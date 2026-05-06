context = undefined;
battleInfo = undefined;

playerTeam = false;
netTeam = false;
allwait = true;

atkData = global.data.moves[$"attacks"];
splData = global.data.moves[$"spells"];
effData = global.data.effects;
itemData = global.data.items;

fighter = undefined;

activeTeamQueue = [];
team = [];
waiting = [];

startTurn = function(){
	if (array_length(activeTeamQueue) > 0){
		fighter = activeTeamQueue[0];
		array_delete(activeTeamQueue, 0, 1);
		if(DEBUG_ENABLED) show_debug_message("[TeamMan] " + string(fighter));
		if(DEBUG_ENABLED) show_debug_message("[TeamMan] Starting turn for" + string(fighter[$"name"]));
		if(DEBUG_ENABLED) show_debug_message("[TeamMan] Enemy Team Remaining: " + string(array_length(battleInfo.team2)));
		for(var i = 0; i < array_length(activeTeamQueue); ++i){
			if (DEBUG_ENABLED) show_debug_message("[TeamMan] Current order [" + string(i) + "]: " + string(activeTeamQueue[i][$"name"]));
		}
		if (playerTeam){
			context.menu.turnStart(fighter, fighter.attacks, fighter.spells);
			battleInfo.menuState = BMENUST.ACTION;
		} else if (!netTeam){
			enemyTurn(fighter);
		}
		//for(var i = array_length(fighter[$"buffs"]) - 1; i >=0 ; --i){
		//	if(array_length(fighter[$"buffs"]) > 0){
		//		if (DEBUG_ENABLED) show_debug_message("[TeamMan] Buff takes effect: " + string(fighter[$"buffs"][i]));
		//		context.controller.doBuff(fighter, fighter[$"buffs"][i], i);
		//	}
		//}
		//for(var i = array_length(fighter[$"debuffs"]) - 1; i >=0 ; --i){
		//	if(array_length(fighter[$"debuffs"]) > 0){
		//		context.controller.doDebuff(fighter, fighter[$"debuffs"][i], i);
		//	}
		//}
	} else {
		
	}
}

loadTeam = function(tm){
	team = tm;
	array_copy(waiting, 0, team, 0, array_length(team));
}

endTurn = function(){
	if(DEBUG_ENABLED) show_debug_message("[TeamMan] " + string(playerTeam) + "Ending Turn.");
	if(DEBUG_ENABLED) show_debug_message("[TeamMan] Enemy Team Remaining: " + string(array_length(battleInfo.team2)));
	if (fighter.hp > 0 && !array_contains(waiting, fighter)){
		array_push(waiting, fighter);
	}
	if(DEBUG_ENABLED) show_debug_message("[TeamMan] Enemy Team Remaining: " + string(array_length(battleInfo.team2)));
	if (playerTeam){
		objBattleMenu.turnEnd();
	}
	if (array_length(activeTeamQueue) <= 0){
		allwait = true;
		if (playerTeam){
			battleInfo.menuState = BMENUST.WAIT;
		}
	} else {
		if (global.server < 0){
			startTurn();
		}
	}
}

enemyTurn = function(enemy){
	var actions = array_concat(enemy[$"attacks"], enemy[$"spells"]);
	var choice = -1;
	var action = "";
	if (array_length(actions) > 0){
		choice = irandom(array_length(actions) - 1);
		action = actions[choice];
	} else {
		// UH WTF ERROR?????	
		if (DEBUG_ENABLED) show_message("[BController] No actions loaded!");
	}
	var spdMod = 1;
	
	for (var i = 0; i < array_length(enemy.buffs); ++i){
		var buff = enemy.buffs[i];
		if (buff.abil == "speed"){
			spdMod /= buff.pow;	
		}
	}
	for (var i = 0; i < array_length(enemy.debuffs); ++i){
		var debuff = enemy.debuffs[i];
		if (debuff.abil == "slowness"){
			spdMod /= debuff.pow;	
		}
	}
	
	if (struct_exists(atkData, action)){
		var targets = scrGetTargetable(battleInfo.team1);
		var tIndex = irandom(array_length(targets) - 1);
		var target = targets[tIndex];
		if (scrCheckEffects(enemy[$"debuffs"], effData.debuffs[$"taunted"])){
			tauntInfo = enemy[$"debuffs"][scrGetEffect(enemy[$"debuffs"], effData.debuffs[$"taunted"])];
			target = tauntInfo[$"source"];
		}
		var actor1 = context.menu.getActor(fighter);
		var actor2 = context.menu.getActor(target);
		
		var actInfo = {
			act : action,
			actor : fighter,
			tar : target,
			team : battleInfo.team1,
			isSpell : false,
			isItem : false,
			actorChar : actor1,
			targetChar : actor2
		}
		
		context.controller.doAttack(fighter, action, target, battleInfo.team1, 1, true);
		context.menu.doAnimation(actInfo);
		actor1.startTimer(spdMod);
	} else if (struct_exists(splData, action)){
		var actData = struct_get(splData, action)
		if (actData.type == "dmgSpell" || actData.type == "debuffSpell"){
			var tIndex = irandom(array_length(battleInfo.team1) - 1);
			var target = battleInfo.team1[tIndex];
			if (scrCheckEffects(enemy[$"debuffs"], effData.debuffs[$"taunted"])){
				tauntInfo = enemy[$"debuffs"][scrGetEffect(enemy[$"debuffs"], effData.debuffs[$"taunted"])];
				target = tauntInfo[$"source"];
			}
			
			var actor1 = context.menu.getActor(fighter);
			var actor2 = context.menu.getActor(target);
	
			var actInfo = {
				act : action,
				actor : fighter,
				tar : target,
				team : battleInfo.team1,
				isSpell : true,
				isItem : false,
				actorChar : actor1,
				targetChar : actor2
			}
			
			context.controller.doSpell(fighter, action, target, battleInfo.team1, 1, true);
			context.menu.doAnimation(actInfo);
			actor1.startTimer(spdMod);
		}
		if (actData.type == "restoreSpell" || actData.type == "buffSpell"){
			var tIndex = irandom(array_length(battleInfo.team2) - 1);
			var target = battleInfo.team2[tIndex];
			var actor1 = context.menu.getActor(fighter);
			var actor2 = context.menu.getActor(target);
	
			var actInfo = {
				act : action,
				actor : fighter,
				tar : target,
				team : battleInfo.team1,
				isSpell : true,
				isItem : false,
				actorChar : actor1,
				targetChar : actor2
			}
			
			context.controller.doSpell(fighter, action, target, battleInfo.team2, 1, true);
			context.menu.doAnimation(actInfo);
			actor1.startTimer(spdMod);
		}
		if (actData.type == "selfSpell"){
			var tIndex = irandom(array_length(battleInfo.team2) - 1);
			var actor1 = context.menu.getActor(fighter);
	
			var actInfo = {
				act : action,
				actor : fighter,
				tar : fighter,
				team : battleInfo.team1,
				isSpell : true,
				isItem : false,
				actorChar : actor1,
				targetChar : actor1
			}
			
			context.controller.doSpell(fighter, action, fighter, battleInfo.team2, 1, true);
			context.menu.doAnimation(actInfo);
			actor1.startTimer(spdMod);
		}
		if (actData.type == "dmgSpellAll"){

			var actor1 = context.menu.getActor(fighter);
			for (var i = array_length(battleInfo.team1) - 1; i >= 0; --i;){
			
				var target = battleInfo.team1[i];
				var actor2 = context.menu.getActor(target)
				var actInfo = {
					act : action,
					actor : fighter,
					tar : target,
					team : battleInfo.team1,
					isSpell : true,
					isItem : false,
					actorChar : actor1,
					targetChar : actor2
				}
			
				context.controller.doSpell(fighter, action, target, battleInfo.team1, 1, true);
				context.menu.doAnimation(actInfo);
			}
			actor1.startTimer(spdMod);
		}
	}
}

charReady = function(ftr){
	if (DEBUG_ENABLED) show_debug_message("[BController]" + ftr[$"name"] + " Check Ready!");
	if (scrCheckTeam(waiting, ftr)){
		if (DEBUG_ENABLED) show_debug_message("[BController]" + ftr[$"name"] + " was waiting in this team!");
		var readyInd = scrTeamCharGetInd(waiting, ftr);
		var ready = array_get(waiting, readyInd);
		array_delete(waiting, readyInd, 1);
		array_push(activeTeamQueue, ready);
		if (allwait){
			allwait = false;
			if(global.server < 0){
				startTurn();
			}
		}
	}
}

charDied = function(ftr){
	var ind = -1;
	if (scrCheckTeam(activeTeamQueue, ftr)){
		ind = scrTeamCharGetInd(activeTeamQueue, ftr);
		array_delete(activeTeamQueue, ind, 1);	
	} else if (scrCheckTeam(waiting, ftr)){
		ind = scrTeamCharGetInd(waiting, ftr);
		array_delete(waiting, ind, 1);	
	}
	if (array_length(activeTeamQueue) == 0 && array_length(waiting) == 0){
		if(playerTeam){
			context.controller.endBattle(false);	
		} else {
			context.controller.endBattle(true);
		}
	}
}

charDowned = function(ftr){
	var ind = -1;
	if (scrCheckTeam(activeTeamQueue, ftr)){
		ind = scrTeamCharGetInd(activeTeamQueue, ftr);
		array_delete(activeTeamQueue, ind, 1);	
	}
	if (scrCheckTeam(waiting, ftr)){
		ind = scrTeamCharGetInd(waiting, ftr);
		array_delete(waiting, ind, 1);	
	}
	if (global.server < 0){
		if (array_length(activeTeamQueue) == 0 && array_length(waiting) == 0){
			if(playerTeam){
				context.controller.endBattle(false);	
			} else {
				context.controller.endBattle(true);
			}
		}
	}
}

netStartTurn = function(ftr){
	if (playerTeam) clientLog(string(team));
	if (scrCheckTeam(team, ftr)){
		fighter = ftr;
		if (playerTeam){
			context.menu.turnStart(fighter, fighter.attacks, fighter.spells);
			battleInfo.menuState = BMENUST.ACTION;
		} else if (!netTeam){
			enemyTurn(fighter);
		}
	}
}