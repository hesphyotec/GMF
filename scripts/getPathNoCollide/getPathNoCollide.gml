//// Script assets have changed for v2.3.0 see
//// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function getPathNoCollide(startPos, endPos){
	var startNode = new gridNode(startPos[0], startPos[1]);
	var endNode = new gridNode(0, 0);
	var nodePath = ds_list_create();
	var arrNP = [];
	if (isValidPos(endPos[0], endPos[1])){
		endNode = new gridNode(endPos[0], endPos[1]);
	} else {
		//show_message("Invalid position" + string(endPos));
		return nodePath;	
	}
	
	if(startPos[0] == endPos[0] && startPos[1] == endPos[1]){
		return nodePath;	
	}
	
	var closed = ds_grid_create(floor(room_width / TILE_SIZE), floor(room_height / TILE_SIZE));
	ds_grid_set_region(closed, 0, 0, floor(room_width / TILE_SIZE), floor(room_height / TILE_SIZE), false);
	var distGrid = ds_grid_create(floor(room_width / TILE_SIZE), floor(room_height / TILE_SIZE));
	ds_grid_set_region(distGrid, 0, 0, floor(room_width / TILE_SIZE), floor(room_height / TILE_SIZE), infinity);
	ds_grid_set(distGrid, startPos[0], startPos[1], 0);
	var open = ds_priority_create();
	startNode.f = 0;
	startNode.g = 0;
	startNode.h = 0;
	ds_priority_add(open, startNode, startNode.f);
	var destFound = false;
	var destNode = undefined;
	
	var fNew = 0;
	var gNew = 0;
	var hNew = 0;
	while (!ds_priority_empty(open)){
		//show_message("Beginning search!");
		var aNode = ds_priority_delete_min(open);
		ds_grid_set(closed, aNode.gx, aNode.gy, true);
		
		if (isValidPos(aNode.gx, aNode.gy - 1)){
			//show_message("Valid pos!");
			var nNode = new gridNode(aNode.gx, aNode.gy - 1);
			if (nNode.gx == endNode.gx && nNode.gy == endNode.gy){
				nNode.prev = aNode;
				destFound = true;
				destNode = nNode;
				//show_message("Dest found!");
				break;
			} else if (ds_grid_get(closed, nNode.gx, nNode.gy) == false){
				gNew = aNode.g + 1;
				hNew = getManDist(nNode, endNode);
				fNew = gNew + hNew;
				
				if (ds_grid_get(distGrid, nNode.gx, nNode.gy) > fNew){
					nNode.g = gNew;
					nNode.h = hNew;
					nNode.f = fNew;
					nNode.prev = aNode;
					ds_priority_add(open, nNode, fNew);
					ds_grid_set(distGrid, nNode.gx, nNode.gy, fNew);
				}
			} 
		}
		
		if (isValidPos(aNode.gx, aNode.gy + 1)){
			var sNode = new gridNode(aNode.gx, aNode.gy + 1);
			if (sNode.gx == endNode.gx && sNode.gy == endNode.gy){
				sNode.prev = aNode;
				destFound = true;
				destNode = sNode;
				//show_message("Dest found!");
				break;
			} else if (ds_grid_get(closed, sNode.gx, sNode.gy) == false){
				gNew = aNode.g + 1;
				hNew = getManDist(sNode, endNode);
				fNew = gNew + hNew;
				
				if (ds_grid_get(distGrid, sNode.gx, sNode.gy) > fNew){
					sNode.g = gNew;
					sNode.h = hNew;
					sNode.f = fNew;
					sNode.prev = aNode;
					ds_priority_add(open, sNode, fNew);
					ds_grid_set(distGrid, sNode.gx, sNode.gy, fNew);
				}
			}
		}
		
		if (isValidPos(aNode.gx - 1, aNode.gy)){
			var eNode = new gridNode(aNode.gx - 1, aNode.gy);
			if (eNode.gx == endNode.gx && eNode.gy == endNode.gy){
				eNode.prev = aNode;
				destFound = true;
				destNode = eNode;
				//show_message("Dest found!");
				break;
			} else if (ds_grid_get(closed, eNode.gx, eNode.gy) == false){
				gNew = aNode.g + 1;
				hNew = getManDist(eNode, endNode);
				fNew = gNew + hNew;
				
				if (ds_grid_get(distGrid, eNode.gx, eNode.gy) > fNew){
					eNode.g = gNew;
					eNode.h = hNew;
					eNode.f = fNew;
					eNode.prev = aNode;
					ds_priority_add(open, eNode, fNew);
					ds_grid_set(distGrid, eNode.gx, eNode.gy, fNew);
				}
			}
		}
		
		if (isValidPos(aNode.gx + 1, aNode.gy)){
			var wNode = new gridNode(aNode.gx + 1, aNode.gy);
			if (wNode.gx == endNode.gx && wNode.gy == endNode.gy){
				wNode.prev = aNode;
				destFound = true;
				destNode = wNode;
				//show_message("Dest found!");
				break;
			} else if (ds_grid_get(closed, wNode.gx, wNode.gy) == false){
				gNew = aNode.g + 1;
				hNew = getManDist(wNode, endNode);
				fNew = gNew + hNew;
				
				if (ds_grid_get(distGrid, wNode.gx, wNode.gy) > fNew){
					wNode.g = gNew;
					wNode.h = hNew;
					wNode.f = fNew;
					wNode.prev = aNode;
					ds_priority_add(open, wNode, fNew);
					ds_grid_set(distGrid, wNode.gx, wNode.gy, fNew);
				}
			}
		}
	}
	
	if (destFound){
		var pathNode = destNode;
		while(pathNode.prev != undefined || pathNode != startNode){
			ds_list_insert(nodePath, 0, pathNode);
			array_insert(arrNP, 0, pathNode);
			pathNode = pathNode.prev;
		}
		//ds_list_insert(nodePath, 0, startNode);
	}
	//show_message(string(array_length(arrNP)));
	ds_grid_destroy(distGrid);
	ds_grid_destroy(closed);
	ds_priority_destroy(open);
	return nodePath;
}