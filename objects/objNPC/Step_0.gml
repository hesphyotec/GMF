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
		break;
}


npcMove();