// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scrMapCanMove(map, tX, tY){
	return (map.layout[# tX, tY] == MAP.EMPTY &&
	!(tX < 0 || tX > map.width) &&
	!(tY < 0 || tY > map.height)
	);
}