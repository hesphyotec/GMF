// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scrMapCanMove(tX, tY){
	return (global.map.layout[# tX, tY] == MAP.EMPTY &&
	!(tX < 0 || tX > global.map.width) &&
	!(tY < 0 || tY > global.map.height)
	);
}