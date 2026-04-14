if (instance_place(x, y, objOWPlayer)){
	onInteract(global.players[0].team);
}
switch(state){
	case(ENEMYSTATE.IDLE):
		if (!moving){
			clientLog(moveTimer);
			if (moveTimer <= 0){
				var moveX = irandom_range(-idleWanderRange, idleWanderRange);
				var moveY = irandom_range(-idleWanderRange, idleWanderRange);
				var mTar = [mapSpace[0] + moveX, mapSpace[1] + moveY];
				getMoveTarget(mTar);
				moveTimer = irandom_range(moveTimerMin, moveTimerMax);
			} else {
				--moveTimer;
			}
		}
		if (checkPlayerInVision() && !passive){
			state = ENEMYSTATE.CHASE;
			spd = chaseSpd;
			audio_play_sound(sndMonsterDeath, 1, false, global.effVolume);
		}
		break;
	case(ENEMYSTATE.CHASE):
		if ((objOWPlayer.mapSpace[0] != chaseTarget[0]) || (objOWPlayer.mapSpace[1] != chaseTarget[1])){
			ds_list_clear(movePath);
			getMoveTarget(objOWPlayer.mapSpace);
			chaseTarget = variable_clone(objOWPlayer.mapSpace);
		}
		break;
}


enemyMove();
