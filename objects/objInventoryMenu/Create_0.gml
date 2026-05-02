open = false;

windowW = 128;
windowH = 64;
windowStartX = 8;
windowStartY = 8;
windowSpace = 8;
windows = [];

invBoxStartX = 12;
invBoxStartY = 12;
invBoxW = 32;
invBoxes = [];
invBoxPad = 4;

backpackX = display_get_gui_width() - 288;
backpackY = display_get_gui_height();
backpackW = 288;
backpackH = 40;

openMenu = function(){
	open = true;
	var r_chars = objPlayer.team;
	var inventories = [];
	for (var i = array_length(r_chars) - 1; i >= 0; --i){	//Gets inventory information and stores needed info
		array_insert(inventories, 0, {inven : r_chars[i].equipment, capacity : r_chars[i].stats.equipMax});
	}
	
	for (var i = 0; i < array_length(inventories); ++i){	//Create all gui elements
		clientLog(string(inventories[i].capacity));
		for (var j = 0; j < inventories[i].capacity; ++j){
			var currInv = inventories[i].inven;
			clientLog(string(inventories[i].capacity) + " : " + string(array_length(currInv)));
			if (j < array_length(currInv)){
				if (currInv[j] != undefined){
					var invBox = createButton(invBoxStartX + (invBoxW + invBoxPad) * (j mod (inventories[i].capacity div 2)), invBoxStartY + ((windowH + windowSpace) * i) + (invBoxW + invBoxPad) * (j div (inventories[i].capacity div 2)), invBoxW, invBoxW, asset_get_index(currInv[j].sprite), GUI.INVDRAGBOX, {item : currInv[j], itemInd : j, charInd : i});
					with (invBox){
						moving = false;
						onClick = function(){
							if (instance_exists(objInTransitObject)){
								if (data.item == undefined){
									objPlayer.equipItem(objInTransitObject.item, data.charInd);
									instance_destroy(objInTransitObject);
								} else {
									var temp = data.item;
									objPlayer.unequipItem(data.charInd, data.itemInd);
									data.item = objInTransitObject.item;
									objInTransitObject.item = temp;
									objInTransitObject.sprite_index = asset_get_index(temp.sprite);
									objPlayer.equipItem(data.item, data.charInd);
								}
							} else {
								if (data.item != undefined){
									var item = instance_create_layer(0, 0, layer, objInTransitObject);
									item.item = data.item;
									item.sprite_index = asset_get_index(data.item.sprite);
									objPlayer.unequipItem(data.charInd, data.itemInd);
									data.item = undefined;
								}
							}
						}
						onHover = function(){
							if (data.item != undefined){
								var itdata = {
									title : data.item.name,
									lines : []
								}
								var info = createButton(mouse_x + 4, mouse_y + 4, 96, 32, sprInfo, GUI.HOVERINFO, itdata);
								info.parent = id;
								info.active = false;
							}
						}
						targetX = xPos;
						tweenSpeed = .3;
					}
					clientLog("Loaded" + string(currInv[j]));
					array_push(invBoxes, invBox);
				}
			} else {
				var invBox = createButton(invBoxStartX + (invBoxW + invBoxPad) * (j mod (inventories[i].capacity / 2)), invBoxStartY + ((windowH + windowSpace) * i) + (invBoxW + invBoxPad) * (j div (inventories[i].capacity div 2)), invBoxW, invBoxW, sprInvBox, GUI.INVDRAGBOX, {item : undefined, itemInd : j, charInd : i});
				clientLog("Loaded empty item");
				with(invBox){
					targetX = xPos;
					tweenSpeed = .1;
					onClick = function(){
						if (instance_exists(objInTransitObject)){
							if (data.item == undefined){
								objPlayer.equipItem(objInTransitObject.item, data.charInd);
								instance_destroy(objInTransitObject);
							} else {
								var temp = data.item;
								objPlayer.unequipItem(data.charInd, data.itemInd);
								data.item = objInTransitObject.item;
								objInTransitObject.item = temp;
								objInTransitObject.sprite_index = asset_get_index(temp.sprite);
								objPlayer.equipItem(data.item, data.charInd);
							}
						} else {
							if (data.item != undefined){
								var item = instance_create_layer(0, 0, layer, objInTransitObject);
								item.item = data.item;
								item.sprite_index = asset_get_index(data.item.sprite);
								objPlayer.unequipItem(data.charInd, data.itemInd);
								data.item = undefined;
							}
						}
					}
					onHover = function(){
						if (data.item != undefined){
							var itdata = {
								title : data.item.name,
								lines : []
							}
							var info = createButton(mouse_x + 4, mouse_y + 4, 96, 32, sprInfo, GUI.HOVERINFO, itdata);
							info.parent = id;
							info.active = false;
						}
					}
				}
				array_push(invBoxes, invBox);
			}
		}
		var window = createButton(windowStartX, windowStartY + ((windowH + windowSpace) * i), windowW, windowH, sprInvBox, GUI.INVCONTAINER, {r_char : r_chars[i]});
		with(window){
			targetX = xPos;
			tweenSpeed = .1;
		}
		array_insert(windows, 0, window);
	}
	
	for(var i = 0; i < ceil(array_length(global.playerData[0].inventory)/8); ++i){
		var bpBoxY = backpackY - (36 * (i + 1));
		for(var j = 0; j < 8; ++j){
			var bpBoxX = 36 * j + backpackX + 6;
			if (((8 * i) + j) < array_length(global.playerData[0].inventory)){
				var item = global.playerData[0].inventory[(8 * i) + j];
				var sprite = sprChestpiece1;
				try {
					sprite = asset_get_index(item.sprite);	
				} catch (e){
					sprite = sprChestpiece1;
				}
				var invBox = createButton(bpBoxX, bpBoxY, invBoxW, invBoxW, sprite, GUI.BACKPACKINVBOX, {item : item, itemInd : (8 * i) + j});
				with(invBox){
					targetY = yPos;
					tweenY = display_get_gui_height();
					tweenSpeed = .1;
					
					moving = false;
					onClick = function(){
						if (instance_exists(objInTransitObject)){
							if (is_undefined(data.item)){
								data.item = objInTransitObject.item;
								global.playerData[0].inventory[data.itemInd] = data.item;
								instance_destroy(objInTransitObject);
							} else {
								var temp = data.item;
								global.playerData[0].inventory[data.itemInd] = undefined;
								objInTransitObject.sprite_index = asset_get_index(data.item.sprite);
								data.item = objInTransitObject.item;
								global.playerData[0].inventory[data.itemInd] = data.item;
								objInTransitObject.item = temp;
							}
						} else {
							if (data.item != undefined){
								var item = instance_create_layer(mouse_x, mouse_y, layer, objInTransitObject);
								item.item = data.item;
								item.sprite_index = asset_get_index(data.item.sprite);
								global.playerData[0].inventory[data.itemInd] = undefined;
								data.item = undefined;
							}
						}
						objInventoryMenu.refreshMenu();
					}
					onHover = function(){
						if (data.item != undefined){
							var itdata = {
								title : data.item.name,
								lines : []
							}
							var info = createButton(mouse_x + 4, mouse_y + 4, 96, 32, sprInfo, GUI.HOVERINFO, itdata);
							info.parent = id;
							info.active = false;
						}
					}
				}
				array_insert(invBoxes, 0, invBox);
			} else {
				var invBox = createButton(bpBoxX, bpBoxY, invBoxW, invBoxW, sprInvBox, GUI.BACKPACKINVBOX, {item : undefined, itemInd : (8 * i) + j});
				clientLog("Loaded empty item");
				with(invBox){
					targetY = yPos;
					tweenY = display_get_gui_height();
					tweenSpeed = .1;
					moving = false;
					onClick = function(){
						if (instance_exists(objInTransitObject)){
							if (is_undefined(data.item)){
								data.item = objInTransitObject.item;
								array_insert(global.playerData[0].inventory, data.itemInd, data.item);
								instance_destroy(objInTransitObject);
							} else {
								var temp = data.item;
								array_delete(global.playerData[0].inventory, data.itemInd, 1);
								data.item = objInTransitObject.item;
								array_insert(global.playerData[0].inventory, data.itemInd, data.item);
								objInTransitObject.item = temp;
							}
						} else {
							if (data.item != undefined){
								var item = instance_create_layer(mouse_x, mouse_y, layer, objInTransitObject);
								item.item = data.item;
								item.sprite_index = asset_get_index(data.item.sprite);
								array_insert(global.playerData[0].inventory, data.itemInd, data.item);
								data.item = undefined;
							}
						}
						objInventoryMenu.refreshMenu();
					}
					onHover = function(){
						if (data.item != undefined){
							var itdata = {
								title : data.item.name,
								lines : []
							}
							var info = createButton(mouse_x + 4, mouse_y + 4, 96, 32, sprInfo, GUI.HOVERINFO, itdata);
							info.parent = id;
							info.active = false;
						}
					}
				}
				array_insert(invBoxes, 0, invBox);
			}
		}
	}
	var bpH = (array_length(global.playerData[0].inventory) div 8) * 32 + 64;
	var backpackBG = createButton(backpackX, backpackY - bpH, backpackW, bpH, sprInfo, GUI.BACKPACKCONTAINER, {});
	with (backpackBG){
		targetY = yPos;
		tweenY = display_get_gui_height();
		tweenSpeed = .1;	
	}
	array_insert(windows, 0, backpackBG);
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
	with (objMenuComponent){
		tweenX = xPos;
		tweenY = yPos;
	}
}