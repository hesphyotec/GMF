menuFunctions = {
	multiPlayer : {
		type : GUI.TEXTBUTTON,
		onClick : function(){
			//Open Server / Client / Join
		},
		text : "Multiplayer"
	},
	options : {
		type : GUI.TEXTBUTTON,
		onClick : function(){
			objMainMenu.state = MAINMEN.OPTIONS;
		},
		text : "Options"
	},
	quit : {
		type : GUI.TEXTBUTTON,
		onClick : function(){
			game_end();
		},
		text : "Quit"
	},
	newGame : {
		type : GUI.TEXTBUTTON,
		onClick : function(){
			objGame.storyGenPlayer();
			room_goto(rmPrologue1);
		},
		text : "New Game"
	},
	loadGame : {
		type : GUI.TEXTBUTTON,
		onClick : function(){
			loadFull();
		},
		text : "Continue Game"
	},
	back : {
		type : GUI.TEXTBUTTON,
		onClick : function(){
			objMainMenu.state = MAINMEN.START;
		},
		text : "Back"
	},
	singlePlayer : {
		type : GUI.TEXTBUTTON,
		onClick : function(){
			objMainMenu.state = MAINMEN.SINGLE;
		},
		text : "Single Player"
	},
	masterVolume : {
		type : GUI.SLIDER,
		text : "Master Volume",
		slideVal : global.masVolume,
		onClick : function(){},
		onHold : function(owner){
			with (objMenuComponent){
				active = false;	
			}
			owner.active = true;
			owner.slideVal = (device_mouse_x_to_gui(0) - owner.xPos) / owner.width;
			global.masVolume = owner.slideVal;
			audio_master_gain(global.masVolume);
		},
		init : function(owner){
			owner.slideVal = global.masVolume;
		}
	},
	musicVolume : {
		type : GUI.SLIDER,
		text : "Music Volume",
		slideVal : global.musVolume,
		onClick : function(){},
		onHold : function(owner){
			with (objMenuComponent){
				active = false;	
			}
			owner.active = true;
			owner.slideVal = (device_mouse_x_to_gui(0) - owner.xPos) / owner.width;
			global.musVolume = owner.slideVal;
			audio_master_gain(global.musVolume);
		},
		init : function(owner){
			owner.slideVal = global.musVolume;
		}
	},
	effectVolume : {
		type : GUI.SLIDER,
		text : "Effect Volume",
		slideVal : global.effVolume,
		onClick : function(){},
		onHold : function(owner){
			with (objMenuComponent){
				active = false;	
			}
			owner.active = true;
			owner.slideVal = (device_mouse_x_to_gui(0) - owner.xPos) / owner.width;
			global.effVolume = owner.slideVal;
			audio_master_gain(global.effVolume);
		},
		init : function(owner){
			owner.slideVal = global.effVolume;
		}
	}
}

//case PMENU.MASVOLUME:
//				with (butt){
//					type = GUI.SLIDER;
//					data.text = "Master Volume";
//					slideVal = global.masVolume;
//					onHold = function(){
//						slideVal = (device_mouse_x_to_gui(0) - xPos) / width;
//						global.masVolume = slideVal;
//						audio_master_gain(global.masVolume);
//					}
//				}
//				break;
//			case PMENU.MUSVOLUME:
//				with (butt){
//					type = GUI.SLIDER;
//					data.text = "Music Volume";
//					slideVal = global.musVolume;
//					onHold = function(){
//						slideVal = (device_mouse_x_to_gui(0) - xPos) / width;
//						global.musVolume = slideVal;
//					}
//				}
//				break;
//			case PMENU.EFFVOLUME:
//				with (butt){
//					type = GUI.SLIDER;
//					data.text = "Effect Volume";
//					slideVal = global.effVolume;
//					onHold = function(){
//						slideVal = (device_mouse_x_to_gui(0) - xPos) / width;
//						global.effVolume = slideVal;
//					}
//				}
//				break;
enum MAINMEN{
	START,
	SINGLE,
	MULTI,
	LOAD,
	OPTIONS
}

buttXpos = display_get_gui_width() * .5 - 64;
buttYpos = display_get_gui_height() * .45;
state = MAINMEN.START;
prevState = state;
options = [];
selected = 0;
members = 0;
buttons = [];

