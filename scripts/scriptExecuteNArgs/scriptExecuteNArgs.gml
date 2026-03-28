// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scriptExecuteNArgs(scrip, args){
	var argLength = array_length(args);

	switch(argLength){
		case 0:
			script_execute(scrip);
			break;
		case 1:
			script_execute(scrip, args[0]);
			break;
		case 2:
			script_execute(scrip, args[0], args[1]);
			break;
		case 3:
			script_execute(scrip, args[0], args[1], args[2]);
			break;
		case 4:
			script_execute(scrip, args[0], args[1], args[2], args[3]);
			break;
		case 5:
			script_execute(scrip, args[0], args[1], args[2], args[3], args[4]);
			break;
		case 6:
			script_execute(scrip, args[0], args[1], args[2], args[3], args[4], args[5]);
			break;
	}
}