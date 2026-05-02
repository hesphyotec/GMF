hovered = false;
effect = {};
onHover = function(){
	var data = {
		title : effect.name,
		lines : [
		"Duration : " + string(effect.duration),
		],
		effect : effect
	}
	var info = createButton(mouse_x + 4, mouse_y + 4, 96, 64, sprInfo, GUI.HOVERINFO, data);
	info.parent = id;
	info.active = false;
	with (info){
		onStep = function(){
			data.lines = [
				"Duration : " + string(round(data.effect.duration / fps)),
			]
		}
	}
}