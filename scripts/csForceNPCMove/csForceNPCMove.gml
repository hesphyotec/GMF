// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function csForceNPCMove(obj, xx, yy, relative, wait){
	if (!moveStart){
		mtarget = [xx, yy];
		if (relative){
			mtarget = [obj.mapSpace[0] + xx, obj.mapSpace[1] + yy];
		}
	
		obj.getMoveTarget(mtarget);
		moveStart = true;
	}
	if (wait){
		if (obj.x == mtarget[0] * TILE_SIZE && obj.y == mtarget[1] * TILE_SIZE){
			moveStart = false;
			csEndAction();
			return;
		}
	} else {
		moveStart = false;
		csEndAction();	
	}
}