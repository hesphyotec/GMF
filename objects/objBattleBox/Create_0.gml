options = [];
selected = 0;
context = undefined;
fighter = undefined;
draw_set_font(fntBattle);

columns = 2;
bOffX = 32;
bOffY = 32;
spacing = 16;
borderOffX = 8;
borderOffY = 8;
battleInfo = objBattleController.battleInfo;

battleInfo.menuState = BMENUST.ACTION;

attackData = global.data.moves[$"attacks"];
spellData = global.data.moves[$"spells"];
itemData = global.data.items;

currBox = {
	X : 0,
	Y : 0
}

actionBox = {
	activeY			: display_get_gui_height() - 92,
	inactiveY		: display_get_gui_height() - 16,
	X				: [91 * MENU_GUI_SCALE, 152 * MENU_GUI_SCALE, 213 * MENU_GUI_SCALE, 274 * MENU_GUI_SCALE],	
	menuTextOffX	: 4 * MENU_GUI_SCALE, 
	menuTextSpaceY	: 16 * MENU_GUI_SCALE,
	menuHeaderY		: 100 * MENU_GUI_SCALE,
	menuTextY		: 80 * MENU_GUI_SCALE
}

currNameTextY = display_get_gui_height() - 88 * MENU_GUI_SCALE;
currHPTextY = display_get_gui_height() - 72 * MENU_GUI_SCALE;
infoBoxX = 188 * MENU_GUI_SCALE; 

cards = [];
buttons = [];
charmasks = [];
focus = undefined;

loadButtons = function(ops){
	options = [];
	for(var i = 0; i < array_length(ops); i++){
		array_push(options, getOpText(ops[i]));
	}
	attacks = objBattleMenu.attacks;
	spells = objBattleMenu.spells;
}

getOpText = function(op){
	if (op == BOPS.ATTACK){
		return "ATTACK";	
	}
	
	if (op == BOPS.SPELL){
		return "SKILLS";	
	}
	
	if (op == BOPS.ITEM){
		return "ITEM";	
	}
	
	if (op == BOPS.FLEE){
		return "FLEE";	
	}
	
	if (struct_get(global.data.moves[$"attacks"], op)){
		return struct_get(global.data.moves[$"attacks"], op)[$"name"];
	}
	
	if (struct_get(global.data.moves[$"spells"], op)){
		return struct_get(global.data.moves[$"spells"], op)[$"name"];
	}
	if (battleInfo.menuState == BMENUST.TARGET || battleInfo.menuState == BMENUST.FLEE){
		return op;	
	}
	if (array_contains(battleInfo.inventory, op)){
		return op[$"name"];	
	}
	
	return "ERROR";
}

loadFighter = function(ftr){
	fighter = ftr;	
}

loadGUIButtons = function(){
	clearButtons();
	for (var i = 0; i < array_length(options); i++){
		//draw_text_ext(actionBox.X[0] + actionBox.menuTextOffX, actionBox.activeY - actionBox.menuTextY + (actionBox.menuTextSpaceY * i), options[i], spacing, maxTextW);
		var button = createButton(actionBox.X[0] + actionBox.menuTextOffX, actionBox.activeY + (actionBox.menuTextSpaceY * (i + 1)), sprite_get_width(sprActionBox), 16, sprButtonTest, GUI.BATTLEOPTION, {text : options[i], index : i});
		with(button){
			onClick = function(){
				objBattleMenu.selection = data.index;
				switch(objBattleMenu.battleInfo.menuState){
					case BMENUST.ATTACK:
						objBattleMenu.selectAttack();
						break;
					case BMENUST.SPELL:
						objBattleMenu.selectSpell();
						break;
					case BMENUST.ITEMS:
						objBattleMenu.selectItem();
						break;
					case BMENUST.TARGET:
						objBattleMenu.selectTarget();
						break;
				}
			}
		}
		if (battleInfo.menuState == BMENUST.TARGET){
			with(button){
				onHover = function(){
					objBattleMenu.selection = data.index;	
				}
			}
		}
		array_push(buttons, button);
	}
}

loadGUICards = function(){
	clearCards();
	clearButtons();
	for(var i = 0; i < array_length(options); ++i){
		var card = createButton(actionBox.X[i], actionBox.activeY, sprite_get_width(sprActionBox), sprite_get_height(sprActionBox), sprActionBox, GUI.BATTLECARD, {actionBox: actionBox, buttons : [], text : options[i]});
		card.tweenY = actionBox.inactiveY;
		switch(i){
			case 0:
				for (var j = 0; j < array_length(attacks); j++){
					var textInfo = {
						text : struct_get(attackData, attacks[j])[$"name"],
						spacing : spacing
					};
					array_push(card.data.buttons, textInfo);
					with (card){
						onClick = function(){
							objBattleMenu.doFunction(BOPS.ATTACK);
						}
					}
				}
				break;
			case 1:
				for (var j = 0; j < array_length(spells); j++){
					var textInfo = {
						text : struct_get(spellData, spells[j])[$"name"],
						spacing : spacing
					};
					array_push(card.data.buttons, textInfo);
					with (card){
						onClick = function(){
							objBattleMenu.doFunction(BOPS.SPELL);
						}
					}
				}
				break;
			case 2:
				for (var j = 0; j < array_length(battleInfo.inventory); j++){
					var textInfo = {
						text : battleInfo.inventory[j].name,
						spacing : spacing
					};
					array_push(card.data.buttons, textInfo);
					with (card){
						onClick = function(){
							objBattleMenu.doFunction(BOPS.ITEM);
						}
					}
				}
				break;
			case 3:
				with (card){
					onClick = function(){
						objBattleMenu.doFunction(BOPS.FLEE);
					}
				}
				break;
		}
		card.master = id;
		array_push(cards, card);
	}
}

loadContainerCard = function(op){
	clearCards();
	var card = createButton(actionBox.X[0], actionBox.activeY, sprite_get_width(sprActionBox), sprite_get_height(sprActionBox), sprActionBox, GUI.BATTLECARDCONTAINER, {actionBox: actionBox, buttons : [], text : getOpText(op)});
	array_push(cards, card);
}

clearCards = function(){
	for(var i = array_length(cards) - 1; i >= 0; --i){
		instance_destroy(cards[i]);
		array_delete(cards, i, 1);
	}
	focus = undefined;
}

clearButtons = function(){
	for(var i = array_length(buttons) - 1; i >= 0; --i){
		instance_destroy(buttons[i]);
		array_delete(buttons, i, 1);
	}
}

loadCharMasks = function(team){
	for(var i = array_length(options) - 1; i >= 0; --i){
		var char = team[i];
		var actor = context.menu.actors[context.menu.charGetActorInd(char)];
		var maskX = actor.x - sprite_get_width(actor.sprite_index)/2;
		var maskY = actor.y - sprite_get_height(actor.sprite_index);
		var mask = createButton(maskX, maskY, sprite_get_width(actor.sprite_index), sprite_get_height(actor.sprite_index), actor.sprite_index, GUI.CHARMASK, {index : i});
		with(mask){
			with(mask){
				onHover = function(){
					objBattleMenu.selection = data.index;	
				}
				onClick = function(){
					objBattleMenu.selection = data.index;	
					objBattleMenu.selectTarget();	
				}
			}	
		}
		array_push(charmasks, mask);
	}
}

clearMasks = function(){
	for(var i = array_length(charmasks) - 1; i >= 0; --i){
		instance_destroy(charmasks[i]);
		array_delete(charmasks, i, 1);
	}
}