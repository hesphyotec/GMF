open = false;

windowW = 128;
windowH = 64;
windowStartX = 8;
windowStartY = 4;
windowSpace = 4;
windows = [];

invBoxStartX = 12;
invBoxStartY = 4;
invBoxW = 32;
invBoxes = [];

openMenu = function(){
	open = true;
	var r_chars = objPlayer.team;
	var inventories = [];
	for (var i = 0; i < array_length(r_chars); ++i){	//Gets inventory information and stores needed info
		array_insert(inventories, 0, {inven : r_chars[i].equipment, capacity : r_chars[i].stats.equipMax});
	}
	
	for (var i = 0; i < array_length(inventories); ++i){	//Create all gui elements
		clientLog(string(inventories[i].capacity));
		for (var j = 0; j < inventories[i].capacity; ++j){
			var currInv = inventories[i].inven;
			clientLog(string(inventories[i].capacity) + " : " + string(array_length(currInv)));
			if (j < array_length(currInv)){
				if (currInv[j] != undefined){
					var invBox = createButton(invBoxStartX + invBoxW * (j mod (inventories[i].capacity div 2)), invBoxStartY + ((windowH + windowSpace) * i) + invBoxW * (j div (inventories[i].capacity div 2)), invBoxW, invBoxW, asset_get_index(currInv[j].sprite), GUI.INVDRAGBOX, {item : currInv[j], itemInd : j, charInd : i});
					with (invBox){
						moving = false;
						onClick = function(){
							if (!moving){
								moving = true;
							} else {
								moving = false;	
							}
						}
					}
					clientLog("Loaded" + string(currInv[j]));
					array_push(invBoxes, invBox);
				}
			} else {
				var invBox = createButton(invBoxStartX + invBoxW * (j mod (inventories[i].capacity / 2)), invBoxStartY + ((windowH + windowSpace) * i) + invBoxW * (j div (inventories[i].capacity div 2)), invBoxW, invBoxW, sprInvBox, GUI.INVDRAGBOX, {item : undefined});
				clientLog("Loaded empty item");
				array_push(invBoxes, invBox);
			}
		}
		array_insert(windows, 0, createButton(windowStartX, windowStartY + ((windowH + windowSpace) * i), windowW, windowH, sprInvBox, GUI.INVCONTAINER, {r_char : r_chars[i]}));
	}
}

closeMenu = function(){
	for (var i = 0; i < array_length(invBoxes); ++i){
		instance_destroy(invBoxes[i]);
	}
	invBoxes = [];
	for (var i = 0; i < array_length(windows); ++i){
		instance_destroy(windows[i]);
	}
	windows = [];
	open = false;
}

refreshMenu = function(){
	closeMenu();
	openMenu();
}