//doOperation = function(op){
//	switch(op){
//		case TESTOPS.BUILDTEAM:
//			state = TESTOPS.BUILDTEAM;
//			objGame.generatePlayer(-1, RACE.HUMAN);
//			options = [CHARS.VETERAN, CHARS.ARCHER, CHARS.ASSASSIN, CHARS.HEALER, CHARS.TINKERER];
//			loadButtons();
//			break;
//		case TESTOPS.SELECTMEM:
//			var mem = getClass(options[selected]);
//			array_push(objPlayer.team, objPlayer.loadCompanion(mem));
//			array_delete(options, selected, 1);
//			loadButtons();
//			if (++members >= 3){
//				state = TESTOPS.CHOOSEFIGHT;
//				options = [TESTOPS.START];
//				loadButtons();
//			}
//			break;
//		case TESTOPS.START:
//			scrStartBattle(rmTestSelect, objPlayer.team, "test");
//			break;
//		case TESTOPS.SERVER:
//			room_goto(rmServer);
//			break;
//		case TESTOPS.OVERWORLD:
//			objGame.storyGenPlayer();
//			objPlayer.persistent = true;
//			room_goto(rmPrologue1);
//			break;
//		case TESTOPS.QUIT:
//			game_end(0);
//			break;
//	}
//}

//getClass = function(char){
//	var mem = "";
//	switch(char){
//		case CHARS.ARCHER:
//			mem = "archer";
//			break;
//		case CHARS.ASSASSIN:
//			mem = "assassin";
//			break;
//		case CHARS.HEALER:
//			mem = "mage";
//			break;
//		case CHARS.TINKERER:
//			mem = "tinkerer";
//			break;
//		case CHARS.VETERAN:
//			mem = "veteran";
//			break;
//	}
//	return mem;
//}

updateSelection = function(dir){
	buttons[selected].hovered = false;
	selected = (selected + dir + array_length(options)) mod array_length(options);
	buttons[selected].isKeySelected = true;
	buttons[selected].hovered = true;
}


loadButtons = function(){
	buttons = [];
	switch(state){
		case (MAINMEN.START):
			options = [menuFunctions.singlePlayer, menuFunctions.multiPlayer, menuFunctions.options, menuFunctions.quit];
			break;
		case (MAINMEN.SINGLE):
			options = [menuFunctions.newGame, menuFunctions.loadGame, menuFunctions.back];
			break;
		case (MAINMEN.OPTIONS):
			options = [menuFunctions.masterVolume, menuFunctions.musicVolume, menuFunctions.effectVolume, menuFunctions.back];
			break;
	}
	instance_destroy(objMenuComponent);
	for(var i = 0; i < array_length(options); ++i){
		var butt = createButton(buttXpos, buttYpos + (36 * i), 128, 32, sprButtonTest, options[i][$"type"], {text : options[i][$"text"]});
		butt.onClick = options[i][$"onClick"];
		if (butt.type == GUI.SLIDER){
			butt.data.toHold = options[i].onHold;
			butt.data.init = options[i].init;
			butt.slideVal = options[i].slideVal;
			with (butt){
				data.init(id);
				onHold = function() {data.toHold(id)};
			}
		}
		array_push(buttons, butt);
	}
	//switch(state){
	//	case TESTOPS.START:
	//		for(var i = 0; i < array_length(options); ++i){
	//			var butt = createButton(buttXpos, buttYpos + (36 * i), 128, 32, sprButtonTest, GUI.TEXTBUTTON, {text : getOpText(options[i]), op : options[i]});
	//			with(butt){
	//				onClick = function(){
	//					objBattleTestMenu.doOperation(data.op);
	//				}
	//			}
	//			array_push(buttons, butt);
	//		}
	//		break;
	//	case TESTOPS.BUILDTEAM:
	//		for(var i = 0; i < array_length(options); ++i){
	//			var butt = createButton(buttXpos, buttYpos + (36 * i), 128, 32, sprButtonTest, GUI.TEXTBUTTON, {text : getClass(options[i]), char : options[i], index : i});
	//			with(butt){
	//				onClick = function(){
	//					objBattleTestMenu.doOperation(TESTOPS.SELECTMEM);
	//				}
	//				onHover = function(){
	//					objBattleTestMenu.selected = data.index;
	//				}
	//			}
	//			array_push(buttons, butt);
	//		}
	//		break;
	//	case TESTOPS.CHOOSEFIGHT:
	//		for(var i = 0; i < array_length(options); ++i){
	//			var butt = createButton(buttXpos, buttYpos + (36 * i), 128, 32, sprButtonTest, GUI.TEXTBUTTON, {text : "Start Battle"});
	//			with(butt){
	//				onClick = function(){
	//					objBattleTestMenu.doOperation(TESTOPS.START);
	//				}
	//			}
	//			array_push(buttons, butt);
	//		}
	//}
}
loadButtons();