// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function getCutscene(csId){
	var cs = struct_get(global.data.cutscenes, csId);
	var sceneInfo = variable_clone(cs);
	for(var i = 0; i < array_length(cs); ++i){
		for(var j = 0; j < array_length(cs[i]); ++j){
			if (is_string(cs[i][j])){
				var arg = asset_get_index(cs[i][j]);
				if (arg != -1){
					sceneInfo[i][j] = arg;
				} else if (string_char_at(cs[i][j], 0) == "#"){
					var col = getHexFromString(cs[i][j], c_silver);
					if (col != c_silver){
						sceneInfo[i][j] = col;	
					}
				}
			} else if (is_array(cs[i][j])){
				var obj = asset_get_index(cs[i][j][0]);
				var variable = cs[i][j][1];
				var val = variable_instance_get(obj, variable);
				sceneInfo[i][j] = val;
			}
		}
	}
	return sceneInfo;
}