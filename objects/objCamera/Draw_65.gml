var viewH = window_get_height();
var viewW = window_get_width();

var scaleH = round(viewH / camheight);
var scaleW = round(viewW / camwidth);
var scale = min(scaleH, scaleW);
view_set_wport(0, camwidth * scale);
view_set_hport(0, camheight * scale);
