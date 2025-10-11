options = [];
selected = 0;
draw_set_font(fntBattle);

columns = 2;
bOffX = 96;
bOffY = 32;
borderOffX = 8;
borderOffY = 8;
battleInfo = objBattleController.battleInfo;

battleInfo.menuState = BMENUST.ACTION;
//currentChar = undefined;
attackData = global.data.moves[$"attacks"];
spellData = global.data.moves[$"spells"];
itemData = global.data.items;

currBox = {
	X : 0,
	Y : 0
}

//currBoxX = 0;
//currBoxY = 0;

actionBox = {
	activeY			: display_get_gui_height(),
	inactiveY		: display_get_gui_height() + 92 * MENU_GUI_SCALE,
	X				: [91 * MENU_GUI_SCALE, 152 * MENU_GUI_SCALE, 213 * MENU_GUI_SCALE, 274 * MENU_GUI_SCALE],	
	menuTextOffX	: 4 * MENU_GUI_SCALE, 
	menuTextSpaceY	: 16 * MENU_GUI_SCALE,
	menuHeaderY		: 100 * MENU_GUI_SCALE,
	menuTextY		: 80 * MENU_GUI_SCALE
}
//actionBoxActiveY = display_get_gui_height();
//actionBoxInactiveY = display_get_gui_height() + 92 * MENU_GUI_SCALE;
//actionBoxX = [91 * MENU_GUI_SCALE, 152 * MENU_GUI_SCALE, 213 * MENU_GUI_SCALE, 274 * MENU_GUI_SCALE];
//actionMenuTextOffX = 4 * MENU_GUI_SCALE;
//actionMenuTextSpaceY = 16 * MENU_GUI_SCALE;
//actionMenuHeaderY = 100 * MENU_GUI_SCALE;
//actionMenuTextY = 80 * MENU_GUI_SCALE;
currNameTextY = display_get_gui_height() - 88 * MENU_GUI_SCALE;
currHPTextY = display_get_gui_height() - 72 * MENU_GUI_SCALE;
infoBoxX = 188 * MENU_GUI_SCALE; 

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