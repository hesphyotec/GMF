currScene = sceneInfo[scene];

var len =  array_length(currScene) - 1;
currSceneArray = array_create(len, 0);
array_copy(currSceneArray, 0, currScene, 1, len);
show_debug_message(string(currSceneArray));
scriptExecuteNArgs(currScene[0], currSceneArray);