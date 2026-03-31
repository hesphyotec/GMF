// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function applyShaders(){
	if (!is_undefined(shaderList)){
		for(var i = 0; i < array_length(shaderList); ++i){
			var _shaderScript = shaderList[i][0];
			var _args = array_create(array_length(shaderList));
			array_copy(_args, 0, shaderList, 1, array_length(shaderList));
			scriptExecuteNArgs(_shaderScript, _args);
		}
	}
}