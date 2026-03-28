// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

function getHexFromString(_hexcodeString, _default = c_black)
{
    if (not is_string(_hexcodeString))
    {
        //Let numbers through, presumably they're RGB colors already
        return is_numeric(_hexcodeString)? _hexcodeString : _default;
    }

    try
    {
        var _color = int64(ptr(string_replace(_hexcodeString, "#", "")));
        _color = ((_color & 0xFF0000) >> 16) | (_color & 0x00FF00) | ((_color & 0x0000FF) << 16);
        return _color;
    }
    catch(_exception)
    {
        return _default;
    }
}