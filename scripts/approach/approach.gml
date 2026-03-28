// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function approach(_start, _tar, _step){
	if (_tar < _start) return max(_start - _step, _tar);
	if (_tar > _start) return min(_start + _step, _tar);
	return _tar;
}