// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function csForcePlayerMove(xx, yy, relative, wait){
	if (!moveStart){
		mtarget = [xx, yy];
		if (relative){
			mtarget = [objOWPlayer.mapSpace[0] + xx, objOWPlayer.mapSpace[1] + yy];
		}
	
		ds_list_copy(objOWPlayer.movePath, getPath(objOWPlayer.mapSpace, mtarget));	
		moveStart = true;
	}
	if (wait){
		if (objOWPlayer.x == mtarget[0] * TILE_SIZE && objOWPlayer.y == mtarget[1] * TILE_SIZE){
			moveStart = false;
			csEndAction();
			return;
		}
	} else {
		moveStart = false;
		csEndAction();	
	}
}